import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

part 'onboarding_bloc.freezed.dart';
part 'onboarding_bloc.g.dart';

/// {@template onboarding_bloc}
/// A [HydratedBloc] that manages progress through the onboarding flow.
/// {@endtemplate}
@lazySingleton
class OnboardingBloc extends HydratedBloc<OnboardingEvent, OnboardingState> {
  /// {@macro onboarding_bloc}
  OnboardingBloc() : super(const OnboardingState()) {
    on<OnboardingEvent>(
      (event, emit) => switch (event) {
        GetStartedPressed() => _onGetStartedPressed(event, emit),
      },
    );
  }

  void _onGetStartedPressed(
    GetStartedPressed event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(step: OnboardingStep.buildUsuals));
  }

  @override
  OnboardingState fromJson(Map<String, dynamic> json) {
    return OnboardingState.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(OnboardingState state) {
    return state.toJson();
  }
}

@Freezed()
sealed class OnboardingEvent with _$OnboardingEvent {
  const factory OnboardingEvent.getStartedPressed() = GetStartedPressed;
}

/// {@template onboarding_state}
/// State for the onboarding flow.
/// {@endtemplate}
@freezed
abstract class OnboardingState with _$OnboardingState {
  /// {@macro onboarding_state}
  const factory OnboardingState({
    @Default(OnboardingStep.welcome) OnboardingStep step,
  }) = _OnboardingState;

  factory OnboardingState.fromJson(Map<String, dynamic> json) =>
      _$OnboardingStateFromJson(json);
}

/// The ordered steps of the onboarding flow.
enum OnboardingStep {
  welcome,
  buildUsuals,
  reminderStyle,
  mealSchedule,
  weightTracking,
  firstLog,
  complete,
}
