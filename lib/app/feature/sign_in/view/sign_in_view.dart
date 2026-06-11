// ignore_for_file: public_member_api_docs, placeholder
// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:flutter_template/app/core/core.dart';
import 'package:flutter_template/app/core/dependencies/dependencies.dart';
import 'package:flutter_template/l10n/l10n.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => getIt<AuthCubit>().setSession('username', 'token'),
          child: Text(context.l10n.signIn),
        ),
      ),
    );
  }
}
