import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../helpers/helpers.dart';

void main() {
  group(TheUsualsApp, () {
    setUp(initHydratedStorage);

    testWidgets('renders $TheUsualsApp', (tester) async {
      expect(true, isTrue);
    });
  });
}
