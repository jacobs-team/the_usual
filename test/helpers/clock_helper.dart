import 'package:clock/clock.dart';

/// A fixed instant for tests so anything reading the ambient [clock] resolves
/// deterministically, independent of the machine's wall clock. 9:30 AM sits
/// well inside a midnight-bounded day and resolves to breakfast.
final DateTime testNow = DateTime(2026, 6, 18, 9, 30);

/// Runs [body] with the ambient [clock] pinned to [at] (defaults to [testNow]).
/// Wrap any test whose code-under-test reads [clock] so the outcome doesn't
/// depend on when the suite runs.
Future<T> withTestClock<T>(
  Future<T> Function() body, {
  DateTime? at,
}) {
  return withClock(Clock.fixed(at ?? testNow), body);
}
