import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template onboarding_top_bar}
/// App bar shared by onboarding screens: back arrow, centered progress dots,
/// and an optional skip action.
/// {@endtemplate}
class OnboardingTopBar extends StatelessWidget implements PreferredSizeWidget {
  /// {@macro onboarding_top_bar}
  const OnboardingTopBar({required this.step, this.showSkip = true, super.key});

  /// The step this bar is rendered on, used to highlight the progress dot.
  final OnboardingStep step;

  /// Whether the skip action is shown.
  final bool showSkip;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      centerTitle: true,
      leading: IconButton(
        onPressed: () =>
            getIt<OnboardingBloc>().add(const OnboardingEvent.backPressed()),
        icon: const Icon(Icons.arrow_back),
      ),
      title:
          BlocSelector<OnboardingBloc, OnboardingState, List<OnboardingStep>>(
            bloc: getIt<OnboardingBloc>(),
            selector: (state) => state.activeSteps,
            builder: (context, steps) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final dotStep in steps)
                  if (dotStep != OnboardingStep.complete)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDesign.spacing.xs,
                      ),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: dotStep == step
                              ? colorScheme.primary
                              : colorScheme.outlineVariant,
                        ),
                        child: SizedBox.square(dimension: AppDesign.spacing.sm),
                      ),
                    ),
              ],
            ),
          ),
      actions: [
        if (showSkip)
          TextButton(
            onPressed: () => getIt<OnboardingBloc>().add(
              const OnboardingEvent.skipPressed(),
            ),
            child: const Text('Skip'),
          ),
      ],
    );
  }
}
