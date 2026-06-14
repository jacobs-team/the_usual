import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

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
            const SectionLabel('YOUR FOOD'),
            SizedBox(height: AppDesign.spacing.sm),
            const UsualMealsTile(),
            SizedBox(height: AppDesign.spacing.xl),
            const SectionLabel('APPEARANCE'),
            SizedBox(height: AppDesign.spacing.sm),
            const AppearanceSection(),
            SizedBox(height: AppDesign.spacing.xl),
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
