import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(DevToolsCubit, () {
    setUp(initHydratedStorage);

    blocTest<DevToolsCubit, DevToolsState>(
      'toggleDebugApi emits toggled isApiDebug in $DevToolsCubit',
      build: DevToolsCubit.new,
      act: (cubit) => cubit.toggleDebugApi(),
      expect: () => [
        const DevToolsState(isApiDebug: false),
      ],
    );

    test('fromJson returns correct $DevToolsState', () {
      final json = <String, dynamic>{'isApiDebug': false};
      expect(
        DevToolsCubit().fromJson(json),
        equals(const DevToolsState(isApiDebug: false)),
      );
    });

    test('toJson returns correct $Map from $DevToolsState', () {
      const state = DevToolsState(isApiDebug: false);
      final json = DevToolsCubit().toJson(state);
      expect(json['isApiDebug'], isFalse);
    });
  });
}
