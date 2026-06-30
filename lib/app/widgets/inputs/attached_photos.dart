import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template attached_photos}
/// A horizontal strip of thumbnails for the photos attached to the next AI
/// estimate, each with a remove button. Shown once at least one photo has been
/// added, so the user can see what will be sent before pressing Estimate.
/// {@endtemplate}
class AttachedPhotos extends StatelessWidget {
  /// {@macro attached_photos}
  const AttachedPhotos({
    required this.photos,
    required this.onRemove,
    super.key,
  });

  final List<MealPhoto> photos;

  /// Removes the photo at the given index, or null while an estimate runs.
  final ValueChanged<int>? onRemove;

  @override
  Widget build(BuildContext context) {
    const thumbnailSize = 64.0;
    return SizedBox(
      height: thumbnailSize,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: photos.length,
        separatorBuilder: (context, index) =>
            SizedBox(width: AppDesign.spacing.sm),
        itemBuilder: (context, index) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppDesign.spacing.sm),
                child: Image.memory(
                  photos[index].bytes,
                  width: thumbnailSize,
                  height: thumbnailSize,
                  fit: BoxFit.cover,
                ),
              ),
              if (onRemove != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => onRemove!(index),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(
                          AppDesign.spacing.sm,
                        ),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
