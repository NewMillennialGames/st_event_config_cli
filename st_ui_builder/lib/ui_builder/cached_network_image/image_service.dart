import 'dart:async';
import 'dart:io';
import 'package:st_ui_builder/ui_builder/cached_network_image/image_cache_manager.dart';
import 'package:st_ui_builder/ui_builder/cached_network_image/image_downloader.dart';

bool _hasInitialized = false;

class ImageService {
  late final ImageCacheManager _cacheManager;
  late final ImageDownloader _downloader;

  ImageService() {
    _cacheManager = ImageCacheManager();
    _downloader = ImageDownloader();
    if (!_hasInitialized) {
      unawaited(_cacheManager.deleteExpiredEntries(const Duration(days: 7)));
    }

    _hasInitialized = true;
  }

  Future<File?> getImage({
    required String url,
    int retries = 3,
  }) async {
    try {
      final fileName = _downloader.getFileName(url);

      File? image = await _cacheManager.getFile(fileName: fileName);

      if (image != null) return image;

      bool downloaded = false;
      int tryCount = 0;

      while (!downloaded && tryCount != retries) {
        image = await _downloader.downloadImage(url: url);
        if (image == null) {
          tryCount++;
        } else {
          await _cacheManager.save(fileName);
          downloaded = true;
        }
      }
      return image;
    } catch (e) {
      // print("LUCKY: ImageService getImage -> $e");
      return null;
    }
  }
}
