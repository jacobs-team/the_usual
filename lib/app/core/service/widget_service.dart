// coverage:ignore-file
// Platform glue over home_widget; no unit-testable logic.
import 'package:home_widget/home_widget.dart';
import 'package:injectable/injectable.dart';

/// {@template widget_service}
/// Pushes today's calorie summary into the home- and lock-screen widget. The
/// widget can't read app state directly, so it reads these values from the
/// shared App Group container; call [updateCalories] whenever the goal or the
/// day's logged meals change.
/// {@endtemplate}
@singleton
class WidgetService {
  /// {@macro widget_service}
  WidgetService() {
    HomeWidget.setAppGroupId(_appGroupId);
  }

  /// Matches the App Group the iOS widget and Share extension already share.
  static const _appGroupId = 'group.com.jblankenship.theusual';

  /// The iOS widget's `kind`, used to ask WidgetKit to reload it.
  static const _iOSWidgetKind = 'TheUsualLauncherWidget';

  /// Writes the day's calorie [goal] and [consumed] totals to the widget and
  /// asks the OS to redraw it. A null [goal] means the user hasn't set one, so
  /// the widget shows its plain launcher face instead of a calorie ring.
  ///
  /// [dayRollover] is the instant the current logical day ends. The widget uses
  /// it to reset itself to the full goal at the start of the next day, so it
  /// stays correct even if the app isn't opened that day.
  Future<void> updateCalories({
    required int? goal,
    required int consumed,
    required int protein,
    required int carbs,
    required int fat,
    required DateTime dayRollover,
  }) async {
    final hasGoal = goal != null && goal > 0;
    await HomeWidget.saveWidgetData<bool>('hasGoal', hasGoal);
    await HomeWidget.saveWidgetData<int>('calorieGoal', goal ?? 0);
    await HomeWidget.saveWidgetData<int>('caloriesConsumed', consumed);
    await HomeWidget.saveWidgetData<int>(
      'caloriesRemaining',
      hasGoal ? goal - consumed : 0,
    );
    await HomeWidget.saveWidgetData<int>('proteinGrams', protein);
    await HomeWidget.saveWidgetData<int>('carbsGrams', carbs);
    await HomeWidget.saveWidgetData<int>('fatGrams', fat);
    await HomeWidget.saveWidgetData<int>(
      'dayRolloverEpoch',
      dayRollover.millisecondsSinceEpoch ~/ 1000,
    );
    await HomeWidget.updateWidget(iOSName: _iOSWidgetKind);
  }
}
