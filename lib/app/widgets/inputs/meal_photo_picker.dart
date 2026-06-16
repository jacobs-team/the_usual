import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// A photo chosen for AI meal estimation: its raw `bytes` and the `mediaType`
/// MIME string Claude needs (`image/jpeg`, `image/png`, `image/gif`, or
/// `image/webp`). One-off data handed straight to the estimator, so it needs no
/// model of its own.
typedef MealPhoto = ({Uint8List bytes, String mediaType});

/// Asks the user to pick a camera or photo-library source, lets them snap or
/// choose a photo, and returns its bytes and MIME type. Returns null if they
/// cancel either step. The image is downscaled on capture to keep the upload
/// size and token cost down.
Future<MealPhoto?> pickMealPhoto(BuildContext context) async {
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
  if (source == null) return null;

  final picked = await ImagePicker().pickImage(
    source: source,
    maxWidth: 1568,
    maxHeight: 1568,
    imageQuality: 85,
  );
  if (picked == null) return null;

  final bytes = await picked.readAsBytes();
  return (bytes: bytes, mediaType: _imageMediaType(picked));
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
