import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(ReminderStyle, () {
    test('notifications carries a permission note', () {
      expect(ReminderStyle.notifications.label, equals('Notifications'));
      expect(
        ReminderStyle.notifications.description,
        equals('A quick nudge at your meal times.'),
      );
      expect(
        ReminderStyle.notifications.permissionNote,
        equals("We'll ask for permission next."),
      );
    });

    test('none has no permission note', () {
      expect(ReminderStyle.none.label, equals("Don't remind me"));
      expect(
        ReminderStyle.none.description,
        equals('Log on your own schedule.'),
      );
      expect(ReminderStyle.none.permissionNote, isNull);
    });
  });
}
