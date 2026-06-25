import 'package:freezed_annotation/freezed_annotation.dart';

part 'calorie_goal_entry.freezed.dart';
part 'calorie_goal_entry.g.dart';

/// {@template calorie_goal_entry}
/// A daily calorie target and the day it took effect, so historical charts can
/// show the goal that was active at each point rather than the latest one. A
/// null [calories] records the goal being cleared from [effectiveFrom] onward.
/// {@endtemplate}
@freezed
abstract class CalorieGoalEntry with _$CalorieGoalEntry {
  /// {@macro calorie_goal_entry}
  const factory CalorieGoalEntry({
    required DateTime effectiveFrom,
    int? calories,
  }) = _CalorieGoalEntry;

  factory CalorieGoalEntry.fromJson(Map<String, dynamic> json) =>
      _$CalorieGoalEntryFromJson(json);
}
