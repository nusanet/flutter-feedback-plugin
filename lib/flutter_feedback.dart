import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:native_screenshot/native_screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

import 'src/status.dart';
import 'src/status_screenshot.dart';

export 'src/status.dart';
export 'page/form_feedback/flutter_feedback_plugin_page.dart';

/// Class ini berfungsi untuk membuat fitur feedback dengan cara mengambil screenshot layar.
class FlutterFeedback {
  static const MethodChannel _channel = const MethodChannel('flutter_feedback');

  /// Property ini berfungsi untuk mendapatkan versi OS yang sedang berjalan.
  ///
  /// Return [String] nilai versi OS
  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// Function ini berfungsi untuk melakukan request runtime permission dan
  /// mengambil screenshot dari layar yang sedang aktif.
  ///
  /// Return [StatusScreenshot].
  /// Jika [StatusScreenshot.status] bernilai [Status.success] maka, baca property [StatusScreenshot.path].
  /// Selain itu, maka ada kegagalan maupun error permission.
  Future<StatusScreenshot?> takeScreenshot(
    BuildContext context, {
    int quality = 95,
  }) async {
    final permissionStorage = Permission.storage;
    var permissionStorageStatus = await permissionStorage.request();
    switch (permissionStorageStatus) {
      case PermissionStatus.denied:
        return StatusScreenshot(Status.denied);
      case PermissionStatus.granted:
        return _doTakeScreenshot(quality);
      case PermissionStatus.restricted:
        return StatusScreenshot(Status.restricted);
      case PermissionStatus.limited:
        return _doTakeScreenshot(quality);
      case PermissionStatus.permanentlyDenied:
        return StatusScreenshot(Status.permanentlyDenied);
      default:
        return StatusScreenshot(Status.unknown);
    }
  }

  /// Function ini berfungsi untuk mengambil screenshot dari layar yang sedang aktif.
  ///
  /// Return [StatusScreenshot].
  /// Jika berhasil maka [StatusScreenshot.status] akan bernilai [Status.success].
  /// Dan [StatusScreenshot.path] akan berisi nilai lokasi file gambar screenshot.
  Future<StatusScreenshot?> _doTakeScreenshot(int quality) async {
    try {
      final fileScreenshot = await NativeScreenshot.takeScreenshot();
      if (fileScreenshot == null) {
        return StatusScreenshot(Status.fileNotFound);
      }
      final tempDirectory = await getTemporaryDirectory();
      final targetPath = path.join(tempDirectory.path, '${DateTime.now()}.jpg');
      final fileScreenshotCompress = await FlutterImageCompress.compressAndGetFile(
        fileScreenshot,
        targetPath,
        quality: quality,
      );
      return StatusScreenshot(Status.success, path: fileScreenshotCompress?.path);
    } on PlatformException catch (error) {
      throw error;
    }
  }
}
