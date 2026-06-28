// coverage:ignore-file
// Platform glue over receive_sharing_intent; no unit-testable logic.
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/injectable_environments.dart';

/// {@template share_ingest_service}
/// Bridges the OS "Log meal" share target into the app. Exposes the photos a
/// cold-start share launched with, plus a stream of photos shared while the app
/// is already running. Both are normalized to [MealPhoto]s ready for the AI
/// estimate.
/// {@endtemplate}
@singleton
@mobile
class ShareIngestService {
  /// Drains the media the app was cold-started with, then clears it so a later
  /// relaunch does not replay the same share. Empty when not launched from a
  /// share.
  Future<List<MealPhoto>> takeInitialPhotos() async {
    final media = await ReceiveSharingIntent.instance.getInitialMedia();
    await ReceiveSharingIntent.instance.reset();
    return _toPhotos(media);
  }

  /// Photos shared while the app is already running.
  Stream<List<MealPhoto>> get photoStream =>
      ReceiveSharingIntent.instance.getMediaStream().map(_toPhotos);

  List<MealPhoto> _toPhotos(List<SharedMediaFile> media) {
    return [
      for (final sharedMediaFile in media)
        if (sharedMediaFile.type == SharedMediaType.image)
          MealPhoto(
            bytes: File(sharedMediaFile.path).readAsBytesSync(),
            mediaType: _mediaTypeFor(sharedMediaFile),
          ),
    ];
  }

  String _mediaTypeFor(SharedMediaFile sharedMediaFile) {
    if (sharedMediaFile.mimeType case final String mimeType
        when mimeType.isNotEmpty) {
      return mimeType;
    }
    final lower = sharedMediaFile.path.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.gif')) return 'image/gif';
    return 'image/jpeg';
  }
}
