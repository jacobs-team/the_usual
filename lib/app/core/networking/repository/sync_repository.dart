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
    this._workoutLogBloc,
    this._userSettingsBloc,
    this._onboardingBloc, [
    @ignoreParam FirebaseFirestore? firestore,
  ]) : _firestore = firestore ?? FirebaseFirestore.instance;

  final DailyLogBloc _dailyLogBloc;
  final WorkoutLogBloc _workoutLogBloc;
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
  StreamSubscription<WorkoutLogState>? _workoutLogSub;
  Timer? _debounce;
  String? _uid;

  /// JSON of the document last known to match the cloud, so write-through can
  /// skip redundant uploads, including the echo of a just-applied download.
  String? _lastSyncedJson;

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _firestore.doc('users/$uid');

  /// Whether the local data marks an established user: any logged meal, more
  /// than one weigh-in day, more than one usual meal, or any logged workout.
  bool get hasEstablishedData {
    final settings = _userSettingsBloc.state;
    return _dailyLogBloc.state.hasEstablishedLog(settings.dayStartTime) ||
        settings.hasEstablishedUsuals ||
        _workoutLogBloc.state.workoutEntries.isNotEmpty;
  }

  Map<String, dynamic> _documentOf(
    DailyLogState dailyLog,
    UserSettingsState settings,
    WorkoutLogState workoutLog,
  ) => {
    'schemaVersion': _schemaVersion,
    'dailyLog': dailyLog.toJson(),
    'userSettings': settings.toJson(),
    'workoutLog': workoutLog.toJson(),
  };

  Map<String, dynamic> _currentDocument() => _documentOf(
    _dailyLogBloc.state,
    _userSettingsBloc.state,
    _workoutLogBloc.state,
  );

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
    final version = document['schemaVersion'] as int? ?? 0;
    final migrated = _migratedDocument(document, version);
    if (migrated == null) {
      // An envelope version newer than this build understands (e.g. the user
      // downgraded). Reading it with the current shape would drop the unknown
      // keys, and the next write-through would upload that lossy document back
      // over good cloud data, so leave local state untouched instead.
      return _dailyLogBloc.state.hasEstablishedLog(
            _userSettingsBloc.state.dayStartTime,
          ) ||
          _userSettingsBloc.state.hasEstablishedUsuals;
    }

    final dailyLogJson = migrated['dailyLog'];
    final dailyLog = dailyLogJson is Map<String, dynamic>
        ? DailyLogState.fromJson(dailyLogJson)
        : const DailyLogState();
    final settingsJson = migrated['userSettings'];
    final settings = settingsJson is Map<String, dynamic>
        ? UserSettingsState.fromJson(settingsJson)
        : const UserSettingsState();
    final workoutLogJson = migrated['workoutLog'];
    final workoutLog = workoutLogJson is Map<String, dynamic>
        ? WorkoutLogState.fromJson(workoutLogJson)
        : const WorkoutLogState();

    // Compare ignoring the transient justLoggedEntryId, which the cloud doc
    // can't carry, so an echo of our own write doesn't clear the quick-edit
    // highlight by restoring an otherwise-identical state.
    if (dailyLog != _dailyLogBloc.state.copyWith(justLoggedEntryId: null)) {
      _dailyLogBloc.add(DailyLogEvent.stateRestored(dailyLog));
    }
    if (settings != _userSettingsBloc.state) {
      _userSettingsBloc.add(UserSettingsEvent.stateRestored(settings));
    }
    final workoutLogEcho = _workoutLogBloc.state.copyWith(
      justLoggedWorkoutId: null,
    );
    if (workoutLog != workoutLogEcho) {
      _workoutLogBloc.add(WorkoutLogEvent.stateRestored(workoutLog));
    }
    // Store the canonical encoding (from toJson) rather than the raw document,
    // whose key order can differ, so write-through recognises it as unchanged
    // and skips a redundant upload.
    _lastSyncedJson = jsonEncode(_documentOf(dailyLog, settings, workoutLog));
    return dailyLog.hasEstablishedLog(settings.dayStartTime) ||
        settings.hasEstablishedUsuals;
  }

  /// Brings a cloud [document] up to the current [_schemaVersion] envelope
  /// shape, or returns null when [version] is one this build cannot read.
  ///
  /// This routes on the outer envelope version (the top-level key layout),
  /// which is separate from the per-bloc versions nested inside each section.
  /// When the envelope shape changes in a future version, map the old layout to
  /// the current keys here so [_apply] never misreads a moved key as an absent
  /// one and restores empty state over the user's data.
  Map<String, dynamic>? _migratedDocument(
    Map<String, dynamic> document,
    int version,
  ) {
    switch (version) {
      case 0:
      case _schemaVersion:
        // v0 (unversioned early documents) used the same top-level keys as v1,
        // so both read with the current layout as-is.
        return document;
      default:
        // Newer than we understand: refuse rather than read lossily.
        return null;
    }
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
    _workoutLogSub = _workoutLogBloc.stream.listen(
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

  /// Fires any pending debounced write immediately, used when the app is
  /// backgrounded.
  void flushPending() {
    _debounce?.cancel();
    _debounce = null;
    unawaited(_writeThroughNow());
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
    unawaited(_remoteSub?.cancel());
    unawaited(_dailyLogSub?.cancel());
    unawaited(_settingsSub?.cancel());
    unawaited(_workoutLogSub?.cancel());
    _debounce?.cancel();
    _remoteSub = null;
    _dailyLogSub = null;
    _settingsSub = null;
    _workoutLogSub = null;
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
  /// Used on sign-out and when starting a fresh account. Awaits the resets so a
  /// caller that reads bloc state next (e.g. uploading a fresh, empty document)
  /// never sees the pre-clear data — `bloc.add` is asynchronous.
  Future<void> clearLocal() async {
    resetOnboarding();
    _lastSyncedJson = null;
    final waits = <Future<void>>[];
    if (_dailyLogBloc.state != const DailyLogState()) {
      _dailyLogBloc.add(const DailyLogEvent.stateRestored(DailyLogState()));
      waits.add(
        _dailyLogBloc.stream.firstWhere((s) => s == const DailyLogState()),
      );
    }
    if (_userSettingsBloc.state != const UserSettingsState()) {
      _userSettingsBloc.add(
        const UserSettingsEvent.stateRestored(UserSettingsState()),
      );
      waits.add(
        _userSettingsBloc.stream.firstWhere(
          (s) => s == const UserSettingsState(),
        ),
      );
    }
    if (_workoutLogBloc.state != const WorkoutLogState()) {
      _workoutLogBloc.add(
        const WorkoutLogEvent.stateRestored(WorkoutLogState()),
      );
      waits.add(
        _workoutLogBloc.stream.firstWhere(
          (s) => s == const WorkoutLogState(),
        ),
      );
    }
    await Future.wait(waits);
  }
}
