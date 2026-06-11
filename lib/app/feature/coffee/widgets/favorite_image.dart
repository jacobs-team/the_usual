import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_template/app/core/core.dart';
import 'package:flutter_template/app/core/dependencies/dependencies.dart';
import 'package:flutter_template/app/feature/coffee/coffee.dart';
import 'package:flutter_template/app/widgets/widgets.dart';
import 'package:flutter_template/design_system/design_system.dart';
import 'package:flutter_template/l10n/l10n.dart';
import 'package:go_router/go_router.dart';

/// {@template favorite_image}
/// A stateless widget that displays a single favorited coffee image from
/// the local cache.
///
/// It provides functionality to:
/// * Preview the image in an [ExpandedImage] dialog.
/// * Remove the image from favorites via [CoffeeBloc].
/// {@endtemplate}
class FavoriteImage extends StatelessWidget {
  /// {@macro favorite_image}
  const FavoriteImage(this.coffeeImage, {super.key});

  /// The unique URL identifier for the cached coffee image.
  final String coffeeImage;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: getIt<FileCacheService>().getBytes(coffeeImage),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done ||
            snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return GestureDetector(
          onTap: () {
            unawaited(
              showDialog<void>(
                context: context,
                builder: (context) => Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    if (context.canPop()) {
                      context.pop();
                    }
                  },
                  direction: DismissDirection.vertical,
                  child: ExpandedImage(coffeeImage),
                ),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppDesign.radius.lg),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Image.memory(
                  snapshot.data!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  semanticLabel: context.l10n.coffeePhotoLabel,
                ),
                Padding(
                  padding: EdgeInsets.all(AppDesign.spacing.sm),
                  child: GlassContainer(
                    padding: EdgeInsets.zero,
                    child: IconButton(
                      onPressed: () => getIt<CoffeeBloc>().add(
                        ToggleFavoriteImage(coffeeImage),
                      ),
                      tooltip: context.l10n.removeFavoriteTooltip,
                      icon: const Icon(Icons.heart_broken),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
