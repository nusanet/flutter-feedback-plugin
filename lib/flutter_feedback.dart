import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_native_screenshot/flutter_native_screenshot.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'src/data/enum/status.dart';
import 'src/data/model/status_screenshot/status_screenshot.dart';

export 'src/data/enum/status.dart';
export 'src/data/model/device_logs/device_logs.dart';
export 'src/page/form_feedback/flutter_feedback_plugin_page.dart';

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
    if (Platform.isIOS) {
      final permissionStorage = Permission.storage;
      final permissionPhotos = Permission.photos;
      final permissionResult =
          await [permissionStorage, permissionPhotos].request();
      final resultPermissionStorage = permissionResult[permissionStorage];
      final resultPermissionPhotos = permissionResult[permissionPhotos];
      if (resultPermissionStorage == PermissionStatus.granted &&
          resultPermissionPhotos == PermissionStatus.granted) {
        return _doTakeScreenshot(quality);
      }

      switch (resultPermissionStorage) {
        case PermissionStatus.denied:
          return StatusScreenshot(Status.denied);
        case PermissionStatus.granted:
        case PermissionStatus.limited:
          break;
        case PermissionStatus.restricted:
          return StatusScreenshot(Status.restricted);
        case PermissionStatus.permanentlyDenied:
          return StatusScreenshot(Status.permanentlyDenied);
        default:
          return StatusScreenshot(Status.unknown);
      }

      switch (resultPermissionPhotos) {
        case PermissionStatus.denied:
          return StatusScreenshot(Status.denied);
        case PermissionStatus.granted:
        case PermissionStatus.limited:
          return _doTakeScreenshot(quality);
        case PermissionStatus.restricted:
          return StatusScreenshot(Status.restricted);
        case PermissionStatus.permanentlyDenied:
          return StatusScreenshot(Status.permanentlyDenied);
        default:
          return StatusScreenshot(Status.unknown);
      }
    } else if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final osVersion = androidInfo.version.sdkInt;
      if (osVersion != null && osVersion >= 33) {
        // khusus Android 13 (API 33) menggunakan permission photos
        final resultPermissionPhotos = await Permission.photos.request();
        if (resultPermissionPhotos == PermissionStatus.granted) {
          return _doTakeScreenshot(quality);
        }

        switch (resultPermissionPhotos) {
          case PermissionStatus.denied:
            return StatusScreenshot(Status.denied);
          case PermissionStatus.granted:
          case PermissionStatus.limited:
            /* Nothing to do in here */
            break;
          case PermissionStatus.restricted:
            return StatusScreenshot(Status.restricted);
          case PermissionStatus.permanentlyDenied:
            return StatusScreenshot(Status.permanentlyDenied);
          default:
            return StatusScreenshot(Status.unknown);
        }
      } else {
        final resultPermissionStorage = await Permission.storage.request();
        if (resultPermissionStorage == PermissionStatus.granted) {
          return _doTakeScreenshot(quality);
        }

        switch (resultPermissionStorage) {
          case PermissionStatus.denied:
            return StatusScreenshot(Status.denied);
          case PermissionStatus.granted:
          case PermissionStatus.limited:
            /* Nothing to do in here */
            break;
          case PermissionStatus.restricted:
            return StatusScreenshot(Status.restricted);
          case PermissionStatus.permanentlyDenied:
            return StatusScreenshot(Status.permanentlyDenied);
          default:
            return StatusScreenshot(Status.unknown);
        }
      }
    }
    return StatusScreenshot(Status.unknown);
  }

  /// Function ini berfungsi untuk mengambil screenshot dari layar yang sedang aktif.
  ///
  /// Return [StatusScreenshot].
  /// Jika berhasil maka [StatusScreenshot.status] akan bernilai [Status.success].
  /// Dan [StatusScreenshot.path] akan berisi nilai lokasi file gambar screenshot.
  Future<StatusScreenshot?> _doTakeScreenshot(int quality) async {
    try {
      final fileScreenshot = await FlutterNativeScreenshot.takeScreenshot();
      if (fileScreenshot == null) {
        return StatusScreenshot(Status.fileNotFound);
      }
      final tempDirectory = await getTemporaryDirectory();
      final targetPath = path.join(tempDirectory.path, '${DateTime.now()}.jpg');
      final fileScreenshotCompress =
          await FlutterImageCompress.compressAndGetFile(
        fileScreenshot,
        targetPath,
        quality: quality,
      );
      return StatusScreenshot(Status.success,
          path: fileScreenshotCompress?.path);
    } on PlatformException catch (error) {
      throw error;
    }
  }
}
