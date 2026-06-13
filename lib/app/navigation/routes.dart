import 'package:the_usual/app/app.dart';

/// {@template routes}
/// A collection of static string constants representing
/// the application's route paths.
///
/// These constants are used by [AppRouter] to define the navigation tree.
/// They also will be shown in the Url bar on web.
/// {@endtemplate}
abstract class Routes {
  // static const String coffee = '/coffee';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String settings = '/settings';
  static const String usualMeals = '/settings/$usualMealsSegment';
  static const String usualMealsSegment = 'usuals';
  // static const String favorites = '/favorites';
  // static const String signIn = '/sign-in';
  static const String devTools = '/dev-tools';
}
