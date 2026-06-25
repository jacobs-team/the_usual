import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_usual/app/model/model.dart';

part 'weight_goal_entry.freezed.dart';
part 'weight_goal_entry.g.dart';

/// {@template weight_goal_entry}
/// A target weight and the day it took effect, so historical charts can show
/// the goal that was active at each point rather than the latest one. The
/// [weightUnit] is the unit the goal was entered in. A null [weight] records
/// the goal being cleared from [effectiveFrom] onward.
/// {@endtemplate}
@freezed
abstract class WeightGoalEntry with _$WeightGoalEntry {
  /// {@macro weight_goal_entry}
  const factory WeightGoalEntry({
    required DateTime effectiveFrom,
    required WeightUnit weightUnit,
    double? weight,
  }) = _WeightGoalEntry;

  factory WeightGoalEntry.fromJson(Map<String, dynamic> json) =>
      _$WeightGoalEntryFromJson(json);
}
