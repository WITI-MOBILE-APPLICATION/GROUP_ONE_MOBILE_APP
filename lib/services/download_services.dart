// lib/services/download_services.dart
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html; // For web support
import 'package:flutter/foundation.dart' show kIsWeb;

class DownloadServices {
  final Dio _dio = Dio();

  Future<void> downloadMovie(
      String movieId, String title, String url, String thumbnailUrl) async {
    try {
      if (kIsWeb) {
        // Handle download for web platform
        print('Starting download for $title (ID: $movieId) on web');
        final response = await _dio.get(
          url,
          options: Options(responseType: ResponseType.bytes),
        );
        final blob = html.Blob([response.data]);
        final downloadUrl = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: downloadUrl)
          ..setAttribute('download', '$title.jpg')
          ..click();
        html.Url.revokeObjectUrl(downloadUrl);
        print('Download initiated for $title on web');

        // Save the download info to SharedPreferences even on the web
        await saveToDownloadsDB(movieId, title, url, thumbnailUrl);
      } else {
        // Handle download for non-web platforms (mobile/desktop)
        print('Starting download for $title (ID: $movieId) from $url');
        final appDir = await getApplicationDocumentsDirectory();
        String fileExtension =
            url.endsWith('.jpg') || url.endsWith('.jpeg') ? '.jpg' : '.mp4';
        final filePath = '${appDir.path}/$movieId$fileExtension';

        if (await File(filePath).exists()) {
          print('File already downloaded at $filePath');
          return;
        }

        await _dio.download(
          url,
          filePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              print(
                  'Download progress: ${(received / total * 100).toStringAsFixed(0)}%');
            }
          },
          options: Options(
            responseType: ResponseType.bytes,
          ),
        );

        print('Download completed, saving to DB');
        await saveToDownloadsDB(movieId, title, filePath, thumbnailUrl);
      }
    } catch (e) {
      print('Error downloading file: $e');
      throw Exception('Download failed: $e');
    }
  }

  Future<void> saveToDownloadsDB(String movieId, String title, String filePath,
      String thumbnailUrl) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> downloadsJson = prefs.getStringList('downloads') ?? [];
      List<Map<String, dynamic>> downloads = downloadsJson
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList();

      downloads.add({
        'id': movieId,
        'title': title,
        'path':
            filePath, // On web, this will be the URL; on non-web, this will be the file path
        'thumbnail': thumbnailUrl,
        'downloadDate': DateTime.now().toIso8601String(),
      });

      downloadsJson = downloads.map((item) => jsonEncode(item)).toList();
      await prefs.setStringList('downloads', downloadsJson);
      print('Saved to DB: $title at $filePath');
    } catch (e) {
      print('Error saving download info: $e');
      throw Exception('Failed to save download info: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getDownloadedMovies() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> downloadsJson = prefs.getStringList('downloads') ?? [];
      return downloadsJson
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error retrieving downloads: $e');
      return [];
    }
  }

  Future<bool> deleteDownloadedMovie(String movieId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> downloadsJson = prefs.getStringList('downloads') ?? [];
      List<Map<String, dynamic>> downloads = downloadsJson
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList();

      int index = downloads.indexWhere((movie) => movie['id'] == movieId);
      if (index == -1) return false;

      if (!kIsWeb) {
        // Only delete the file on non-web platforms
        String filePath = downloads[index]['path'];
        final file = File(filePath);
        if (await file.exists()) {
          await file.delete();
        }
      }

      downloads.removeAt(index);
      downloadsJson = downloads.map((item) => jsonEncode(item)).toList();
      await prefs.setStringList('downloads', downloadsJson);

      return true;
    } catch (e) {
      print('Error deleting downloaded movie: $e');
      return false;
    }
  }

  downloadThumbnail(String string, movie, String s) {}
}
