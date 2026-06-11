import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_template/app/core/core.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/helpers.dart';

void main() {
  group(AuthCubit, () {
    const user = 'user';
    const token = 'token';

    setUp(initHydratedStorage);

    blocTest<AuthCubit, AuthState>(
      'emits correct state when setSession is called',
      build: AuthCubit.new,
      act: (cubit) => cubit.setSession(user, token),
      expect: () => [const AuthState(user: user, token: token)],
    );

    blocTest<AuthCubit, AuthState>(
      'emits empty state when logout is called',
      build: AuthCubit.new,
      seed: () => const AuthState(user: user, token: token),
      act: (cubit) => cubit.logout(),
      expect: () => [const AuthState()],
    );

    test('signedIn returns true when user and token are present', () {
      const state = AuthState(user: user, token: token);
      expect(state.signedIn, isTrue);
    });

    test('fromJson returns correct $AuthState', () {
      final json = <String, dynamic>{'user': user, 'token': token};
      expect(
        AuthCubit().fromJson(json),
        const AuthState(user: user, token: token),
      );
    });

    test(
      'addListener and removeListener manage listeners and notify on onChange',
      () {
        final cubit = AuthCubit();
        var called = 0;
        void listener() => called++;

        cubit
          ..addListener(listener)
          ..setSession(user, token);
        expect(called, 1);

        cubit
          ..removeListener(listener)
          ..setSession('new_user', 'new_token');
        expect(called, 1);
      },
    );
  });
}
