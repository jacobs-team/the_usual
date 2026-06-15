part of 'onboarding_bloc.dart';

/// {@template onboarding_state}
/// State for the onboarding flow.
/// {@endtemplate}
@freezed
abstract class OnboardingState with _$OnboardingState {
  /// {@macro onboarding_state}
  @JsonSerializable(explicitToJson: true)
  const factory OnboardingState({
    /// Position within [activeSteps], not a raw [OnboardingStep] index.
    @Default(0) int activeStepIndex,

    /// Draft of the user's settings and usuals, committed to
    /// [UserSettingsBloc] when onboarding completes.
    @Default(UserSettingsState()) UserSettingsState settings,
    @Default(<String>[]) List<String> firstLogSelectedIds,

    /// How many of each selected first-log item the user had, keyed by usual
    /// meal id. An item absent from the map defaults to one.
    @Default(<String, int>{}) Map<String, int> firstLogQuantities,
  }) = _OnboardingState;

  const OnboardingState._();

  factory OnboardingState.fromJson(Map<String, dynamic> json) =>
      _$OnboardingStateFromJson(json);

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
  firstLog,
  complete;

  /// Whether this step appears as a dot in the progress indicator. The welcome
  /// intro and completion screen are bookends and don't get a dot.
  bool get showsProgressDot =>
      this != OnboardingStep.welcome && this != OnboardingStep.complete;
}
