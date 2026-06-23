import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';

/// {@template workouts_view}
/// The Workouts tab: logs the day's workouts from the user's usuals, grouped
/// by training group. The body is filled in a later phase.
/// {@endtemplate}
class WorkoutsView extends StatelessWidget {
  /// {@macro workouts_view}
  const WorkoutsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TheUsualAppBar(title: 'Workouts'),
      body: SizedBox.shrink(),
    );
  }
}
