// coverage:ignore-file
// Thin image_picker platform glue: capturing a photo drives the picker plugin's
// platform channel, which can't be exercised in a unit test.

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_usual/app/app.dart';

/// Asks the user to pick a camera or photo-library source, lets them snap or
/// choose one or more photos, and returns their bytes and MIME types. Returns
/// [] if they cancel either step. Camera returns one photo; library supports
/// multi-select. Images are downscaled on capture to keep upload size and token
/// cost down.
Future<List<MealPhoto>> pickMealPhotos(BuildContext context) async {
  final source = await showDialog<ImageSource>(
    context: context,
    builder: (context) => SimpleDialog(
      title: const Text('Photo source'),
      children: [
        SimpleDialogOption(
          onPressed: () => Navigator.pop(context, ImageSource.camera),
          child: const Text('Camera'),
        ),
        SimpleDialogOption(
          onPressed: () => Navigator.pop(context, ImageSource.gallery),
          child: const Text('Photo library'),
        ),
      ],
    ),
  );
  if (source == null) return const [];

  final picker = ImagePicker();
  final List<XFile> picked;
  if (source == ImageSource.camera) {
    final photo = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1568,
      maxHeight: 1568,
      imageQuality: 85,
    );
    picked = photo == null ? const [] : [photo];
  } else {
    picked = await picker.pickMultiImage(
      maxWidth: 1568,
      maxHeight: 1568,
      imageQuality: 85,
    );
  }

  return [
    for (final file in picked)
      MealPhoto(bytes: await file.readAsBytes(), mediaType: _imageMediaType(file)),
  ];
}

/// Resolves an [XFile]'s MIME type to one Claude accepts, defaulting to
/// `image/jpeg` when the picker reports nothing usable.
String _imageMediaType(XFile file) {
  final reportedMimeType = file.mimeType;
  if (reportedMimeType != null && reportedMimeType.startsWith('image/')) {
    return reportedMimeType;
  }

  final name = file.name.toLowerCase();
  if (name.endsWith('.png')) return 'image/png';
  if (name.endsWith('.webp')) return 'image/webp';
  if (name.endsWith('.gif')) return 'image/gif';
  return 'image/jpeg';
}
