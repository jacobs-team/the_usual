import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template user_settings_view}
/// Settings screen where the user can revisit the choices they made during
/// onboarding: check-in style, meal schedule, weight check-ins, and their
/// usual meals.
///
/// A `focus=goals` query parameter scrolls the Goals section into view on
/// open, used by the Today view's "Set goal" button.
/// {@endtemplate}
class UserSettingsView extends StatefulWidget {
  /// {@macro user_settings_view}
  const UserSettingsView({super.key});

  @override
  State<UserSettingsView> createState() => _UserSettingsViewState();
}

class _UserSettingsViewState extends State<UserSettingsView> {
  final GlobalKey _goalsKey = GlobalKey();
  bool _didFocusGoals = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didFocusGoals) return;
    final focus = GoRouterState.of(context).uri.queryParameters['focus'];
    if (focus != 'goals') return;
    _didFocusGoals = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final goalsContext = _goalsKey.currentContext;
      if (goalsContext == null) return;
      unawaited(
        Scrollable.ensureVisible(
          goalsContext,
          duration: AppDesign.durations.fast,
          alignment: 0.1,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Settings'),
        leading: BackButton(onPressed: () => context.go(Routes.today)),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(AppDesign.spacing.xl),
          children: [
            const SectionLabel('HOW WE CHECK IN'),
            SizedBox(height: AppDesign.spacing.sm),
            const ReminderStyleSection(),
            SizedBox(height: AppDesign.spacing.xl),
            const SectionLabel('WHEN WE ASK'),
            SizedBox(height: AppDesign.spacing.sm),
            const MealScheduleSection(),
            SizedBox(height: AppDesign.spacing.xl),
            const SectionLabel('WEIGHT CHECK-INS'),
            SizedBox(height: AppDesign.spacing.sm),
            const WeightSection(),
            SizedBox(height: AppDesign.spacing.xl),
            const SectionLabel('WORKOUTS'),
            SizedBox(height: AppDesign.spacing.sm),
            const WorkoutSection(),
            SizedBox(height: AppDesign.spacing.xl),
            SectionLabel('GOALS', key: _goalsKey),
            SizedBox(height: AppDesign.spacing.sm),
            const GoalsSection(),
            SizedBox(height: AppDesign.spacing.xl),
            const SectionLabel('YOUR FOOD'),
            SizedBox(height: AppDesign.spacing.sm),
            const UsualMealsTile(),
            SizedBox(height: AppDesign.spacing.xl),
            const SectionLabel('YOUR DAY'),
            SizedBox(height: AppDesign.spacing.sm),
            const DayStartSection(),
            SizedBox(height: AppDesign.spacing.xl),
            const SectionLabel('APPEARANCE'),
            SizedBox(height: AppDesign.spacing.sm),
            const AppearanceSection(),
            SizedBox(height: AppDesign.spacing.xl),
            const SectionLabel('ACCOUNT'),
            SizedBox(height: AppDesign.spacing.sm),
            const AuthAccountTile(),
          ],
        ),
      ),
    );
  }
}
