import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_usual/app/app.dart';

/// {@template user_settings_view}
/// Settings screen where the user can revisit the choices they made during
/// onboarding: check-in style, meal schedule, weight check-ins, and their
/// usual meals.
/// {@endtemplate}
class UserSettingsView extends StatelessWidget {
  /// {@macro user_settings_view}
  const UserSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Settings'),
        leading: BackButton(onPressed: () => context.go(Routes.home)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SectionLabel('HOW WE CHECK IN'),
            const SizedBox(height: 8),
            const ReminderStyleSection(),
            const SizedBox(height: 24),
            const SectionLabel('WHEN WE ASK'),
            const SizedBox(height: 8),
            const MealScheduleSection(),
            const SizedBox(height: 24),
            const SectionLabel('WEIGHT CHECK-INS'),
            const SizedBox(height: 8),
            const WeightSection(),
            const SizedBox(height: 24),
            const SectionLabel('YOUR FOOD'),
            const SizedBox(height: 8),
            const UsualMealsRow(),
            const SizedBox(height: 24),
            const ReplayOnboardingRow(),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'No account. Your data stays on your phone.',
                style: textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
