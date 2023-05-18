import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:st_ui_builder/ui_builder/cached_network_image/image_cache_manager.dart';

class ImageDownloader {
  String getFileName(String url) {
    try {
      return url.split('/').last.toLowerCase();
    } catch (e) {
      return "";
    }
  }

  Future<File?> downloadImage({
    required String url,
    String directory = ImageCacheManager.cacheDirectory,
  }) async {
    try {
      final fileName = getFileName(url);
      if (fileName.isEmpty) return null;

      final response = await http.get(Uri.parse(url));
      final fileBytes = response.bodyBytes;

      final dir = await getApplicationDocumentsDirectory();
      String fileDirectory = "${dir.path}/$directory";

      await Directory(fileDirectory).create(recursive: true);

      File downloadedFile = File("$fileDirectory/$fileName");

      if (await downloadedFile.exists()) return downloadedFile;

      await downloadedFile.writeAsBytes(fileBytes);

      return downloadedFile;
    } catch (e) {
      // print("LUCKY: ImageDownloader downloadImage -> $e");
      return null;
    }
  }
}
