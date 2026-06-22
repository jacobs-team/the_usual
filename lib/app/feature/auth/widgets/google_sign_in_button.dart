// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/l10n/l10n.dart';

/// {@template google_sign_in_button}
/// Runs the interactive Google sign-in flow, showing a spinner while it is in
/// progress and a snackbar if it fails. The in-progress state is local to the
/// button, not the cubit.
/// {@endtemplate}
class GoogleSignInButton extends StatefulWidget {
  /// {@macro google_sign_in_button}
  const GoogleSignInButton({super.key});

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _busy = false;

  Future<void> _signIn() async {
    setState(() => _busy = true);
    try {
      await getIt<AuthCubit>().signInWithGoogle();
    } catch (error, stackTrace) {
      log(
        'Google sign-in failed',
        name: 'GoogleSignInButton',
        error: error,
        stackTrace: stackTrace,
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$error')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: _busy ? null : _signIn,
      icon: _busy
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.login),
      label: Text(context.l10n.signInWithGoogle),
    );
  }
}
