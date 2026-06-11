// coverage:ignore-file

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:injectable/injectable.dart';

/// {@template file_cache_service}
/// A service responsible for managing local file persistence and caching.
/// {@endtemplate}
@singleton
class FileCacheService {
  /// Retrieves a file from the cache or downloads it if it does not exist.
  Future<File> getFile(String url) async {
    return DefaultCacheManager().getSingleFile(url);
  }

  /// Reads the cached file bytes for [url], downloading it first if needed.
  Future<Uint8List> getBytes(String url) async {
    final file = await getFile(url);
    return file.readAsBytes();
  }

  /// Removes a specific file from the local cache.
  Future<void> removeFile(String url) async {
    await DefaultCacheManager().removeFile(url);
  }

  /// Removes all files from local cache.
  Future<void> emptyCache() async {
    await DefaultCacheManager().emptyCache();
  }
}
