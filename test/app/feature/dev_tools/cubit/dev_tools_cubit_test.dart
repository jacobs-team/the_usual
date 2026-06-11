import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_template/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

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

    blocTest<DevToolsCubit, DevToolsState>(
      'toggleDarkMode emits toggled isDarkMode in $DevToolsCubit',
      build: DevToolsCubit.new,
      act: (cubit) => cubit.toggleDarkMode(),
      expect: () => [
        const DevToolsState(isDarkMode: true),
      ],
    );

    test('fromJson returns correct $DevToolsState', () {
      final json = <String, dynamic>{'isApiDebug': false, 'isDarkMode': true};
      expect(
        DevToolsCubit().fromJson(json),
        equals(const DevToolsState(isApiDebug: false, isDarkMode: true)),
      );
    });

    test('toJson returns correct $Map from $DevToolsState', () {
      const state = DevToolsState(isApiDebug: false, isDarkMode: true);
      final json = DevToolsCubit().toJson(state);
      expect(json['isApiDebug'], isFalse);
      expect(json['isDarkMode'], isTrue);
    });
  });
}
