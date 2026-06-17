part of 'onboarding_bloc.dart';

/// {@template onboarding_state}
/// State for the onboarding flow.
/// {@endtemplate}
@freezed
abstract class OnboardingState with _$OnboardingState {
  /// {@macro onboarding_state}
  @JsonSerializable(explicitToJson: true)
  const factory OnboardingState({
    /// Schema version of the persisted state. Bump it and add a `fromJson`
    /// case whenever the persisted shape changes in a way old stored data
    /// can't be read as-is, so existing users are migrated instead of reset.
    @Default(1) int version,

    /// Position within [activeSteps], not a raw [OnboardingStep] index.
    @Default(0) int activeStepIndex,

    /// Draft of the user's settings and usuals, committed to
    /// [UserSettingsBloc] when onboarding completes.
    @Default(UserSettingsState()) UserSettingsState settings,
    @Default(<String>[]) List<String> firstLogSelectedIds,

    /// How many of each selected first-log item the user had, keyed by usual
    /// meal id. An item absent from the map defaults to one. Whole counts saved
    /// by older versions read back fine, since json reads each value as a num.
    @Default(<String, double>{}) Map<String, double> firstLogQuantities,
  }) = _OnboardingState;

  const OnboardingState._();

  /// The version written by the current app. v0 is unversioned data saved
  /// before the `goals` step was added.
  static const _currentVersion = 1;

  factory OnboardingState.fromJson(Map<String, dynamic> json) =>
      OnboardingState._fromVersionedJson(json);

  factory OnboardingState._fromVersionedJson(Map<String, dynamic> json) {
    final version = json['version'] as int? ?? 0;
    switch (version) {
      case 0:
        return _migratedFromV0(json);
      case _currentVersion:
        return _$OnboardingStateFromJson(json);
      default:
        // A newer, unknown version, e.g. after the user downgrades the app.
        // Resolve to a completed onboarding (the clamped step) so the user is
        // never sent back through it, which would let a stale draft overwrite
        // their saved settings.
        return OnboardingState(activeStepIndex: OnboardingStep.values.length);
    }
  }

  /// Migrates v0 data, which stored [activeStepIndex] as a position in the
  /// active-steps list from before the `goals` step existed. `goals` was
  /// inserted right after `weightTracking`, shifting every later step down by
  /// one, so an index at or past that insertion point must move up by one to
  /// keep pointing at the same step. Without this a user who had finished
  /// onboarding resolves to an earlier step, is sent back through it, and
  /// re-completing overwrites their saved settings.
  static OnboardingState _migratedFromV0(Map<String, dynamic> json) {
    final stored = _$OnboardingStateFromJson(json);
    final remindersOff = stored.settings.reminderStyle == ReminderStyle.none;
    final goalsInsertedAt = remindersOff ? 4 : 5;
    final activeStepIndex = stored.activeStepIndex >= goalsInsertedAt
        ? stored.activeStepIndex + 1
        : stored.activeStepIndex;
    return stored.copyWith(
      version: _currentVersion,
      activeStepIndex: activeStepIndex,
    );
  }

  /// The steps reachable given the current selections. Picking
  /// [ReminderStyle.none] removes the meal schedule step.
  List<OnboardingStep> get activeSteps {
    final steps = [...OnboardingStep.values];
    if (settings.reminderStyle == ReminderStyle.none) {
      steps.remove(OnboardingStep.mealSchedule);
    }
    return steps;
  }

  /// The step the flow is on, clamped to the valid range.
  OnboardingStep get step {
    final steps = activeSteps;
    return steps[activeStepIndex.clamp(0, steps.length - 1)];
  }
}

/// The ordered steps of the onboarding flow.
enum OnboardingStep {
  welcome,
  buildUsuals,
  reminderStyle,
  mealSchedule,
  weightTracking,
  goals,
  firstLog,
  complete;

  /// Whether this step appears as a dot in the progress indicator. The welcome
  /// intro and completion screen are bookends and don't get a dot.
  bool get showsProgressDot =>
      this != OnboardingStep.welcome && this != OnboardingStep.complete;
}
