import 'package:flutter/material.dart';
import 'package:flutter_template/design_system/design_system.dart';
import 'package:flutter_template/l10n/l10n.dart';

/// {@template coffee_image}
/// A stateful widget for coffee images that supports double-tap interactions.
///
/// When double-tapped, it triggers [onTap] and displays a temporary heart
/// animation overlay.
/// {@endtemplate}
class CoffeeImage extends StatefulWidget {
  /// {@macro coffee_image}
  const CoffeeImage({
    required this.onTap,
    required this.url,
    this.favorited = false,
    super.key,
  });

  /// Callback triggered when the image is double-tapped.
  final void Function() onTap;

  /// The image url to display.
  final String url;

  /// Whether the image is currently favorited.
  final bool favorited;

  @override
  State<CoffeeImage> createState() => _CoffeeImageState();
}

class _CoffeeImageState extends State<CoffeeImage> {
  bool _showHeart = false;
  IconData _heartIcon = Icons.favorite;

  void _handleDoubleTap() {
    _heartIcon = widget.favorited ? Icons.heart_broken : Icons.favorite;
    widget.onTap();

    setState(() {
      _showHeart = true;
    });

    Future.delayed(AppDesign.durations.fast, () {
      if (mounted) {
        setState(() {
          _showHeart = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onDoubleTap: _handleDoubleTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: AppDesign.spacing.md),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDesign.radius.lg),
              ),
              clipBehavior: Clip.antiAlias,
              constraints: BoxConstraints(
                minHeight: MediaQuery.sizeOf(context).width,
                minWidth: double.infinity,
              ),
              child: Image.network(
                widget.url,
                fit: BoxFit.cover,
                semanticLabel: context.l10n.coffeePhotoLabel,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.error_outline,
                      color: Theme.of(context).colorScheme.error,
                      size: AppDesign.iconSizes.lg,
                    ),
                  );
                },
              ),
            ),
          ),
          IgnorePointer(
            child: AnimatedOpacity(
              opacity: _showHeart ? 1.0 : 0.0,
              duration: AppDesign.durations.fast,
              child: Icon(
                _heartIcon,
                size: AppDesign.iconSizes.xl,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
