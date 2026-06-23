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
    @Default(2) int version,

    /// The step the flow is on, stored by name so reordering the enum never
    /// shifts where saved data resolves.
    @Default(OnboardingStep.welcome) OnboardingStep step,

    /// Draft of the user's settings and usuals, committed to
    /// [UserSettingsBloc] when onboarding completes.
    @Default(UserSettingsState()) UserSettingsState settings,
    @Default(<String>[]) List<String> firstLogSelectedIds,

    /// How many of each selected first-log item the user had, keyed by usual
    /// meal id. An item absent from the map defaults to one. Whole counts saved
    /// by older versions read back fine, since json reads each value as a num.
    @Default(<String, double>{}) Map<String, double> firstLogQuantities,

    /// True when onboarding was marked complete programmatically rather than by
    /// the user finishing the flow — a returning signed-in user resuming on a
    /// fresh install whose cloud data is already applied. The completion
    /// listener uses it to skip committing the (empty) draft over cloud data.
    /// Transient: never persisted.
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(false)
    bool completedSilently,
  }) = _OnboardingState;

  const OnboardingState._();

  static const _currentVersion = 2;

  factory OnboardingState.fromJson(Map<String, dynamic> json) =>
      OnboardingState._fromVersionedJson(json);

  factory OnboardingState._fromVersionedJson(Map<String, dynamic> json) {
    final version = json['version'] as int? ?? 0;
    switch (version) {
      case 0:
        return _migratedFromLegacyIndex(json, goalsAlreadyPresent: false);
      case 1:
        return _migratedFromLegacyIndex(json, goalsAlreadyPresent: true);
      case _currentVersion:
        return _$OnboardingStateFromJson(json);
      default:
        // A newer, unknown version, e.g. after the user downgrades the app.
        // Resolve to a completed onboarding so the user is never sent back
        // through it, which would let a stale draft overwrite their settings.
        return const OnboardingState(step: OnboardingStep.complete);
    }
  }

  /// Converts legacy data that stored `activeStepIndex` as a position in the
  /// active-steps list into the current name-based [step]. v0 predates the
  /// `goals` step; v1 includes it. The legacy active-steps list dropped
  /// `mealSchedule` when reminders were off, mirrored here.
  static OnboardingState _migratedFromLegacyIndex(
    Map<String, dynamic> json, {
    required bool goalsAlreadyPresent,
  }) {
    final settings = json['settings'] == null
        ? const UserSettingsState()
        : UserSettingsState.fromJson(json['settings'] as Map<String, dynamic>);

    // Step names as they were ordered in the legacy positional schema. v0
    // predates `goals`; both legacy schemas dropped `mealSchedule` when
    // reminders were off.
    final legacyNames =
        <String>[
          'welcome',
          'buildUsuals',
          'reminderStyle',
          'mealSchedule',
          'weightTracking',
          if (goalsAlreadyPresent) 'goals',
          'firstLog',
          'complete',
        ]..removeWhere(
          (name) =>
              name == 'mealSchedule' &&
              settings.reminderStyle == ReminderStyle.none,
        );

    final index = (json['activeStepIndex'] as int? ?? 0).clamp(
      0,
      legacyNames.length - 1,
    );

    // The two legacy reminder steps collapse into the single reminders step.
    const legacyToCurrent = <String, String>{
      'reminderStyle': 'reminders',
      'mealSchedule': 'reminders',
    };
    final legacyName = legacyNames[index];
    final currentName = legacyToCurrent[legacyName] ?? legacyName;

    return _$OnboardingStateFromJson({
      ...json,
      'version': _currentVersion,
      'step': currentName,
    });
  }

  /// The steps reachable in the flow.
  List<OnboardingStep> get activeSteps => OnboardingStep.values;
}

/// The ordered steps of the onboarding flow.
enum OnboardingStep {
  welcome,
  buildUsuals,
  firstLog,
  reminders,
  weightTracking,
  goals,
  complete;

  /// Whether this step appears as a dot in the progress indicator. The welcome
  /// intro and completion screen are bookends and don't get a dot.
  bool get showsProgressDot =>
      this != OnboardingStep.welcome && this != OnboardingStep.complete;
}
