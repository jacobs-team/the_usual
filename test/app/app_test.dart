import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../helpers/helpers.dart';

void main() {
  group(TheUsualsApp, () {
    late DevToolsCubit devToolsCubit;

    setUp(() {
      initHydratedStorage();
      devToolsCubit = MockDevToolsCubit();
      when(() => devToolsCubit.state).thenReturn(const DevToolsState());
    });

    testWidgets('renders $TheUsualsApp', (tester) async {
      await tester.pumpPumpPumpItUP(
        deps: [devToolsCubit],
        const TheUsualsApp(),
      );
      expect(find.byType(TheUsualsApp), findsOneWidget);
    });
  });
}
