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
