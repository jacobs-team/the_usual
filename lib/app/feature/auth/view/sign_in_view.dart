import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';
import 'package:the_usual/l10n/l10n.dart';

/// {@template sign_in_view}
/// The one-time, optional sign-in screen shown after onboarding: sign in with
/// Google, or continue without an account.
/// {@endtemplate}
class SignInView extends StatelessWidget {
  /// {@macro sign_in_view}
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppDesign.spacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const GoogleSignInButton(),
              SizedBox(height: AppDesign.spacing.md),
              TextButton(
                onPressed: () => getIt<AuthCubit>().continueAsGuest(),
                child: Text(context.l10n.continueAsGuest),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
