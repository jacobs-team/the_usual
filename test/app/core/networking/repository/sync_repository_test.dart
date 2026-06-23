import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

class MockFirestore extends Mock implements FirebaseFirestore {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

class MockSnapshotMetadata extends Mock implements SnapshotMetadata {}

void main() {
  const uid = 'user-1';

  final establishedDailyLog = DailyLogState(
    mealEntries: [
      MealLogEntry(
        id: 'm1',
        loggedAt: DateTime(2026, 6, 22, 8),
        mealOfTheDay: MealOfTheDay.breakfast,
        name: 'Eggs',
      ),
    ],
  );

  const establishedSettings = UserSettingsState(
    usuals: {
      MealOfTheDay.breakfast: [
        UsualMeal(id: 'u1', name: 'Eggs'),
        UsualMeal(id: 'u2', name: 'Oats'),
      ],
    },
  );

  Map<String, dynamic> documentFor(
    DailyLogState dailyLog,
    UserSettingsState settings,
  ) => {
    'schemaVersion': 1,
    'dailyLog': dailyLog.toJson(),
    'userSettings': settings.toJson(),
  };

  late MockFirestore firestore;
  late MockDocumentReference docRef;
  late DailyLogBloc dailyLogBloc;
  late UserSettingsBloc userSettingsBloc;
  late OnboardingBloc onboardingBloc;
  late SyncRepository repository;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    initHydratedStorage();
    firestore = MockFirestore();
    docRef = MockDocumentReference();

    when(() => firestore.doc(any())).thenReturn(docRef);
    when(() => docRef.set(any())).thenAnswer((_) async {});

    dailyLogBloc = DailyLogBloc();
    userSettingsBloc = UserSettingsBloc();
    onboardingBloc = OnboardingBloc();

    repository = SyncRepository(
      dailyLogBloc,
      userSettingsBloc,
      onboardingBloc,
      firestore,
    );
  });

  tearDown(() async {
    repository.stopWatching();
    await dailyLogBloc.close();
    await userSettingsBloc.close();
    await onboardingBloc.close();
  });

  MockDocumentSnapshot snapshotWith(
    Map<String, dynamic>? data, {
    bool exists = true,
    bool hasPendingWrites = false,
  }) {
    final snapshot = MockDocumentSnapshot();
    final metadata = MockSnapshotMetadata();
    when(snapshot.data).thenReturn(data);
    when(() => snapshot.exists).thenReturn(exists);
    when(() => snapshot.metadata).thenReturn(metadata);
    when(() => metadata.hasPendingWrites).thenReturn(hasPendingWrites);
    return snapshot;
  }

  group(SyncRepository, () {
    test('falls back to FirebaseFirestore.instance when none is given', () {
      expect(
        () => SyncRepository(dailyLogBloc, userSettingsBloc, onboardingBloc),
        throwsA(isA<FirebaseException>()),
      );
    });

    group('hasEstablishedData', () {
      test('is false when nothing is logged', () {
        expect(repository.hasEstablishedData, isFalse);
      });

      test('is true when there is a logged meal', () async {
        dailyLogBloc.add(DailyLogEvent.stateRestored(establishedDailyLog));
        await pumpEventQueue();
        expect(repository.hasEstablishedData, isTrue);
      });

      test('is true when there are established usuals', () async {
        userSettingsBloc.add(
          const UserSettingsEvent.stateRestored(establishedSettings),
        );
        await pumpEventQueue();
        expect(repository.hasEstablishedData, isTrue);
      });
    });

    group('cloudDocExists', () {
      test('is true when the document exists', () async {
        when(() => docRef.get()).thenAnswer(
          (_) async => snapshotWith(<String, dynamic>{}),
        );
        expect(await repository.cloudDocExists(uid), isTrue);
      });

      test('is false when the document does not exist', () async {
        when(() => docRef.get()).thenAnswer(
          (_) async => snapshotWith(null, exists: false),
        );
        expect(await repository.cloudDocExists(uid), isFalse);
      });
    });

    group('uploadLocal', () {
      test('writes the current local state to the cloud document', () async {
        await repository.uploadLocal(uid);

        final captured =
            verify(() => docRef.set(captureAny())).captured.single
                as Map<String, dynamic>;
        expect(captured['schemaVersion'], equals(1));
        expect(captured['dailyLog'], isNotNull);
        expect(captured['userSettings'], isNotNull);
      });
    });

    group('downloadAndApply', () {
      test('returns false when the document is null', () async {
        when(() => docRef.get()).thenAnswer((_) async => snapshotWith(null));
        expect(await repository.downloadAndApply(uid), isFalse);
      });

      test('applies an established document and returns true', () async {
        final document = documentFor(establishedDailyLog, establishedSettings);
        when(
          () => docRef.get(),
        ).thenAnswer((_) async => snapshotWith(document));

        final result = await repository.downloadAndApply(uid);
        expect(result, isTrue);

        await pumpEventQueue();
        expect(dailyLogBloc.state.mealEntries, isNotEmpty);
        expect(userSettingsBloc.state.usualMealCount, equals(2));
      });

      test('falls back to defaults when nested json is not a map', () async {
        final document = <String, dynamic>{
          'schemaVersion': 1,
          'dailyLog': 'not-a-map',
          'userSettings': 42,
        };
        when(
          () => docRef.get(),
        ).thenAnswer((_) async => snapshotWith(document));

        final result = await repository.downloadAndApply(uid);
        expect(result, isFalse);
      });

      test(
        'does not re-dispatch when the doc matches state ignoring '
        'justLoggedEntryId',
        () async {
          dailyLogBloc.add(
            DailyLogEvent.stateRestored(
              establishedDailyLog.copyWith(justLoggedEntryId: 'm1'),
            ),
          );
          userSettingsBloc.add(
            const UserSettingsEvent.stateRestored(establishedSettings),
          );
          await pumpEventQueue();

          final document = documentFor(
            establishedDailyLog,
            establishedSettings,
          );
          when(
            () => docRef.get(),
          ).thenAnswer((_) async => snapshotWith(document));

          final dailyLogEmissions = <DailyLogState>[];
          final settingsEmissions = <UserSettingsState>[];
          final dailyLogSub = dailyLogBloc.stream.listen(
            dailyLogEmissions.add,
          );
          final settingsSub = userSettingsBloc.stream.listen(
            settingsEmissions.add,
          );

          final result = await repository.downloadAndApply(uid);
          await pumpEventQueue();

          expect(result, isTrue);
          expect(dailyLogEmissions, isEmpty);
          expect(settingsEmissions, isEmpty);
          expect(dailyLogBloc.state.justLoggedEntryId, equals('m1'));

          await dailyLogSub.cancel();
          await settingsSub.cancel();
        },
      );
    });

    group('startWatching', () {
      test('applies a remote snapshot without pending writes', () async {
        final controller =
            StreamController<DocumentSnapshot<Map<String, dynamic>>>();
        when(() => docRef.snapshots()).thenAnswer((_) => controller.stream);

        repository.startWatching(uid);

        final document = documentFor(establishedDailyLog, establishedSettings);
        controller.add(snapshotWith(document));
        await pumpEventQueue();

        expect(dailyLogBloc.state.mealEntries, isNotEmpty);
        expect(userSettingsBloc.state.usualMealCount, equals(2));

        await controller.close();
      });

      test('ignores a remote snapshot with pending writes', () async {
        final controller =
            StreamController<DocumentSnapshot<Map<String, dynamic>>>();
        when(() => docRef.snapshots()).thenAnswer((_) => controller.stream);

        repository.startWatching(uid);

        final document = documentFor(establishedDailyLog, establishedSettings);
        controller.add(snapshotWith(document, hasPendingWrites: true));
        await pumpEventQueue();

        expect(dailyLogBloc.state.mealEntries, isEmpty);

        await controller.close();
      });

      test('ignores a remote snapshot whose data is null', () async {
        final controller =
            StreamController<DocumentSnapshot<Map<String, dynamic>>>();
        when(() => docRef.snapshots()).thenAnswer((_) => controller.stream);

        repository.startWatching(uid);

        controller.add(snapshotWith(null));
        await pumpEventQueue();

        expect(dailyLogBloc.state, equals(const DailyLogState()));

        await controller.close();
      });

      test('is idempotent for the same uid', () async {
        final controller =
            StreamController<DocumentSnapshot<Map<String, dynamic>>>();
        when(() => docRef.snapshots()).thenAnswer((_) => controller.stream);

        repository
          ..startWatching(uid)
          ..startWatching(uid);

        verify(() => docRef.snapshots()).called(1);

        await controller.close();
      });

      test('restarts the subscription for a different uid', () async {
        final controller =
            StreamController<
              DocumentSnapshot<Map<String, dynamic>>
            >.broadcast();
        when(() => docRef.snapshots()).thenAnswer((_) => controller.stream);

        repository
          ..startWatching(uid)
          ..startWatching('user-2');

        verify(() => docRef.snapshots()).called(2);

        await controller.close();
      });
    });

    group('write-through debounce', () {
      // These run blocs and the repository inside the fake zone so the bloc
      // streams and the debounce timer share the same fake clock.
      test('uploads once after the debounce when local state changes', () {
        fakeAsync((async) {
          final localDailyLog = DailyLogBloc();
          final localSettings = UserSettingsBloc();
          final localOnboarding = OnboardingBloc();
          final localRepository = SyncRepository(
            localDailyLog,
            localSettings,
            localOnboarding,
            firestore,
          );
          final controller =
              StreamController<DocumentSnapshot<Map<String, dynamic>>>();
          when(() => docRef.snapshots()).thenAnswer((_) => controller.stream);

          localRepository.startWatching(uid);

          localDailyLog.add(
            DailyLogEvent.stateRestored(establishedDailyLog),
          );
          async.elapse(Duration.zero);

          verifyNever(() => docRef.set(any()));

          async.elapse(const Duration(seconds: 3));

          verify(() => docRef.set(any())).called(1);

          localRepository.stopWatching();
          controller.close();
          localDailyLog.close();
          localSettings.close();
          localOnboarding.close();
        });
      });

      test('skips the upload when state is unchanged from last synced', () {
        fakeAsync((async) {
          final localDailyLog = DailyLogBloc();
          final localSettings = UserSettingsBloc();
          final localOnboarding = OnboardingBloc();
          final localRepository = SyncRepository(
            localDailyLog,
            localSettings,
            localOnboarding,
            firestore,
          );
          final controller =
              StreamController<DocumentSnapshot<Map<String, dynamic>>>();
          when(() => docRef.snapshots()).thenAnswer((_) => controller.stream);

          localRepository.startWatching(uid);

          // Apply an identical remote doc so _lastSyncedJson matches the
          // current local state. Then re-apply the same doc, which emits no
          // new bloc state, and confirm the debounce never uploads.
          final document = documentFor(
            const DailyLogState(),
            const UserSettingsState(),
          );
          controller.add(snapshotWith(document));
          async.elapse(Duration.zero);

          // Force a scheduled write directly: a no-op restore that emits the
          // same state still pushes through the stream listener.
          localDailyLog.add(
            DailyLogEvent.stateRestored(establishedDailyLog),
          );
          async.elapse(Duration.zero);
          // Now restore back to the synced (empty) state so the document
          // matches _lastSyncedJson again before the debounce fires.
          localDailyLog.add(
            const DailyLogEvent.stateRestored(DailyLogState()),
          );
          async.elapse(const Duration(seconds: 3));

          verifyNever(() => docRef.set(any()));

          localRepository.stopWatching();
          controller.close();
          localDailyLog.close();
          localSettings.close();
          localOnboarding.close();
        });
      });

      test('does nothing when fired after the uid is cleared', () {
        fakeAsync((async) {
          final localDailyLog = DailyLogBloc();
          final localSettings = UserSettingsBloc();
          final localOnboarding = OnboardingBloc();
          final localRepository = SyncRepository(
            localDailyLog,
            localSettings,
            localOnboarding,
            firestore,
          );
          final controller =
              StreamController<DocumentSnapshot<Map<String, dynamic>>>();
          when(() => docRef.snapshots()).thenAnswer((_) => controller.stream);

          localRepository.startWatching(uid);

          localDailyLog.add(
            DailyLogEvent.stateRestored(establishedDailyLog),
          );
          async.elapse(Duration.zero);

          localRepository.stopWatching();

          async.elapse(const Duration(seconds: 3));

          verifyNever(() => docRef.set(any()));

          controller.close();
          localDailyLog.close();
          localSettings.close();
          localOnboarding.close();
        });
      });
    });

    group('flushAndConfirm', () {
      test('skips the upload when the state is unchanged', () async {
        await repository.uploadLocal(uid);
        clearInteractions(docRef);

        await repository.flushAndConfirm(uid);

        verifyNever(() => docRef.set(any()));
      });

      test('uploads when the state has changed', () async {
        dailyLogBloc.add(DailyLogEvent.stateRestored(establishedDailyLog));
        await pumpEventQueue();

        await repository.flushAndConfirm(uid);

        verify(() => docRef.set(any())).called(1);
      });
    });

    group('stopWatching', () {
      test('cancels subscriptions and forgets the user', () async {
        final controller =
            StreamController<
              DocumentSnapshot<Map<String, dynamic>>
            >.broadcast();
        when(() => docRef.snapshots()).thenAnswer((_) => controller.stream);

        repository
          ..startWatching(uid)
          ..stopWatching()
          ..startWatching(uid);

        verify(() => docRef.snapshots()).called(2);

        await controller.close();
      });
    });

    group('resetOnboarding', () {
      test('sends the onboarding bloc back to the start', () async {
        onboardingBloc.add(const OnboardingEvent.markCompleted());
        await pumpEventQueue();
        expect(onboardingBloc.state.step, equals(OnboardingStep.complete));

        repository.resetOnboarding();
        await pumpEventQueue();

        expect(onboardingBloc.state.step, equals(OnboardingStep.welcome));
      });
    });

    group('markOnboardingComplete', () {
      test('returns immediately when already complete', () async {
        onboardingBloc.add(const OnboardingEvent.markCompleted());
        await pumpEventQueue();
        expect(onboardingBloc.state.step, equals(OnboardingStep.complete));

        await repository.markOnboardingComplete();

        expect(onboardingBloc.state.step, equals(OnboardingStep.complete));
      });

      test('awaits the completed step when not yet complete', () async {
        expect(onboardingBloc.state.step, equals(OnboardingStep.welcome));

        await repository.markOnboardingComplete();

        expect(onboardingBloc.state.step, equals(OnboardingStep.complete));
      });
    });

    group('clearLocal', () {
      test('resets blocs and onboarding when state differs', () async {
        dailyLogBloc.add(DailyLogEvent.stateRestored(establishedDailyLog));
        userSettingsBloc.add(
          const UserSettingsEvent.stateRestored(establishedSettings),
        );
        await pumpEventQueue();

        await repository.clearLocal();

        expect(dailyLogBloc.state, equals(const DailyLogState()));
        expect(userSettingsBloc.state, equals(const UserSettingsState()));
        expect(onboardingBloc.state.step, equals(OnboardingStep.welcome));
      });

      test('completes without waiting when state is already initial', () async {
        await repository.clearLocal();

        expect(dailyLogBloc.state, equals(const DailyLogState()));
        expect(userSettingsBloc.state, equals(const UserSettingsState()));
      });
    });
  });
}
