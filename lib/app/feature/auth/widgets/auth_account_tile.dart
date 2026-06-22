import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/l10n/l10n.dart';

/// {@template auth_account_tile}
/// The Settings account control: shows the signed-in Google account with a sign
/// out action, or a sign-in button when signed out / guest.
/// {@endtemplate}
class AuthAccountTile extends StatelessWidget {
  /// {@macro auth_account_tile}
  const AuthAccountTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthCubit, AuthState, AuthState>(
      bloc: getIt<AuthCubit>(),
      selector: (state) => state,
      builder: (context, state) {
        final user = state.user;
        if (state.status == AuthStatus.signedIn && user != null) {
          return Card(
            margin: EdgeInsets.zero,
            child: ListTile(
              leading: user.photoUrl == null
                  ? const Icon(Icons.account_circle)
                  : CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl!),
                    ),
              title: Text(user.displayName ?? user.email),
              subtitle: user.displayName == null ? null : Text(user.email),
              trailing: TextButton(
                onPressed: () => getIt<AuthCubit>().signOut(),
                child: Text(context.l10n.signOut),
              ),
            ),
          );
        }
        return const GoogleSignInButton();
      },
    );
  }
}
