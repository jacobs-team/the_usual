import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:the_usual/app/app.dart';

/// {@template sync_repository}
/// Mirrors the user's local data to a single Firestore document and back.
///
/// It gathers the synced blocs' state into one document, applies a downloaded
/// document onto them, and while signed in keeps the two in step: a live
/// subscription pulls remote changes down and a debounced write-through pushes
/// local changes up. It is the only place that knows about Firestore.
/// {@endtemplate}
@singleton
class SyncRepository {
  /// {@macro sync_repository}
  SyncRepository(
    this._dailyLogBloc,
    this._userSettingsBloc,
    this._onboardingBloc, [
    @ignoreParam FirebaseFirestore? firestore,
  ]) : _firestore = firestore ?? FirebaseFirestore.instance;

  final DailyLogBloc _dailyLogBloc;
  final UserSettingsBloc _userSettingsBloc;
  final OnboardingBloc _onboardingBloc;
  final FirebaseFirestore _firestore;

  /// Shape version of the cloud document, independent of the per-bloc versions
  /// nested inside it.
  static const _schemaVersion = 1;

  /// How long rapid local edits are collapsed before a single upload.
  static const _writeThroughDebounce = Duration(seconds: 3);

  /// Caps the wait for a sign-out flush so a connectivity drop after the
  /// online check cannot hang the sign-out.
  static const _flushTimeout = Duration(seconds: 10);

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _remoteSub;
  StreamSubscription<DailyLogState>? _dailyLogSub;
  StreamSubscription<UserSettingsState>? _settingsSub;
  Timer? _debounce;
  String? _uid;

  /// JSON of the document last known to match the cloud, so write-through can
  /// skip redundant uploads, including the echo of a just-applied download.
  String? _lastSyncedJson;

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _firestore.doc('users/$uid');

  /// Whether the local data marks an established user: any logged meal, more
  /// than one weigh-in day, or more than one usual meal.
  bool get hasEstablishedData {
    final settings = _userSettingsBloc.state;
    return _dailyLogBloc.state.hasEstablishedLog(settings.dayStartTime) ||
        settings.hasEstablishedUsuals;
  }

  Map<String, dynamic> _currentDocument() => {
    'schemaVersion': _schemaVersion,
    'dailyLog': _dailyLogBloc.state.toJson(),
    'userSettings': _userSettingsBloc.state.toJson(),
  };

  /// Whether the user already has a cloud document. Guards the `isNewUser`
  /// flag against the case where the Auth record exists but the document does
  /// not, so a missing document is treated as a new account rather than
  /// overwriting local data against nothing.
  Future<bool> cloudDocExists(String uid) async =>
      (await _doc(uid).get()).exists;

  /// Writes the current local state as the user's cloud document.
  Future<void> uploadLocal(String uid) async {
    final document = _currentDocument();
    await _doc(uid).set(document);
    _lastSyncedJson = jsonEncode(document);
  }

  /// Downloads the user's document and applies it to the blocs. Returns whether
  /// the downloaded data is established, which drives onboarding routing.
  Future<bool> downloadAndApply(String uid) async {
    final snapshot = await _doc(uid).get();
    final document = snapshot.data();
    if (document == null) return false;
    return _apply(document);
  }

  bool _apply(Map<String, dynamic> document) {
    final dailyLogJson = document['dailyLog'];
    final dailyLog = dailyLogJson is Map<String, dynamic>
        ? DailyLogState.fromJson(dailyLogJson)
        : const DailyLogState();
    final settingsJson = document['userSettings'];
    final settings = settingsJson is Map<String, dynamic>
        ? UserSettingsState.fromJson(settingsJson)
        : const UserSettingsState();

    if (dailyLog != _dailyLogBloc.state) {
      _dailyLogBloc.add(DailyLogEvent.stateRestored(dailyLog));
    }
    if (settings != _userSettingsBloc.state) {
      _userSettingsBloc.add(UserSettingsEvent.stateRestored(settings));
    }
    _lastSyncedJson = jsonEncode(document);
    return dailyLog.hasEstablishedLog(settings.dayStartTime) ||
        settings.hasEstablishedUsuals;
  }

  /// Begins two-way sync for [uid]: pulls remote changes onto the blocs and
  /// pushes debounced local changes up. Idempotent for the same user.
  void startWatching(String uid) {
    if (_uid == uid && _remoteSub != null) return;
    stopWatching();
    _uid = uid;
    _remoteSub = _doc(uid)
        .snapshots()
        // Skip this device's own un-acked writes echoing back, so applying a
        // remote change can't bounce back as a new upload.
        .where((snapshot) => !snapshot.metadata.hasPendingWrites)
        .listen((snapshot) {
          final document = snapshot.data();
          if (document != null) _apply(document);
        });
    _dailyLogSub = _dailyLogBloc.stream.listen((_) => _scheduleWriteThrough());
    _settingsSub = _userSettingsBloc.stream.listen(
      (_) => _scheduleWriteThrough(),
    );
  }

  void _scheduleWriteThrough() {
    _debounce?.cancel();
    _debounce = Timer(_writeThroughDebounce, _writeThroughNow);
  }

  Future<void> _writeThroughNow() async {
    final uid = _uid;
    if (uid == null) return;
    final document = _currentDocument();
    final json = jsonEncode(document);
    if (json == _lastSyncedJson) return;
    await _doc(uid).set(document);
    _lastSyncedJson = json;
  }

  /// Pushes the latest local state and awaits server confirmation before
  /// sign-out clears local data. Callers must confirm connectivity first; the
  /// timeout guards against a drop between that check and the write.
  Future<void> flushAndConfirm(String uid) async {
    _debounce?.cancel();
    final document = _currentDocument();
    final json = jsonEncode(document);
    if (json == _lastSyncedJson) return;
    await _doc(uid).set(document).timeout(_flushTimeout);
    _lastSyncedJson = json;
  }

  /// Stops two-way sync and forgets the synced user.
  void stopWatching() {
    _remoteSub?.cancel();
    _dailyLogSub?.cancel();
    _settingsSub?.cancel();
    _debounce?.cancel();
    _remoteSub = null;
    _dailyLogSub = null;
    _settingsSub = null;
    _debounce = null;
    _uid = null;
    _lastSyncedJson = null;
  }

  /// Sends the user back through onboarding, used when a sync operation leaves
  /// the device without established data.
  void resetOnboarding() =>
      _onboardingBloc.add(const OnboardingEvent.resetPressed());

  /// Marks onboarding complete without running its completion side effects, for
  /// a returning signed-in user whose cloud data has already been applied.
  /// Awaits the bloc reaching the completed step so callers can hold the splash
  /// until the router would land on the app rather than onboarding.
  Future<void> markOnboardingComplete() async {
    if (_onboardingBloc.state.step == OnboardingStep.complete) return;
    _onboardingBloc.add(const OnboardingEvent.markCompleted());
    await _onboardingBloc.stream.firstWhere(
      (state) => state.step == OnboardingStep.complete,
    );
  }

  /// Resets the synced blocs to their initial state and restarts onboarding.
  /// Used on sign-out and when starting a fresh account.
  void clearLocal() {
    _dailyLogBloc.add(const DailyLogEvent.stateRestored(DailyLogState()));
    _userSettingsBloc.add(
      const UserSettingsEvent.stateRestored(UserSettingsState()),
    );
    resetOnboarding();
    _lastSyncedJson = null;
  }
}
