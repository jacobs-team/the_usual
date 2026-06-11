import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/app/core/core.dart';
import 'package:flutter_template/app/core/dependencies/dependencies.dart';
import 'package:flutter_template/app/feature/feature.dart';
import 'package:flutter_template/app/navigation/navigation.dart';
import 'package:flutter_template/app/widgets/widgets.dart';
import 'package:flutter_template/design_system/design_system.dart';
import 'package:flutter_template/l10n/l10n.dart';

/// {@template coffee_app}
/// The root widget of the application.
///
/// This widget configures the [MaterialApp] with:
/// * Routing via [AppRouter].
/// * Theming via [AppTheme].
/// * Localization via [AppLocalizations].
/// * Responsive layout support via the [Layout] widget.
/// {@endtemplate}
class CoffeeApp extends StatelessWidget {
  /// {@macro coffee_app}
  const CoffeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      bloc: getIt<AuthCubit>(),
      listenWhen: (previous, current) => previous.signedIn && !current.signedIn,
      listener: (context, state) => getIt<CoffeeBloc>().add(const ClearFeed()),
      child: BlocSelector<DevToolsCubit, DevToolsState, bool>(
        bloc: getIt<DevToolsCubit>(),
        selector: (state) => state.isDarkMode,
        builder: (context, isDarkMode) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: getIt<AppRouter>().router,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: !kDebugMode
                ? ThemeMode.system
                : isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => Layout(child: child!),
          );
        },
      ),
    );
  }
}
