import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/app/core/dependencies/dependencies.dart';
import 'package:flutter_template/app/feature/feature.dart';
import 'package:flutter_template/app/widgets/widgets.dart';
import 'package:flutter_template/design_system/design_system.dart';
import 'package:flutter_template/l10n/l10n.dart';

/// {@template floating_controls}
/// A glassmorphic pill of floating controls for the coffee discovery feed.
/// {@endtemplate}
class FloatingControls extends StatelessWidget {
  /// {@macro floating_controls}
  const FloatingControls({
    required PageController pageController,
    super.key,
  }) : _pageController = pageController;

  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: AppDesign.spacing.sm,
      children: [
        GlassContainer(
          padding: EdgeInsets.zero,
          child: IconButton(
            onPressed: () => _pageController.previousPage(
              duration: AppDesign.durations.fast,
              curve: Curves.easeInOut,
            ),
            tooltip: context.l10n.previousImageTooltip,
            icon: const Icon(Icons.arrow_upward),
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        GlassContainer(
          padding: EdgeInsets.zero,
          child: IconButton(
            onPressed: () => _pageController.nextPage(
              duration: AppDesign.durations.fast,
              curve: Curves.easeInOut,
            ),
            tooltip: context.l10n.nextImageTooltip,
            icon: const Icon(Icons.arrow_downward),
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        _FavoriteButton(colorScheme: colorScheme),
      ],
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      CoffeeBloc,
      CoffeeState,
      (int, List<String>, List<String>, bool)
    >(
      bloc: getIt<CoffeeBloc>(),
      selector: (state) => (
        state.currentImage,
        state.images,
        state.favorites,
        state.loadingState == CoffeeLoadingState.saving,
      ),
      builder: (context, record) {
        final (currentImage, images, favorites, savingImage) = record;

        if (images.isEmpty || currentImage >= images.length) {
          return const SizedBox.shrink();
        }

        final imageUrl = images[currentImage];
        final favorited = favorites.contains(imageUrl);

        return GlassContainer(
          padding: EdgeInsets.all(AppDesign.spacing.sm),
          child: IconButton(
            onPressed: () =>
                getIt<CoffeeBloc>().add(ToggleFavoriteImage(imageUrl)),
            tooltip: context.l10n.toggleFavoriteTooltip,
            icon: savingImage
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : Icon(
                    favorited ? Icons.favorite : Icons.favorite_outline,
                  ),
            color: favorited
                ? colorScheme.onPrimary
                : colorScheme.onSurfaceVariant,
            style: favorited
                ? IconButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                  )
                : null,
          ),
        );
      },
    );
  }
}
