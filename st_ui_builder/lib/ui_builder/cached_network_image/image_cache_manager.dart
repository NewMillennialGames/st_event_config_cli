import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageCacheManager {
  static const _key = "image_cache_key";
  static const String cacheDirectory = "cachedMedia";

  SharedPreferences? _cache;

  Future<void> _initCache() async {
    _cache ??= await SharedPreferences.getInstance();
  }

  Future<void> delete(String fileName) async {
    try {
      await _initCache();

      final dir = await getApplicationDocumentsDirectory();
      String fileDirectory =
          "${dir.path}/${ImageCacheManager.cacheDirectory}/$fileName";
      final file = File(fileDirectory);
      if (await file.exists()) {
        await file.delete();
      }
      await _cache?.remove(_key);
    } catch (e) {
      // print("LUCKY: ImageCacheManager delete -> $e");
    }
  }

  Future<void> deleteExpiredEntries(Duration maxDuration) async {
    try {
      final entries = await getEntries();
      List<String> filesToDelete = [];

      final currentTimeStamp = DateTime.now();

      for (var key in entries.keys) {
        final cachePeriod = DateTime.parse(entries[key]!);
        if (currentTimeStamp.difference(cachePeriod) >= maxDuration) {
          filesToDelete.add(key);
        }
      }

      // print(
      //   "LUCKY: ImageCacheManager found ${filesToDelete.length} entries to delete",
      // );

      await Future.forEach<String>(
        filesToDelete,
        (fileName) async => await delete(fileName),
      ).onError((error, stackTrace) {
        //
      });
    } catch (e) {
      // print("LUCKY: ImageCacheManager deleteExpiredEntries -> $e");
    }
  }

  Future<void> save(String fileName) async {
    try {
      await _initCache();
      final entries = await getEntries();
      entries.addAll({fileName: DateTime.now().toIso8601String()});
      await _cache?.setString(_key, jsonEncode(entries));
    } catch (e) {
      // print("LUCKY: ImageCacheManager save -> $e");
    }
  }

  Future<Map<String, String>> getEntries() async {
    await _initCache();
    final entries = _cache?.getString(_key) ?? '{}';
    return Map<String, String>.from(jsonDecode(entries));
  }

  Future<File?> getFile({
    required String fileName,
    String directory = ImageCacheManager.cacheDirectory,
  }) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final fileDirectory = "${dir.path}/$directory/$fileName";

      final file = File(fileDirectory);
      if (await file.exists()) return file;
    } catch (e) {
      // print("LUCKY: ImageCacheManager getFile -> $e");
    }
  }

  Future<void> clearCache() async {
    await deleteExpiredEntries(const Duration(seconds: 0));
  }
}
