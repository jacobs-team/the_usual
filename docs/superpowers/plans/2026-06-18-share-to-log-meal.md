# Share-to-Log a Meal Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a "Log meal" OS share target that opens the app, AI-estimates the shared photo(s), and pre-fills the existing entry sheet targeted at the current meal slot for the user to confirm — and move the bloated add-meal form logic into a bloc along the way.

**Architecture:** Three phases. (1) Extract the add-meal form's logic into a widget-owned `FoodEntryBloc`, no behavior change. (2) Let the AI estimate run on several photos at once and lift the one-photo limit. (3) Wire `receive_sharing_intent` so a share opens the seeded entry sheet with a meal-slot selector. Logging stays with the caller; the bloc owns only drafting and estimation.

**Tech Stack:** Flutter, flutter_bloc, freezed, json_serializable, injectable/get_it, image_picker, receive_sharing_intent, genkit + genkit_anthropic (Claude), mocktail + bloc_test.

## Global Constraints

- Use `fvm flutter` for every Flutter CLI command. Tests: `fvm flutter test --test-randomize-ordering-seed random`.
- **Never run the code generator.** build_runner watches in the background. After creating or editing a `@freezed`/`@JsonSerializable`/`@injectable` file, wait for generation to finish, then run the analyzer (`fvm dart analyze <file>`) to confirm. If generation is not running, stop and ask the developer to start it.
- **Never run `git commit`/`git push`.** Commit steps mean: stop, tell the developer exactly what changed, and give the suggested message for them to commit.
- **Never run the app.** Where a step needs the app run (native share smoke test), hand it to the developer and wait.
- Always use barrel files, not direct imports across features.
- `@freezed` for all data classes, bloc states, and bloc events. States/events split into `part` files (`_bloc.dart`, `_event.dart`, `_state.dart`) with a `bloc.dart` barrel, mirroring `feature/user_settings/bloc/`.
- Exhaustive `switch` in `on<Event>`. Async handlers wrap try/catch, emit `generating` before the call and `idle`/`failure` after.
- Get bloc instances via `getIt<T>()`; do not use `context.read<T>()`. Feature widgets get state via `BlocSelector` (record selector when reading several pieces).
- Name variables after their full model type (`mealOfTheDay`, not `meal`).
- Tests: matchers not raw asserts; prefer `isA<State>().having(...)` over whole-state equality; `mocktail` for mocks; find widgets by type/key/icon, never by UI copy text; `initHydratedStorage()` in setup when a `HydratedBloc` is involved.
- Comments describe what a thing IS, never a changelog of the change.
- Platforms: iOS and Android only for the share target. Web keeps the in-app flow untouched.

---

# Phase 1 — `FoodEntryBloc` refactor (no behavior change)

End state: `FoodEntryForm`/`FoodEntrySheet` behave exactly as today, but their drafts, mode, generating flag, and AI orchestration live in a widget-owned `FoodEntryBloc`. Still single-photo. `MealPhoto` becomes a freezed model.

### Task 1: Convert `MealPhoto` from a record typedef to a freezed model

Reason: `MealPhoto` is about to be used by the picker, the bloc, the repository, the AI client, and the share service. Per the typedef-vs-model rule, reused/cross-feature data is a freezed model, and moving it to `lib/app/model/` lets `core/` reference it without depending on a `widgets/` file.

**Files:**

- Create: `lib/app/model/meal_photo.dart`
- Modify: `lib/app/model/model.dart` (barrel — add export)
- Modify: `lib/app/widgets/inputs/meal_photo_picker.dart:14` (remove the typedef; import the model via the app barrel)
- Test: `test/app/model/meal_photo_test.dart`

**Interfaces:**

- Produces: `MealPhoto` freezed model with `Uint8List bytes` and `String mediaType` (default `'image/jpeg'`). Equality is identity on `bytes` (freezed default for `Uint8List`); tests assert on `.length`/`.mediaType`, never whole-object equality of photos.

- [ ] **Step 1: Write the failing test**

```dart
// test/app/model/meal_photo_test.dart
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(MealPhoto, () {
    test('defaults mediaType to image/jpeg', () {
      final photo = MealPhoto(bytes: Uint8List.fromList([1, 2, 3]));
      expect(photo.mediaType, equals('image/jpeg'));
      expect(photo.bytes, hasLength(3));
    });

    test('keeps the supplied mediaType', () {
      final photo = MealPhoto(
        bytes: Uint8List.fromList([1]),
        mediaType: 'image/png',
      );
      expect(photo.mediaType, equals('image/png'));
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `fvm flutter test test/app/model/meal_photo_test.dart`
Expected: FAIL — `MealPhoto` is a record typedef, not a class with named constructor `MealPhoto(bytes:, mediaType:)`.

- [ ] **Step 3: Create the model**

```dart
// lib/app/model/meal_photo.dart
import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'meal_photo.freezed.dart';

/// {@template meal_photo}
/// A photo chosen for AI meal estimation: its raw [bytes] and the [mediaType]
/// MIME string Claude needs (`image/jpeg`, `image/png`, `image/gif`, or
/// `image/webp`). Shared by the photo picker, the entry bloc, the AI
/// repository/client, and the share-ingest service.
/// {@endtemplate}
@freezed
abstract class MealPhoto with _$MealPhoto {
  /// {@macro meal_photo}
  const factory MealPhoto({
    required Uint8List bytes,
    @Default('image/jpeg') String mediaType,
  }) = _MealPhoto;
}
```

- [ ] **Step 4: Export it and drop the typedef**

Add to `lib/app/model/model.dart`:

```dart
export 'meal_photo.dart';
```

In `lib/app/widgets/inputs/meal_photo_picker.dart`, delete the `typedef MealPhoto = ...;` (line 14) and its doc comment. Update `pickMealPhoto`'s return to build the model:

```dart
  return MealPhoto(bytes: bytes, mediaType: _imageMediaType(picked));
```

Add `import 'package:the_usual/app/app.dart';` if not already importing the barrel that re-exports models. (`meal_photo_picker.dart` already imports `image_picker`; add the app barrel for `MealPhoto`.)

- [ ] **Step 5: Wait for generation, run analyzer and tests**

Wait for build_runner to emit `meal_photo.freezed.dart`.
Run: `fvm dart analyze lib/app/model/meal_photo.dart lib/app/widgets/inputs/meal_photo_picker.dart`
Run: `fvm flutter test test/app/model/meal_photo_test.dart`
Expected: analyzer clean, test PASS.

- [ ] **Step 6: Commit**

Tell the developer: `MealPhoto` is now a freezed model in `lib/app/model/`, the picker builds it instead of a record. Suggested message: `refactor: make MealPhoto a freezed model`.

---

### Task 2: `FoodDraft` model

**Files:**

- Create: `lib/app/model/food_draft.dart`
- Modify: `lib/app/model/model.dart` (barrel)
- Test: `test/app/model/food_draft_test.dart`

**Interfaces:**

- Produces: `FoodDraft` freezed model: `String id`, `String name` (default `''`), `double quantity` (default `1`), `Nutrition nutrition` (default `Nutrition()`), `bool addToUsualMeals` (default `false`). In-memory only, not persisted, so no `fromJson`/migration.

- [ ] **Step 1: Write the failing test**

```dart
// test/app/model/food_draft_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(FoodDraft, () {
    test('has sensible defaults', () {
      const draft = FoodDraft(id: 'a');
      expect(draft.name, isEmpty);
      expect(draft.quantity, equals(1.0));
      expect(draft.nutrition, equals(const Nutrition()));
      expect(draft.addToUsualMeals, isFalse);
    });

    test('copyWith updates a single field', () {
      const draft = FoodDraft(id: 'a');
      expect(draft.copyWith(name: 'Toast').name, equals('Toast'));
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `fvm flutter test test/app/model/food_draft_test.dart`
Expected: FAIL — `FoodDraft` undefined.

- [ ] **Step 3: Create the model**

```dart
// lib/app/model/food_draft.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_usual/app/model/model.dart';

part 'food_draft.freezed.dart';

/// {@template food_draft}
/// One editable food row being captured in the meal-entry form: its [name],
/// per-unit [nutrition], [quantity], and whether to also save it as a usual.
/// The [id] is a uuid generated when the draft is created; it keys the row's
/// text controller so an AI estimate that replaces the rows rebuilds them
/// cleanly. In-memory only — never persisted.
/// {@endtemplate}
@freezed
abstract class FoodDraft with _$FoodDraft {
  /// {@macro food_draft}
  const factory FoodDraft({
    required String id,
    @Default('') String name,
    @Default(1) double quantity,
    @Default(Nutrition()) Nutrition nutrition,
    @Default(false) bool addToUsualMeals,
  }) = _FoodDraft;
}
```

Add to `lib/app/model/model.dart`:

```dart
export 'food_draft.dart';
```

- [ ] **Step 4: Wait for generation, run analyzer and test**

Run: `fvm dart analyze lib/app/model/food_draft.dart`
Run: `fvm flutter test test/app/model/food_draft_test.dart`
Expected: analyzer clean, test PASS.

- [ ] **Step 5: Commit**

Suggested message: `feat: add FoodDraft model for the meal-entry bloc`.

---

### Task 3: `MealEntryState`, `MealEntryStatus`, and `MealEntryEvent`

**Files:**

- Create: `lib/app/feature/meal_entry/bloc/meal_entry_bloc.dart` (declares the bloc class + `part` directives; the class body is filled in Tasks 4–5)
- Create: `lib/app/feature/meal_entry/bloc/meal_entry_state.dart`
- Create: `lib/app/feature/meal_entry/bloc/meal_entry_event.dart`
- Create: `lib/app/feature/meal_entry/bloc/bloc.dart` (barrel)
- Create: `lib/app/feature/meal_entry/meal_entry.dart` (feature barrel)
- Modify: `lib/app/app.dart` (add feature barrel export — match how other features are exported)

**Interfaces:**

- Produces:
  - `enum MealEntryStatus { idle, generating, failure }`
  - `MealEntryState`: `List<FoodDraft> foods` (default `[]`), `MealEntryMode mealEntryMode` (default `wholeMeal`), `MealOfTheDay mealOfTheDay` (default `breakfast`), `List<MealPhoto> photos` (default `[]`), `MealEntryStatus status` (default `idle`), `String? errorMessage`. Convenience getters `hasContent` and `isGenerating`.
  - `MealEntryEvent` sealed factories: `started`, `foodAdded`, `foodRemoved`, `foodNameChanged`, `foodNutritionChanged`, `foodQuantityChanged`, `foodAddToUsualMealsToggled`, `entryModeToggled`, `mealOfTheDayChanged`, `photosAdded`, `photosCleared`, `estimateRequested`, `photoEstimateRequested`.

- [ ] **Step 1: Create the bloc shell with part directives**

```dart
// lib/app/feature/meal_entry/bloc/meal_entry_bloc.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:the_usual/app/app.dart';
import 'package:uuid/uuid.dart';

part 'meal_entry_bloc.freezed.dart';
part 'meal_entry_event.dart';
part 'meal_entry_state.dart';

/// {@template food_entry_bloc}
/// Owns one meal-entry surface's working state: the editable food rows, the
/// AI [MealEntryMode], the target [MealOfTheDay], any attached [MealPhoto]s,
/// and the estimation status. Created and disposed by the widget that shows the
/// surface, so several can be alive at once (onboarding shows one per meal).
/// Logging is the caller's job; this bloc only drafts and estimates.
/// {@endtemplate}
@injectable
class FoodEntryBloc extends Bloc<MealEntryEvent, MealEntryState> {
  /// {@macro food_entry_bloc}
  FoodEntryBloc(this._mealAiRepository, this._userSettingsBloc)
    : super(const MealEntryState()) {
    // Handlers registered in Tasks 4 and 5.
  }

  final MealAiRepository _mealAiRepository;
  final UserSettingsBloc _userSettingsBloc;

  static const _uuid = Uuid();
}
```

- [ ] **Step 2: Create the state**

```dart
// lib/app/feature/meal_entry/bloc/meal_entry_state.dart
part of 'meal_entry_bloc.dart';

/// Where an estimate stands: [idle] (editable, including after a result lands),
/// [generating] while Claude is being called, or [failure] when it errored.
enum MealEntryStatus { idle, generating, failure }

/// {@template meal_entry_state}
/// State for [FoodEntryBloc].
/// {@endtemplate}
@freezed
abstract class MealEntryState with _$MealEntryState {
  /// {@macro meal_entry_state}
  const factory MealEntryState({
    @Default(<FoodDraft>[]) List<FoodDraft> foods,
    @Default(MealEntryMode.wholeMeal) MealEntryMode mealEntryMode,
    @Default(MealOfTheDay.breakfast) MealOfTheDay mealOfTheDay,
    @Default(<MealPhoto>[]) List<MealPhoto> photos,
    @Default(MealEntryStatus.idle) MealEntryStatus status,
    String? errorMessage,
  }) = _MealEntryState;

  const MealEntryState._();

  /// Whether any row has a name entered.
  bool get hasContent =>
      foods.any((foodDraft) => foodDraft.name.trim().isNotEmpty);

  /// Whether an estimate is currently running.
  bool get isGenerating => status == MealEntryStatus.generating;
}
```

- [ ] **Step 3: Create the events**

```dart
// lib/app/feature/meal_entry/bloc/meal_entry_event.dart
part of 'meal_entry_bloc.dart';

@freezed
sealed class MealEntryEvent with _$MealEntryEvent {
  /// Seeds the surface. [initialFoods] become the rows (one empty row when
  /// null/empty); [photos] are held for a photo estimate; [mealOfTheDay] sets
  /// the target slot. When [autoEstimate] is true and photos are present, a
  /// photo estimate is kicked immediately (the share path).
  const factory MealEntryEvent.started({
    List<FoodDraft>? initialFoods,
    @Default(<MealPhoto>[]) List<MealPhoto> photos,
    MealOfTheDay? mealOfTheDay,
    @Default(false) bool autoEstimate,
  }) = MealEntryStarted;

  const factory MealEntryEvent.foodAdded() = MealEntryFoodAdded;
  const factory MealEntryEvent.foodRemoved(String id) = MealEntryFoodRemoved;
  const factory MealEntryEvent.foodNameChanged(String id, String name) =
      MealEntryFoodNameChanged;
  const factory MealEntryEvent.foodNutritionChanged(
    String id,
    Nutrition nutrition,
  ) = MealEntryFoodNutritionChanged;
  const factory MealEntryEvent.foodQuantityChanged(String id, double quantity) =
      MealEntryFoodQuantityChanged;
  const factory MealEntryEvent.foodAddToUsualMealsToggled(
    String id, {
    required bool addToUsualMeals,
  }) = MealEntryFoodAddToUsualMealsToggled;
  const factory MealEntryEvent.entryModeToggled(MealEntryMode mealEntryMode) =
      MealEntryModeToggled;
  const factory MealEntryEvent.mealOfTheDayChanged(MealOfTheDay mealOfTheDay) =
      MealEntryMealOfTheDayChanged;
  const factory MealEntryEvent.photosAdded(List<MealPhoto> photos) =
      MealEntryPhotosAdded;
  const factory MealEntryEvent.photosCleared() = MealEntryPhotosCleared;
  const factory MealEntryEvent.estimateRequested() = MealEntryEstimateRequested;
  const factory MealEntryEvent.photoEstimateRequested() =
      MealEntryPhotoEstimateRequested;
}
```

- [ ] **Step 4: Create the barrels**

```dart
// lib/app/feature/meal_entry/bloc/bloc.dart
export 'meal_entry_bloc.dart';
```

```dart
// lib/app/feature/meal_entry/meal_entry.dart
export 'bloc/bloc.dart';
```

Add the feature to `lib/app/app.dart` next to the other `feature/*` exports:

```dart
export 'feature/meal_entry/meal_entry.dart';
```

- [ ] **Step 5: Wait for generation, run analyzer**

Run: `fvm dart analyze lib/app/feature/meal_entry`
Expected: clean (the bloc has no handlers yet, which is fine).

- [ ] **Step 6: Commit**

Suggested message: `feat: scaffold FoodEntryBloc state and events`.

---

### Task 4: `FoodEntryBloc` non-AI handlers

**Files:**

- Modify: `lib/app/feature/meal_entry/bloc/meal_entry_bloc.dart`
- Test: `test/app/feature/meal_entry/bloc/meal_entry_bloc_test.dart`

**Interfaces:**

- Consumes: `MealEntryState`, `MealEntryEvent`, `FoodDraft`, `MealAiRepository`, `UserSettingsBloc` (from Tasks 1–3 and existing code).
- Produces: handlers for `started`, `foodAdded`, `foodRemoved`, `foodNameChanged`, `foodNutritionChanged`, `foodQuantityChanged`, `foodAddToUsualMealsToggled`, `entryModeToggled`, `mealOfTheDayChanged`, `photosAdded`, `photosCleared`. `entryModeToggled` persists to `UserSettingsBloc`. The AI handlers (`estimateRequested`, `photoEstimateRequested`, and `started` auto-estimate) are stubbed to no-op here and implemented in Task 5.

- [ ] **Step 1: Write the failing tests**

```dart
// test/app/feature/meal_entry/bloc/meal_entry_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  late MockMealAiRepository repository;
  late MockUserSettingsBloc userSettingsBloc;

  setUp(() {
    repository = MockMealAiRepository();
    userSettingsBloc = MockUserSettingsBloc();
    when(() => userSettingsBloc.state).thenReturn(
      const UserSettingsState(mealEntryMode: MealEntryMode.wholeMeal),
    );
  });

  FoodEntryBloc build() => FoodEntryBloc(repository, userSettingsBloc);

  group(FoodEntryBloc, () {
    blocTest<FoodEntryBloc, MealEntryState>(
      'started seeds one empty row and the mode from settings',
      build: build,
      act: (bloc) => bloc.add(const MealEntryEvent.started()),
      expect: () => [
        isA<MealEntryState>()
            .having((s) => s.foods, 'foods', hasLength(1))
            .having(
              (s) => s.mealEntryMode,
              'mealEntryMode',
              MealEntryMode.wholeMeal,
            ),
      ],
    );

    blocTest<FoodEntryBloc, MealEntryState>(
      'started seeds the supplied foods and slot',
      build: build,
      act: (bloc) => bloc.add(
        MealEntryEvent.started(
          initialFoods: const [FoodDraft(id: 'x', name: 'Toast')],
          mealOfTheDay: MealOfTheDay.dinner,
        ),
      ),
      expect: () => [
        isA<MealEntryState>()
            .having((s) => s.foods.single.name, 'name', 'Toast')
            .having((s) => s.mealOfTheDay, 'slot', MealOfTheDay.dinner),
      ],
    );

    blocTest<FoodEntryBloc, MealEntryState>(
      'foodAdded appends an empty row',
      build: build,
      seed: () => const MealEntryState(foods: [FoodDraft(id: 'a')]),
      act: (bloc) => bloc.add(const MealEntryEvent.foodAdded()),
      expect: () => [
        isA<MealEntryState>().having((s) => s.foods, 'foods', hasLength(2)),
      ],
    );

    blocTest<FoodEntryBloc, MealEntryState>(
      'foodNameChanged updates the matching row',
      build: build,
      seed: () => const MealEntryState(foods: [FoodDraft(id: 'a')]),
      act: (bloc) => bloc.add(const MealEntryEvent.foodNameChanged('a', 'Eggs')),
      expect: () => [
        isA<MealEntryState>().having(
          (s) => s.foods.single.name,
          'name',
          'Eggs',
        ),
      ],
    );

    blocTest<FoodEntryBloc, MealEntryState>(
      'foodRemoved keeps at least one row',
      build: build,
      seed: () => const MealEntryState(foods: [FoodDraft(id: 'a')]),
      act: (bloc) => bloc.add(const MealEntryEvent.foodRemoved('a')),
      expect: () => [
        isA<MealEntryState>().having((s) => s.foods, 'foods', hasLength(1)),
      ],
    );

    blocTest<FoodEntryBloc, MealEntryState>(
      'entryModeToggled updates state and persists to settings',
      build: build,
      act: (bloc) => bloc.add(
        const MealEntryEvent.entryModeToggled(MealEntryMode.itemized),
      ),
      expect: () => [
        isA<MealEntryState>().having(
          (s) => s.mealEntryMode,
          'mode',
          MealEntryMode.itemized,
        ),
      ],
      verify: (_) {
        verify(
          () => userSettingsBloc.add(
            const UserSettingsEvent.mealEntryModeChanged(
              MealEntryMode.itemized,
            ),
          ),
        ).called(1);
      },
    );

    blocTest<FoodEntryBloc, MealEntryState>(
      'mealOfTheDayChanged updates the slot',
      build: build,
      act: (bloc) =>
          bloc.add(const MealEntryEvent.mealOfTheDayChanged(MealOfTheDay.lunch)),
      expect: () => [
        isA<MealEntryState>().having(
          (s) => s.mealOfTheDay,
          'slot',
          MealOfTheDay.lunch,
        ),
      ],
    );
  });
}
```

- [ ] **Step 2: Run to verify it fails**

Run: `fvm flutter test test/app/feature/meal_entry/bloc/meal_entry_bloc_test.dart`
Expected: FAIL — events are unhandled (bloc has no `on<>` registrations).

- [ ] **Step 3: Implement the handlers**

Fill the `FoodEntryBloc` constructor body and add the handler methods:

```dart
  FoodEntryBloc(this._mealAiRepository, this._userSettingsBloc)
    : super(const MealEntryState()) {
    on<MealEntryEvent>(
      (event, emit) => switch (event) {
        MealEntryStarted() => _onStarted(event, emit),
        MealEntryFoodAdded() => emit(
          state.copyWith(
            foods: [...state.foods, FoodDraft(id: _uuid.v4())],
          ),
        ),
        MealEntryFoodRemoved() => _onFoodRemoved(event, emit),
        MealEntryFoodNameChanged() => emit(
          state.copyWith(
            foods: _mapFood(
              event.id,
              (foodDraft) => foodDraft.copyWith(name: event.name),
            ),
          ),
        ),
        MealEntryFoodNutritionChanged() => emit(
          state.copyWith(
            foods: _mapFood(
              event.id,
              (foodDraft) => foodDraft.copyWith(nutrition: event.nutrition),
            ),
          ),
        ),
        MealEntryFoodQuantityChanged() => emit(
          state.copyWith(
            foods: _mapFood(
              event.id,
              (foodDraft) => foodDraft.copyWith(quantity: event.quantity),
            ),
          ),
        ),
        MealEntryFoodAddToUsualMealsToggled() => emit(
          state.copyWith(
            foods: _mapFood(
              event.id,
              (foodDraft) =>
                  foodDraft.copyWith(addToUsualMeals: event.addToUsualMeals),
            ),
          ),
        ),
        MealEntryModeToggled() => _onEntryModeToggled(event, emit),
        MealEntryMealOfTheDayChanged() => emit(
          state.copyWith(mealOfTheDay: event.mealOfTheDay),
        ),
        MealEntryPhotosAdded() => emit(
          state.copyWith(photos: [...state.photos, ...event.photos]),
        ),
        MealEntryPhotosCleared() => emit(
          state.copyWith(photos: const []),
        ),
        // Implemented in Task 5.
        MealEntryEstimateRequested() => _onEstimateRequested(event, emit),
        MealEntryPhotoEstimateRequested() => _onPhotoEstimateRequested(
          event,
          emit,
        ),
      },
    );
  }

  /// Returns [state.foods] with the row whose id is [id] transformed by
  /// [transform]; other rows are left as-is.
  List<FoodDraft> _mapFood(String id, FoodDraft Function(FoodDraft) transform) {
    return [
      for (final foodDraft in state.foods)
        if (foodDraft.id == id) transform(foodDraft) else foodDraft,
    ];
  }

  Future<void> _onStarted(
    MealEntryStarted event,
    Emitter<MealEntryState> emit,
  ) async {
    final initialFoods = event.initialFoods;
    final foods = (initialFoods == null || initialFoods.isEmpty)
        ? [FoodDraft(id: _uuid.v4())]
        : initialFoods;
    emit(
      state.copyWith(
        foods: foods,
        photos: event.photos,
        mealEntryMode: _userSettingsBloc.state.mealEntryMode,
        mealOfTheDay: event.mealOfTheDay ?? state.mealOfTheDay,
        status: MealEntryStatus.idle,
        errorMessage: null,
      ),
    );
    if (event.autoEstimate && event.photos.isNotEmpty) {
      await _runPhotoEstimate(emit);
    }
  }

  void _onFoodRemoved(
    MealEntryFoodRemoved event,
    Emitter<MealEntryState> emit,
  ) {
    final remaining = state.foods
        .where((foodDraft) => foodDraft.id != event.id)
        .toList();
    // The remove control only shows with more than one row, so this can't
    // empty the list from the UI; the guard is defensive.
    if (remaining.isEmpty) remaining.add(FoodDraft(id: _uuid.v4()));
    emit(state.copyWith(foods: remaining));
  }

  void _onEntryModeToggled(
    MealEntryModeToggled event,
    Emitter<MealEntryState> emit,
  ) {
    _userSettingsBloc.add(
      UserSettingsEvent.mealEntryModeChanged(event.mealEntryMode),
    );
    emit(state.copyWith(mealEntryMode: event.mealEntryMode));
  }
```

Add no-op stubs so the file analyzes until Task 5 (they will be replaced):

```dart
  Future<void> _onEstimateRequested(
    MealEntryEstimateRequested event,
    Emitter<MealEntryState> emit,
  ) async {}

  Future<void> _onPhotoEstimateRequested(
    MealEntryPhotoEstimateRequested event,
    Emitter<MealEntryState> emit,
  ) async {}

  Future<void> _runPhotoEstimate(Emitter<MealEntryState> emit) async {}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `fvm flutter test test/app/feature/meal_entry/bloc/meal_entry_bloc_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

Suggested message: `feat: FoodEntryBloc row, mode, slot, and photo handlers`.

---

### Task 5: `FoodEntryBloc` AI estimation handlers

Reproduce the form's exact estimation behavior: one named row → `suggestFromDescription` (mode may split it, keep the typed name in whole-meal mode); several named rows → estimate each on its own and fill in place keeping names; photos → `suggestFromPhoto` over all held photos.

**Files:**

- Modify: `lib/app/feature/meal_entry/bloc/meal_entry_bloc.dart`
- Modify: `test/app/feature/meal_entry/bloc/meal_entry_bloc_test.dart`

**Interfaces:**

- Consumes: `MealAiRepository.suggestFromDescription(String, {required MealEntryMode mode})` and (Phase 1 single-photo) `MealAiRepository.suggestFromPhoto(Uint8List, {required MealEntryMode mode, String? description, String imageMediaType})`. **Phase 2 changes the photo signature; the call site is updated in Task 8.**
- Produces: working `estimateRequested`, `photoEstimateRequested`, and `_runPhotoEstimate`.

- [ ] **Step 1: Write the failing tests**

Add inside the `group(FoodEntryBloc, ...)`:

```dart
    group('estimateRequested', () {
      blocTest<FoodEntryBloc, MealEntryState>(
        'a single named row is estimated and the rows are replaced',
        build: build,
        setUp: () {
          when(
            () => repository.suggestFromDescription(
              any(),
              mode: any(named: 'mode'),
            ),
          ).thenAnswer(
            (_) async => const [
              AiMealSuggestion(
                name: '2 eggs & toast',
                nutrition: Nutrition(calories: 350),
              ),
            ],
          );
        },
        seed: () => const MealEntryState(
          foods: [FoodDraft(id: 'a', name: 'eggs and toast')],
        ),
        act: (bloc) => bloc.add(const MealEntryEvent.estimateRequested()),
        expect: () => [
          isA<MealEntryState>().having(
            (s) => s.status,
            'status',
            MealEntryStatus.generating,
          ),
          isA<MealEntryState>()
              .having((s) => s.status, 'status', MealEntryStatus.idle)
              .having(
                (s) => s.foods.single.nutrition.calories,
                'calories',
                350,
              )
              // whole-meal keeps the typed description as the name
              .having((s) => s.foods.single.name, 'name', 'eggs and toast'),
        ],
      );

      blocTest<FoodEntryBloc, MealEntryState>(
        'a repository failure ends in failure status with a message',
        build: build,
        setUp: () {
          when(
            () => repository.suggestFromDescription(
              any(),
              mode: any(named: 'mode'),
            ),
          ).thenThrow(StateError('boom'));
        },
        seed: () =>
            const MealEntryState(foods: [FoodDraft(id: 'a', name: 'mystery')]),
        act: (bloc) => bloc.add(const MealEntryEvent.estimateRequested()),
        expect: () => [
          isA<MealEntryState>().having(
            (s) => s.status,
            'status',
            MealEntryStatus.generating,
          ),
          isA<MealEntryState>()
              .having((s) => s.status, 'status', MealEntryStatus.failure)
              .having((s) => s.errorMessage, 'errorMessage', isNotNull),
        ],
      );
    });
```

- [ ] **Step 2: Run to verify it fails**

Run: `fvm flutter test test/app/feature/meal_entry/bloc/meal_entry_bloc_test.dart -n estimateRequested`
Expected: FAIL — the stubbed handlers emit nothing.

- [ ] **Step 3: Implement the handlers**

Replace the three stubs from Task 4:

```dart
  /// Estimates nutrition from the rows. A single named row is sent as a
  /// description the mode may split; several named rows are already itemized by
  /// the user, so each is estimated on its own and filled in place keeping its
  /// name.
  Future<void> _onEstimateRequested(
    MealEntryEstimateRequested event,
    Emitter<MealEntryState> emit,
  ) async {
    final namedFoods = state.foods
        .where((foodDraft) => foodDraft.name.trim().isNotEmpty)
        .toList();
    if (namedFoods.isEmpty) return;

    emit(state.copyWith(status: MealEntryStatus.generating, errorMessage: null));
    try {
      if (namedFoods.length == 1) {
        final description = namedFoods.first.name.trim();
        final suggestions = await _mealAiRepository.suggestFromDescription(
          description,
          mode: state.mealEntryMode,
        );
        emit(
          state.copyWith(
            status: MealEntryStatus.idle,
            foods: _foodsFromSuggestions(
              suggestions,
              keepFirstName: state.mealEntryMode == MealEntryMode.wholeMeal
                  ? description
                  : null,
            ),
          ),
        );
        return;
      }
      await _estimateEachRow(namedFoods, emit);
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: MealEntryStatus.failure,
          errorMessage: 'Could not estimate nutrition: $error',
        ),
      );
    }
  }

  /// Estimates each named row as its own whole-meal item, in parallel, and
  /// fills nutrition and quantity in place while keeping every row and name.
  Future<void> _estimateEachRow(
    List<FoodDraft> namedFoods,
    Emitter<MealEntryState> emit,
  ) async {
    final estimates = await Future.wait([
      for (final foodDraft in namedFoods)
        _mealAiRepository.suggestFromDescription(
          foodDraft.name.trim(),
          mode: MealEntryMode.wholeMeal,
        ),
    ]);
    final estimateById = <String, AiMealSuggestion>{};
    for (final (index, foodDraft) in namedFoods.indexed) {
      final suggestions = estimates[index];
      if (suggestions.isNotEmpty) estimateById[foodDraft.id] = suggestions.first;
    }
    emit(
      state.copyWith(
        status: MealEntryStatus.idle,
        foods: [
          for (final foodDraft in state.foods)
            if (estimateById[foodDraft.id] case final estimate?)
              foodDraft.copyWith(
                quantity: estimate.quantity,
                nutrition: estimate.nutrition,
              )
            else
              foodDraft,
        ],
      ),
    );
  }

  /// Estimates from the held [MealEntryState.photos]. Any name typed in the
  /// first row is sent to sharpen the estimate, and kept over the model's name
  /// in whole-meal mode.
  Future<void> _onPhotoEstimateRequested(
    MealEntryPhotoEstimateRequested event,
    Emitter<MealEntryState> emit,
  ) async {
    await _runPhotoEstimate(emit);
  }

  Future<void> _runPhotoEstimate(Emitter<MealEntryState> emit) async {
    if (state.photos.isEmpty) return;
    final firstName = state.foods.isEmpty ? '' : state.foods.first.name.trim();
    final hasDescription = firstName.isNotEmpty;
    emit(state.copyWith(status: MealEntryStatus.generating, errorMessage: null));
    try {
      // Phase 1: single photo. Task 8 switches this to pass all photos.
      final photo = state.photos.first;
      final suggestions = await _mealAiRepository.suggestFromPhoto(
        photo.bytes,
        mode: state.mealEntryMode,
        description: hasDescription ? firstName : null,
        imageMediaType: photo.mediaType,
      );
      emit(
        state.copyWith(
          status: MealEntryStatus.idle,
          foods: _foodsFromSuggestions(
            suggestions,
            keepFirstName: hasDescription &&
                    state.mealEntryMode == MealEntryMode.wholeMeal
                ? firstName
                : null,
          ),
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: MealEntryStatus.failure,
          errorMessage: 'Could not estimate nutrition: $error',
        ),
      );
    }
  }

  /// Builds rows from [suggestions]; when [keepFirstName] is set the first row
  /// keeps that name instead of the model's. Empty result leaves rows unchanged.
  List<FoodDraft> _foodsFromSuggestions(
    List<AiMealSuggestion> suggestions, {
    String? keepFirstName,
  }) {
    if (suggestions.isEmpty) return state.foods;
    return [
      for (final (index, suggestion) in suggestions.indexed)
        FoodDraft(
          id: _uuid.v4(),
          name: index == 0 && keepFirstName != null
              ? keepFirstName
              : suggestion.name,
          quantity: suggestion.quantity,
          nutrition: suggestion.nutrition,
        ),
    ];
  }
```

- [ ] **Step 4: Run tests**

Run: `fvm flutter test test/app/feature/meal_entry/bloc/meal_entry_bloc_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

Suggested message: `feat: FoodEntryBloc AI estimation handlers`.

---

### Task 6: Rewire `FoodEntryForm` onto the bloc

Keep the public surface (`FoodEntryFormState.results`, `hasContent`, `isGenerating`) so `BuildUsualsView` and `FoodEntrySheet` keep working through their `GlobalKey`s. The form creates and owns the bloc.

**Files:**

- Modify: `lib/app/widgets/inputs/food_entry_form.dart` (full rewrite of the State internals; keep `FoodEntryResult` typedef and the widget's constructor params)
- Test: `test/app/widgets/food_entry_form_test.dart`

**Interfaces:**

- Consumes: `FoodEntryBloc`, `MealEntryState`, `MealEntryEvent`, `pickMealPhoto` (still single in Phase 1).
- Produces (unchanged public API): `FoodEntryFormState.results` → `List<FoodEntryResult>`, `bool get hasContent`, `bool get isGenerating`, plus new `MealOfTheDay get mealOfTheDay` and `void changeMealOfTheDay(MealOfTheDay)` for the sheet's slot selector (Task 12 uses them). New optional widget params: `List<MealPhoto>? initialPhotos`, `bool autoEstimate = false`, `MealOfTheDay? initialMealOfTheDay`.

- [ ] **Step 1: Write the failing widget test**

```dart
// test/app/widgets/food_entry_form_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

import '../../helpers/helpers.dart';

void main() {
  setUp(() {
    initHydratedStorage();
    final repository = MockMealAiRepository();
    when(() => repository.isConfigured).thenReturn(false);
    final userSettingsBloc = MockUserSettingsBloc();
    when(() => userSettingsBloc.state).thenReturn(const UserSettingsState());
    // getIt produces a fresh FoodEntryBloc per call; register the deps it needs.
    if (getIt.isRegistered<MealAiRepository>()) {
      getIt.unregister<MealAiRepository>();
    }
    getIt.registerSingleton<MealAiRepository>(repository);
    if (getIt.isRegistered<UserSettingsBloc>()) {
      getIt.unregister<UserSettingsBloc>();
    }
    getIt.registerSingleton<UserSettingsBloc>(userSettingsBloc);
    if (!getIt.isRegistered<FoodEntryBloc>()) {
      getIt.registerFactory<FoodEntryBloc>(
        () => FoodEntryBloc(
          getIt<MealAiRepository>(),
          getIt<UserSettingsBloc>(),
        ),
      );
    }
  });

  testWidgets('seeds a row per initial food and exposes results', (
    tester,
  ) async {
    final formKey = GlobalKey<FoodEntryFormState>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FoodEntryForm(
            key: formKey,
            initialFoods: const [
              (
                name: 'Toast',
                nutrition: Nutrition(calories: 120),
                quantity: 1.0,
                addToUsualMeals: false,
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(formKey.currentState!.results, hasLength(1));
    expect(formKey.currentState!.results.single.name, equals('Toast'));
    expect(formKey.currentState!.hasContent, isTrue);
  });
}
```

- [ ] **Step 2: Run to verify it fails**

Run: `fvm flutter test test/app/widgets/food_entry_form_test.dart`
Expected: FAIL — current form has no bloc wiring; with the registration helper it still fails because `results` reads `_drafts`, not bloc state, and the bloc isn't created. (If it happens to pass pre-change, the assertion on bloc-sourced results still drives the rewrite.)

- [ ] **Step 3: Rewrite the form State to own the bloc**

Replace the `_FoodEntryFormState` internals. Key points: create `_bloc = getIt<FoodEntryBloc>()` in `initState`, dispatch `started`, `close()` in `dispose`, wrap the body in `BlocProvider.value` + `BlocBuilder`, dispatch events from controls, and source the public getters from `_bloc.state`. Row text controllers are owned per-row keyed by `FoodDraft.id`.

```dart
class FoodEntryFormState extends State<FoodEntryForm> {
  late final FoodEntryBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<FoodEntryBloc>();
    final initialFoods = widget.initialFoods;
    _bloc.add(
      MealEntryEvent.started(
        initialFoods: initialFoods == null
            ? null
            : [
                for (final food in initialFoods)
                  FoodDraft(
                    id: _uuid.v4(),
                    name: food.name,
                    quantity: food.quantity,
                    nutrition: food.nutrition,
                    addToUsualMeals: food.addToUsualMeals,
                  ),
              ],
        photos: widget.initialPhotos ?? const [],
        mealOfTheDay: widget.initialMealOfTheDay,
        autoEstimate: widget.autoEstimate,
      ),
    );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  static const _uuid = Uuid();

  List<FoodEntryResult> get results => [
    for (final foodDraft in _bloc.state.foods)
      if (foodDraft.name.trim().isNotEmpty)
        (
          name: foodDraft.name.trim(),
          nutrition: foodDraft.nutrition,
          quantity: foodDraft.quantity,
          addToUsualMeals:
              widget.showAddToUsualMeals && foodDraft.addToUsualMeals,
        ),
  ];

  bool get hasContent => _bloc.state.hasContent;
  bool get isGenerating => _bloc.state.isGenerating;
  MealOfTheDay get mealOfTheDay => _bloc.state.mealOfTheDay;
  void changeMealOfTheDay(MealOfTheDay mealOfTheDay) =>
      _bloc.add(MealEntryEvent.mealOfTheDayChanged(mealOfTheDay));

  bool get _aiAvailable => getIt<MealAiRepository>().isConfigured;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<FoodEntryBloc, MealEntryState>(
        listener: (context, state) {
          widget.onChanged?.call();
          final message = state.errorMessage;
          if (state.status == MealEntryStatus.failure && message != null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(message)));
          }
        },
        builder: (context, state) => _buildForm(context, state),
      ),
    );
  }
  // _buildForm: the existing Column, but:
  //  - the Estimate button dispatches MealEntryEvent.estimateRequested()
  //  - the Photo button calls _photoWithAi (pick + photosAdded + photoEstimateRequested)
  //  - the Itemize checkbox dispatches MealEntryEvent.entryModeToggled(...)
  //  - rows come from state.foods, each _FoodEntryRow keyed by foodDraft.id
  //  - row edits dispatch foodNameChanged / foodNutritionChanged /
  //    foodQuantityChanged / foodAddToUsualMealsToggled / foodRemoved
  //  - "Add item" dispatches MealEntryEvent.foodAdded()
}
```

Add the new widget fields to `FoodEntryForm`:

```dart
  final List<MealPhoto>? initialPhotos;
  final bool autoEstimate;
  final MealOfTheDay? initialMealOfTheDay;
```

`_photoWithAi` becomes (Phase 1 single photo):

```dart
  Future<void> _photoWithAi() async {
    final photo = await pickMealPhoto(context);
    if (photo == null) return;
    _bloc
      ..add(MealEntryEvent.photosAdded([photo]))
      ..add(const MealEntryEvent.photoEstimateRequested());
  }
```

Rewrite `_FoodEntryRow` to own a `TextEditingController` seeded from `draft.name`, reporting changes via an `onNameChanged(String)` callback (replacing direct controller reads), and to call back nutrition/quantity/remove. The row no longer mutates a `_FoodDraft`; it renders a `FoodDraft` and reports up. Delete the old `_FoodDraft` class.

- [ ] **Step 4: Run tests to verify they pass**

Run: `fvm flutter test test/app/widgets/food_entry_form_test.dart`
Expected: PASS.

- [ ] **Step 5: Full suite for regressions**

Run: `fvm flutter test --test-randomize-ordering-seed random`
Expected: PASS. Fix any onboarding/today widget tests that referenced the old `_FoodDraft` internals (they should only touch the public widget API).

- [ ] **Step 6: Commit**

Suggested message: `refactor: drive FoodEntryForm from FoodEntryBloc`.

---

### Task 7: Rewire `FoodEntrySheet` and its two callers

The sheet reads generating/content state from the bloc via the form key (unchanged getters) and now pops `({List<FoodEntryResult> foods, MealOfTheDay mealOfTheDay})`. The meal-slot selector itself is added in Phase 3 (Task 12); here we only change the pop shape and update callers, so behavior is unchanged.

**Files:**

- Modify: `lib/app/widgets/inputs/food_entry_sheet.dart`
- Modify: `lib/app/feature/today/widgets/meal_log_section.dart:158-191`
- Modify: `lib/app/feature/onboarding/view/first_log_view.dart:104-126`
- Test: `test/app/widgets/food_entry_sheet_test.dart`

**Interfaces:**

- Produces: `FoodEntrySheetResult = ({List<FoodEntryResult> foods, MealOfTheDay mealOfTheDay})` (typedef in `food_entry_sheet.dart`); `FoodEntrySheet` pops this. New optional params (used in Phase 3, default off now): `bool showMealSelector = false`, `List<MealPhoto>? initialPhotos`, `bool autoEstimate = false`, `MealOfTheDay? initialMealOfTheDay`.
- Consumes: `FoodEntryFormState.results` / `mealOfTheDay`.

- [ ] **Step 1: Write the failing widget test**

```dart
// test/app/widgets/food_entry_sheet_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

import '../../helpers/helpers.dart';

void main() {
  setUp(() {
    initHydratedStorage();
    final repository = MockMealAiRepository();
    when(() => repository.isConfigured).thenReturn(false);
    final userSettingsBloc = MockUserSettingsBloc();
    when(() => userSettingsBloc.state).thenReturn(const UserSettingsState());
    if (getIt.isRegistered<MealAiRepository>()) {
      getIt.unregister<MealAiRepository>();
    }
    getIt.registerSingleton<MealAiRepository>(repository);
    if (getIt.isRegistered<UserSettingsBloc>()) {
      getIt.unregister<UserSettingsBloc>();
    }
    getIt.registerSingleton<UserSettingsBloc>(userSettingsBloc);
    if (!getIt.isRegistered<FoodEntryBloc>()) {
      getIt.registerFactory<FoodEntryBloc>(
        () => FoodEntryBloc(
          getIt<MealAiRepository>(),
          getIt<UserSettingsBloc>(),
        ),
      );
    }
  });

  testWidgets('confirm pops foods with the target slot', (tester) async {
    FoodEntrySheetResult? popped;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                popped = await showModalBottomSheet<FoodEntrySheetResult>(
                  context: context,
                  builder: (_) => const FoodEntrySheet(
                    title: 'Log',
                    confirmLabel: 'Log',
                    initialMealOfTheDay: MealOfTheDay.lunch,
                  ),
                );
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Soup');
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Log'));
    await tester.pumpAndSettle();

    expect(popped, isNotNull);
    expect(popped!.foods.single.name, equals('Soup'));
    expect(popped!.mealOfTheDay, equals(MealOfTheDay.lunch));
  });
}
```

- [ ] **Step 2: Run to verify it fails**

Run: `fvm flutter test test/app/widgets/food_entry_sheet_test.dart`
Expected: FAIL — `FoodEntrySheetResult` undefined and the sheet still pops `List<FoodEntryResult>`.

- [ ] **Step 3: Update the sheet**

```dart
typedef FoodEntrySheetResult = ({
  List<FoodEntryResult> foods,
  MealOfTheDay mealOfTheDay,
});
```

Add the new optional params to the constructor (`showMealSelector`, `initialPhotos`, `autoEstimate`, `initialMealOfTheDay`), pass `initialPhotos`/`autoEstimate`/`initialMealOfTheDay` through to `FoodEntryForm`, and change `_confirm`:

```dart
  void _confirm() {
    final form = _formKey.currentState;
    final results = form?.results ?? const [];
    if (results.isEmpty || form == null) return;
    Navigator.of(context).pop(
      (foods: results, mealOfTheDay: form.mealOfTheDay),
    );
  }
```

(The `showMealSelector` UI is wired in Task 12; for now the param exists and defaults false.)

- [ ] **Step 4: Update the two callers**

`meal_log_section.dart` — change the await type and read `.foods`:

```dart
final result = await TheUsualBottomSheet.show<FoodEntrySheetResult>(
  context,
  builder: (context) => const FoodEntrySheet(
    title: 'Log Something New',
    confirmLabel: 'Log',
    showAddToUsualMeals: true,
  ),
);
if (result == null) return;
for (final foodResult in result.foods) {
  // ...existing addToUsualMeals + DailyLogEvent.mealLogged using `mealOfTheDay`
  // (the section's own slot), unchanged...
}
```

`first_log_view.dart` — same shape:

```dart
final result = await TheUsualBottomSheet.show<FoodEntrySheetResult>(
  context,
  builder: (context) => const FoodEntrySheet(
    title: 'Log Something New',
    confirmLabel: 'Log',
  ),
);
if (result == null) return;
for (final foodResult in result.foods) {
  getIt<OnboardingBloc>().add(
    OnboardingEvent.somethingElseLogged(
      _mealOfTheDay,
      foodResult.name,
      nutrition: foodResult.nutrition,
      quantity: foodResult.quantity,
    ),
  );
}
```

- [ ] **Step 5: Run tests**

Run: `fvm flutter test test/app/widgets/food_entry_sheet_test.dart`
Run: `fvm flutter test --test-randomize-ordering-seed random`
Expected: PASS.

- [ ] **Step 6: Commit**

Suggested message: `refactor: FoodEntrySheet returns foods plus target slot`.

---

# Phase 2 — Multiple photos

End state: one estimate pass over several photos; the normal sheet's Photo button can attach several from the library.

### Task 8: Multi-image `MealAiClient` and `MealAiRepository`

**Files:**

- Modify: `lib/app/core/networking/ai/meal_ai_client.dart:64-98`
- Modify: `lib/app/core/networking/repository/meal_ai_repository.dart:44-82`
- Modify: `lib/app/feature/meal_entry/bloc/meal_entry_bloc.dart` (`_runPhotoEstimate` passes all photos)
- Modify: `lib/app/feature/dev_tools/view/dev_tools_view.dart:187` (single-photo call → list)
- Modify: `test/app/core/networking/repository/meal_ai_repository_test.dart` (stubs/verifies use `images`)
- Test: `test/app/core/networking/repository/meal_ai_repository_test.dart` (add a multi-photo case)

**Interfaces:**

- Produces:
  - `MealAiClient.generateStructured<T>({required String prompt, required SchemanticType<T> outputSchema, List<MealPhoto> images = const <MealPhoto>[]})` — emits one `MediaPart` per image in a single user message; text-only when `images` is empty.
  - `MealAiRepository.suggestFromPhoto(List<MealPhoto> photos, {required MealEntryMode mode, String? description})` — drops the old `Uint8List`/`imageMediaType` params.
- Consumes: `MealPhoto` (Task 1).

- [ ] **Step 1: Update the repository test first (failing)**

In `meal_ai_repository_test.dart`: drop `image`/`imageMediaType` from the `stubWholeMeal`/`stubItemized` `when(...)` matchers (replace with `images: any(named: 'images')`), remove the `registerFallbackValue(Uint8List(0))` (no longer needed unless used elsewhere; keep if referenced), and change the `suggestFromPhoto` calls to pass a list:

```dart
final suggestions = await repository.suggestFromPhoto(
  [MealPhoto(bytes: Uint8List.fromList([1, 2, 3]), mediaType: 'image/png')],
  mode: MealEntryMode.wholeMeal,
  description: 'grilled chicken',
);
```

Add a multi-photo case asserting both images reach the client:

```dart
test('sends every photo to the client in one request', () async {
  stubWholeMeal(<String, dynamic>{
    'name': 'plate',
    'quantity': 1,
    'nutrition': {'calories': 500},
  });

  await repository.suggestFromPhoto(
    [
      MealPhoto(bytes: Uint8List.fromList([1])),
      MealPhoto(bytes: Uint8List.fromList([2])),
    ],
    mode: MealEntryMode.wholeMeal,
  );

  final captured = verify(
    () => client.generateStructured<AiMealSuggestion>(
      prompt: any(named: 'prompt'),
      outputSchema: any(named: 'outputSchema'),
      images: captureAny(named: 'images'),
    ),
  ).captured.single as List<MealPhoto>;
  expect(captured, hasLength(2));
});
```

Update the `stubWholeMeal`/`stubItemized` matchers to the new signature (no `image`/`imageMediaType`, add `images: any(named: 'images')`).

Run: `fvm flutter test test/app/core/networking/repository/meal_ai_repository_test.dart`
Expected: FAIL — signatures don't match yet.

- [ ] **Step 2: Update the client**

```dart
  Future<T> generateStructured<T>({
    required String prompt,
    required SchemanticType<T> outputSchema,
    List<MealPhoto> images = const <MealPhoto>[],
  }) async {
    List<Message>? messages;
    if (images.isNotEmpty) {
      messages = [
        Message(
          role: Role.user,
          content: [
            TextPart(text: prompt),
            for (final image in images)
              MediaPart(
                media: Media(
                  contentType: image.mediaType,
                  url:
                      'data:${image.mediaType};base64,${base64Encode(image.bytes)}',
                ),
              ),
          ],
        ),
      ];
    }

    final response = await _ai.generate<AnthropicOptions, T>(
      model: _model,
      config: _options,
      prompt: images.isEmpty ? prompt : null,
      messages: messages,
      outputSchema: outputSchema,
    );
    final output = response.output;
    if (output == null) {
      throw StateError('Claude returned no structured output for the request.');
    }
    return output;
  }
```

Add `import 'package:the_usual/app/app.dart';` for `MealPhoto` (the client is `coverage:ignore`, no unit test). Update its doc comment to describe `images` instead of a single `image`.

- [ ] **Step 3: Update the repository**

```dart
  Future<List<AiMealSuggestion>> suggestFromPhoto(
    List<MealPhoto> photos, {
    required MealEntryMode mode,
    String? description,
  }) {
    return _estimate(
      prompt: _photoPrompt(mode, description),
      mode: mode,
      images: photos,
    );
  }

  Future<List<AiMealSuggestion>> _estimate({
    required String prompt,
    required MealEntryMode mode,
    List<MealPhoto> images = const <MealPhoto>[],
  }) async {
    if (mode == MealEntryMode.itemized) {
      return _client.generateStructured(
        prompt: prompt,
        outputSchema: _itemsSchema,
        images: images,
      );
    }
    final suggestion = await _client.generateStructured(
      prompt: prompt,
      outputSchema: _suggestionSchema,
      images: images,
    );
    return [suggestion];
  }
```

- [ ] **Step 4: Update the bloc and dev tools call sites**

In `meal_entry_bloc.dart` `_runPhotoEstimate`, replace the single-photo block:

```dart
    final suggestions = await _mealAiRepository.suggestFromPhoto(
      state.photos,
      mode: state.mealEntryMode,
      description: hasDescription ? firstName : null,
    );
```

In `dev_tools_view.dart:187`, wrap the existing photo in a list and drop `imageMediaType`:

```dart
final suggestions = await repository.suggestFromPhoto(
  [photo],
  mode: MealEntryMode.wholeMeal,
);
```

(Adjust to however the dev tool currently obtains `photo`/bytes; it now passes a `List<MealPhoto>`.)

- [ ] **Step 5: Run tests**

Run: `fvm flutter test test/app/core/networking/repository/meal_ai_repository_test.dart`
Run: `fvm flutter test test/app/feature/meal_entry/bloc/meal_entry_bloc_test.dart`
Expected: PASS. Update the bloc test's photo stub to the new `suggestFromPhoto(List<MealPhoto>, ...)` signature if it stubbed the old one.

- [ ] **Step 6: Commit**

Suggested message: `feat: multi-image meal estimation`.

---

### Task 9: Multi-select in the photo picker

**Files:**

- Modify: `lib/app/widgets/inputs/meal_photo_picker.dart`
- Modify: `lib/app/widgets/inputs/food_entry_form.dart` (`_photoWithAi` uses the list)

**Interfaces:**

- Produces: `Future<List<MealPhoto>> pickMealPhotos(BuildContext context)` — camera path returns one photo; library path uses `ImagePicker().pickMultiImage(...)`. Returns `[]` when cancelled. (Rename from `pickMealPhoto`; it is `coverage:ignore` platform glue, so no unit test — verified via the form widget test and a developer run.)

- [ ] **Step 1: Update the picker**

```dart
Future<List<MealPhoto>> pickMealPhotos(BuildContext context) async {
  final source = await showDialog<ImageSource>(
    context: context,
    builder: (context) => SimpleDialog(
      title: const Text('Photo source'),
      children: [
        SimpleDialogOption(
          onPressed: () => Navigator.pop(context, ImageSource.camera),
          child: const Text('Camera'),
        ),
        SimpleDialogOption(
          onPressed: () => Navigator.pop(context, ImageSource.gallery),
          child: const Text('Photo library'),
        ),
      ],
    ),
  );
  if (source == null) return const [];

  final picker = ImagePicker();
  final List<XFile> picked;
  if (source == ImageSource.camera) {
    final photo = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1568,
      maxHeight: 1568,
      imageQuality: 85,
    );
    picked = photo == null ? const [] : [photo];
  } else {
    picked = await picker.pickMultiImage(
      maxWidth: 1568,
      maxHeight: 1568,
      imageQuality: 85,
    );
  }

  return [
    for (final file in picked)
      MealPhoto(bytes: await file.readAsBytes(), mediaType: _imageMediaType(file)),
  ];
}
```

- [ ] **Step 2: Update the form**

```dart
  Future<void> _photoWithAi() async {
    final photos = await pickMealPhotos(context);
    if (photos.isEmpty) return;
    _bloc
      ..add(MealEntryEvent.photosAdded(photos))
      ..add(const MealEntryEvent.photoEstimateRequested());
  }
```

- [ ] **Step 3: Analyzer + full suite**

Run: `fvm dart analyze lib/app/widgets/inputs/meal_photo_picker.dart lib/app/widgets/inputs/food_entry_form.dart`
Run: `fvm flutter test --test-randomize-ordering-seed random`
Expected: clean + PASS.

- [ ] **Step 4: Developer run (manual)**

Ask the developer to run the app, open the add-meal sheet, tap Photo → Photo library, select 2+ images, and confirm one estimate runs over all of them. Wait for their confirmation.

- [ ] **Step 5: Commit**

Suggested message: `feat: attach multiple photos on the add-meal sheet`.

---

# Phase 3 — Share-to-log

### Task 10: Add `receive_sharing_intent` and native share config

**Files:**

- Modify: `pubspec.yaml`
- Modify: `android/app/src/main/AndroidManifest.xml`
- iOS: new Share Extension target + app group (developer-confirmed in Xcode)

**Interfaces:** none (dependency + native config).

- [ ] **Step 1: Add the dependency**

Add under `dependencies:` in `pubspec.yaml`:

```yaml
receive_sharing_intent: ^1.8.1
```

Run: `fvm flutter pub get`
Expected: resolves. (If `1.8.x` is unavailable, pin the latest stable from `fvm flutter pub outdated` and note the version.)

- [ ] **Step 2: Android manifest intent filters**

In `android/app/src/main/AndroidManifest.xml`, on the main `<activity>`, add filters for single and multiple image shares:

```xml
<intent-filter>
    <action android:name="android.intent.action.SEND" />
    <category android:name="android.intent.category.DEFAULT" />
    <data android:mimeType="image/*" />
</intent-filter>
<intent-filter>
    <action android:name="android.intent.action.SEND_MULTIPLE" />
    <category android:name="android.intent.category.DEFAULT" />
    <data android:mimeType="image/*" />
</intent-filter>
```

- [ ] **Step 3: iOS Share Extension (developer-confirmed)**

Document for the developer (this plan cannot complete Xcode signing):

1. In Xcode, add a new **Share Extension** target named `ShareExtension`.
2. Add an **App Group** (e.g. `group.ventures.verygood.theUsual`) capability to **both** the Runner and the ShareExtension targets.
3. Replace the extension's `Info.plist` `NSExtensionActivationRule` to accept images only (e.g. `NSExtensionActivationSupportsImageWithMaxCount` = a small number like 10, others 0).
4. Follow the `receive_sharing_intent` iOS setup README for the `ShareViewController` and the custom URL scheme / app-group key it expects.
5. Confirm signing for the new target.

Hand this list to the developer and wait for confirmation that the target builds before proceeding to Task 13's manual run.

- [ ] **Step 4: Commit**

Suggested message: `chore: add receive_sharing_intent and share intent filters`.

---

### Task 11: `ShareIngestService`

**Files:**

- Create: `lib/app/core/service/share_ingest_service.dart`
- Modify: `lib/app/core/service/service.dart` (barrel — match existing service exports)

**Interfaces:**

- Produces: `@singleton ShareIngestService` with:
  - `Future<List<MealPhoto>> takeInitialPhotos()` — drains the cold-start media once, returns `[]` if none, calls `reset()`.
  - `Stream<List<MealPhoto>> get photoStream` — warm-start shares, normalized to `MealPhoto`s.
  - Downscales nothing itself beyond reading bytes + resolving media type; large originals are acceptable for now (note in code). `coverage:ignore-file` — platform glue.

- [ ] **Step 1: Create the service**

```dart
// coverage:ignore-file
// Platform glue over receive_sharing_intent; no unit-testable logic.
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:the_usual/app/app.dart';

/// {@template share_ingest_service}
/// Bridges the OS "Log meal" share target into the app. Exposes the photos a
/// cold-start share launched with, plus a stream of photos shared while the app
/// is already running. Both are normalized to [MealPhoto]s ready for the AI
/// estimate.
/// {@endtemplate}
@singleton
class ShareIngestService {
  /// Drains the media the app was cold-started with, then clears it so a later
  /// relaunch does not replay the same share. Empty when not launched from a
  /// share.
  Future<List<MealPhoto>> takeInitialPhotos() async {
    final media = await ReceiveSharingIntent.instance.getInitialMedia();
    ReceiveSharingIntent.instance.reset();
    return _toPhotos(media);
  }

  /// Photos shared while the app is already running.
  Stream<List<MealPhoto>> get photoStream =>
      ReceiveSharingIntent.instance.getMediaStream().map(_toPhotos);

  List<MealPhoto> _toPhotos(List<SharedMediaFile> media) {
    return [
      for (final file in media)
        if (file.type == SharedMediaType.image)
          MealPhoto(
            bytes: File(file.path).readAsBytesSync(),
            mediaType: _mediaTypeFor(file.path),
          ),
    ];
  }

  String _mediaTypeFor(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.gif')) return 'image/gif';
    return 'image/jpeg';
  }
}
```

Export from `lib/app/core/service/service.dart`.

- [ ] **Step 2: Wait for generation, analyzer**

Run: `fvm dart analyze lib/app/core/service/share_ingest_service.dart`
Expected: clean. (`injectable` regenerates `getIt` config in the background; confirm `ShareIngestService` appears registered.)

- [ ] **Step 3: Commit**

Suggested message: `feat: ShareIngestService over receive_sharing_intent`.

---

### Task 12: Meal-slot selector on the share sheet

**Files:**

- Modify: `lib/app/widgets/inputs/food_entry_sheet.dart`
- Test: `test/app/widgets/food_entry_sheet_test.dart`

**Interfaces:**

- Consumes: `FoodEntryFormState.mealOfTheDay` / `changeMealOfTheDay` (Task 6), `showMealSelector` param (Task 7).
- Produces: when `showMealSelector` is true the sheet renders a `SegmentedButton<MealOfTheDay>` above the form, bound to the form's slot.

- [ ] **Step 1: Write the failing test**

Add to `food_entry_sheet_test.dart`:

```dart
testWidgets('shows the slot selector only when asked', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: FoodEntrySheet(
          title: 'Log',
          confirmLabel: 'Log',
          showMealSelector: true,
          initialMealOfTheDay: MealOfTheDay.dinner,
        ),
      ),
    ),
  );
  await tester.pump();
  expect(find.byType(SegmentedButton<MealOfTheDay>), findsOneWidget);
});

testWidgets('hides the slot selector by default', (tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: Scaffold(
        body: FoodEntrySheet(title: 'Log', confirmLabel: 'Log'),
      ),
    ),
  );
  await tester.pump();
  expect(find.byType(SegmentedButton<MealOfTheDay>), findsNothing);
});
```

- [ ] **Step 2: Run to verify it fails**

Run: `fvm flutter test test/app/widgets/food_entry_sheet_test.dart -n selector`
Expected: FAIL — no selector rendered.

- [ ] **Step 3: Render the selector**

In `_FoodEntrySheetState.build`, above the `FoodEntryForm`, when `widget.showMealSelector`:

```dart
if (widget.showMealSelector) ...[
  SegmentedButton<MealOfTheDay>(
    showSelectedIcon: false,
    segments: [
      for (final mealOfTheDay in MealOfTheDay.values)
        ButtonSegment(value: mealOfTheDay, label: Text(mealOfTheDay.label)),
    ],
    selected: {_formKey.currentState?.mealOfTheDay ?? MealOfTheDay.breakfast},
    onSelectionChanged: (selection) {
      _formKey.currentState?.changeMealOfTheDay(selection.first);
      setState(() {});
    },
  ),
  SizedBox(height: AppDesign.spacing.md),
],
```

The form already calls the sheet's `onChanged` (which `setState`s) on bloc changes, so the selected segment stays in sync after an estimate. Initialize `_formKey.currentState?.mealOfTheDay` via the `initialMealOfTheDay` passed through to the form.

- [ ] **Step 4: Run tests**

Run: `fvm flutter test test/app/widgets/food_entry_sheet_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

Suggested message: `feat: meal-slot selector on the share entry sheet`.

---

### Task 13: App-root share listener

Wire `ShareIngestService` into `TheUsualsApp`: on cold-start media or a stream event, when onboarding is complete, open the seeded share sheet and log the result to the chosen slot. Hold shares that arrive before onboarding completes.

**Files:**

- Modify: `lib/app/the_usuals_app.dart`
- Modify: `lib/app/navigation/app_router.dart` (expose a root `navigatorKey` for opening the sheet without a widget `context`)
- Test: none automated (platform glue + navigation); verified by developer run. The slot-selector sheet and the bloc already have coverage.

**Interfaces:**

- Consumes: `ShareIngestService`, `AppRouter.router`, `OnboardingBloc.state.step`, `DailyLogBloc`, `UserSettingsBloc`, `FoodEntrySheet(showMealSelector: true, initialPhotos:, autoEstimate: true)`.

- [ ] **Step 1: Expose a root navigator key**

In `app_router.dart`, add a static key and pass it to `GoRouter`:

```dart
static final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>();
// ...
router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: Routes.today,
  // ...
);
```

- [ ] **Step 2: Listen and route in `TheUsualsApp`**

Add to `_TheUsualsAppState`: a `StreamSubscription`, a `_pendingPhotos` buffer, and handling that respects the onboarding gate.

```dart
StreamSubscription<List<MealPhoto>>? _shareSubscription;
List<MealPhoto> _pendingShare = const [];

@override
void initState() {
  super.initState();
  // ...existing...
  _shareSubscription =
      getIt<ShareIngestService>().photoStream.listen(_handleSharedPhotos);
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final initial = await getIt<ShareIngestService>().takeInitialPhotos();
    if (initial.isNotEmpty) _handleSharedPhotos(initial);
  });
}

@override
void dispose() {
  _shareSubscription?.cancel();
  super.dispose();
}

void _handleSharedPhotos(List<MealPhoto> photos) {
  if (photos.isEmpty) return;
  final onboardingComplete =
      getIt<OnboardingBloc>().state.step == OnboardingStep.complete;
  if (!onboardingComplete) {
    // Hold until onboarding finishes; the completion listener drains it.
    _pendingShare = photos;
    return;
  }
  _openShareSheet(photos);
}

Future<void> _openShareSheet(List<MealPhoto> photos) async {
  final navigatorContext = AppRouter.rootNavigatorKey.currentContext;
  if (navigatorContext == null) return;
  getIt<AppRouter>().router.go(Routes.today);
  final result = await TheUsualBottomSheet.show<FoodEntrySheetResult>(
    navigatorContext,
    builder: (context) => FoodEntrySheet(
      title: 'Log from photo',
      confirmLabel: 'Log',
      showMealSelector: true,
      showAddToUsualMeals: true,
      initialPhotos: photos,
      autoEstimate: true,
      initialMealOfTheDay: MealOfTheDay.fromTime(
        TimeOfDay.fromDateTime(clock.now()),
      ),
    ),
  );
  if (result == null) return;
  for (final foodResult in result.foods) {
    if (foodResult.addToUsualMeals) {
      getIt<UserSettingsBloc>().add(
        UserSettingsEvent.usualMealAdded(
          result.mealOfTheDay,
          foodResult.name,
          foodResult.nutrition,
        ),
      );
    }
    getIt<DailyLogBloc>().add(
      DailyLogEvent.mealLogged(
        result.mealOfTheDay,
        foodResult.name,
        nutrition: foodResult.nutrition,
        quantity: foodResult.quantity,
      ),
    );
  }
}
```

- [ ] **Step 3: Drain pending share when onboarding completes**

In the existing `OnboardingBloc` completion `BlocListener` (the block that runs on reaching `OnboardingStep.complete`), after `router.go(Routes.today)`:

```dart
if (_pendingShare.isNotEmpty) {
  final photos = _pendingShare;
  _pendingShare = const [];
  WidgetsBinding.instance.addPostFrameCallback((_) => _openShareSheet(photos));
}
```

- [ ] **Step 4: Analyzer + full suite**

Run: `fvm dart analyze lib/app/the_usuals_app.dart lib/app/navigation/app_router.dart`
Run: `fvm flutter test --test-randomize-ordering-seed random`
Expected: clean + PASS.

- [ ] **Step 5: Developer run (manual, both platforms)**

Ask the developer to:

1. Build to a device/simulator (iOS requires the Task 10 Xcode setup).
2. From Photos, share one image to **The Usual → Log meal**; confirm the app opens, estimates, pre-fills the sheet at the current slot, and Confirm logs it.
3. Repeat sharing **multiple** images; confirm one estimate over all.
4. Share while the app is killed (cold start) and while backgrounded (warm).
5. Reset onboarding, share before finishing onboarding; confirm the sheet appears only after onboarding completes.

Wait for confirmation.

- [ ] **Step 6: Commit**

Suggested message: `feat: open the meal-entry sheet from a shared photo`.

---

## Self-Review

**Spec coverage**

- Share target accepts one or more images → Tasks 10, 11, 13. ✓
- Opens app, estimates, pre-fills current slot, editable, confirm-to-log → Tasks 12, 13. ✓
- Estimate-then-confirm, nothing logged without Confirm → Task 13 logs only on a non-null pop. ✓
- Multiple photos in one pass, grouping by persisted `MealEntryMode` → Tasks 8, 9; bloc uses `state.mealEntryMode`. ✓
- Lift one-photo limit on the normal sheet → Task 9. ✓
- Move add-meal logic into a bloc, existing patterns → Tasks 3–7. ✓
- Widget-owned bloc lifecycle, multiple instances → Task 6 (`getIt` factory, `close()` in dispose). ✓
- `MealPhoto` cross-feature → Task 1 (freezed model). ✓
- Onboarding guard → Task 13 Steps 2–3. ✓
- Cold/warm start → Task 13 Step 2; `reset()` in Task 11. ✓
- Error handling surfaces in the sheet, rows stay editable → Task 5 (`failure` status + message), Task 6 (snackbar via `BlocConsumer`). ✓
- Native config flagged for developer → Task 10 Step 3. ✓
- Testing conventions (blocTest, isA().having, find-by-type, random seed, initHydratedStorage) → Tasks 4–7, 12. ✓

**Placeholder scan:** No `TBD`/`TODO`/"handle edge cases". The one deferred behavior (single→multi photo in `_runPhotoEstimate`) is explicitly stubbed in Task 5 and completed in Task 8, with both call-outs. The dev-tools call-site edit (Task 8 Step 4) notes the exact change.

**Type consistency:** `MealPhoto{bytes, mediaType}`, `FoodDraft{id,name,quantity,nutrition,addToUsualMeals}`, `MealEntryStatus{idle,generating,failure}`, `FoodEntrySheetResult = ({foods, mealOfTheDay})`, `generateStructured({images})`, `suggestFromPhoto(List<MealPhoto>, {mode, description})`, `pickMealPhotos → List<MealPhoto>`, `FoodEntryBloc(MealAiRepository, UserSettingsBloc)` — used identically across tasks. `FoodEntryFormState` getters (`results`, `hasContent`, `isGenerating`, `mealOfTheDay`, `changeMealOfTheDay`) match between Tasks 6, 7, 12.

**Open risk carried from the spec:** iOS Share Extension signing is developer-confirmed; large shared originals are not downscaled on ingest (acceptable for now, noted in Task 11).
