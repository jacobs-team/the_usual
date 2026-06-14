import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(WeightCheckinFrequency, () {
    test('exposes a display label for each frequency', () {
      expect(WeightCheckinFrequency.daily.label, equals('Daily'));
      expect(WeightCheckinFrequency.everyTwoDays.label, equals('Every 2 days'));
      expect(WeightCheckinFrequency.weekly.label, equals('Weekly'));
      expect(WeightCheckinFrequency.off.label, equals('Off'));
    });
  });
}
