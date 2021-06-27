# Flutter Feedback Plugin

Plugin Flutter yang berfungsi untuk mengambil screenshot dari halaman yang sedang aktif. Plugin ini support untuk platform Android & iOS.

## Setup

### Android

Untuk platform Android plugin ini memerlukan permission `WRITE_EXTERNAL_STORAGE`. Oleh karena itu, kamu perlu tambahkan permission tersebut didalam file **AndroidManifest.xml** seperti berikut.

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="id.net.nusa.plugin.flutter_feedback_example">

    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
	
</manifest>

```

### iOS

Untuk platform iOS plugin ini memerlukan permission `NSPhotoLibraryUsageDescription`. Oleh karena itu, kamu perlu tambahkan permission tersebut didalam file **Info.plist** seperti berikut.

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	...
	<key>NSPhotoLibraryUsageDescription</key>
	<string>Take pretty screenshots and save it to the PhotoLibrary.</string>
	...
</dict>
</plist>

```

Dan jangan lupa enable-kan permission photos didalam `Podfile`.

```
target.build_configurations.each do |config|
      # You can remove unused permissions here
      # for more infomation: https://github.com/BaseflowIT/flutter-permission-handler/blob/master/permission_handler/ios/Classes/PermissionHandlerEnums.h
      # e.g. when you don't need camera permission, just add 'PERMISSION_CAMERA=0'
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
      '$(inherited)',

      ## dart: PermissionGroup.calendar
      'PERMISSION_EVENTS=0',

      ## dart: PermissionGroup.reminders
      'PERMISSION_REMINDERS=0',

      ## dart: PermissionGroup.contacts
      'PERMISSION_CONTACTS=0',

      ## dart: PermissionGroup.camera
      'PERMISSION_CAMERA=0',

      ## dart: PermissionGroup.microphone
      'PERMISSION_MICROPHONE=0',

      ## dart: PermissionGroup.speech
      'PERMISSION_SPEECH_RECOGNIZER=0',

      ## dart: PermissionGroup.photos
      'PERMISSION_PHOTOS=1',

      ## dart: [PermissionGroup.location, PermissionGroup.locationAlways, PermissionGroup.locationWhenInUse]
      'PERMISSION_LOCATION=0',

      ## dart: PermissionGroup.notification
      'PERMISSION_NOTIFICATIONS=0',

      ## dart: PermissionGroup.mediaLibrary
      'PERMISSION_MEDIA_LIBRARY=0',

      ## dart: PermissionGroup.sensors
      'PERMISSION_SENSORS=0',

      ## dart: PermissionGroup.bluetooth
      'PERMISSION_BLUETOOTH=0',

      ## dart: PermissionGroup.appTrackingTransparency
      'PERMISSION_APP_TRACKING_TRANSPARENCY=0',

      ## dart: PermissionGroup.criticalAlerts
      'PERMISSION_CRITICAL_ALERTS=0',
      ]

    end
```

## Cara Pakai

Untuk menggunakan plugin ini sangatlah mudah. Kamu cukup panggil saja fungsi `takeScreenshot(context)` dan cek nilai return-nya apakah outputnya sukses atau gagal.
Contoh lengkapnya bisa kamu lihat di projek example.

```dart
final flutterFeedback = FlutterFeedback();
final result = await flutterFeedback.takeScreenshot(context);
switch (result!.status) {
  case Status.success:
    // Screenshot berhasil disimpan.
    // Ini contoh jika mau mengarahkan ke halaman preview image hasil screenshot-nya.
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return PreviewImagePage(File(result.path!));
        },
      ),
    );
    break;
  case Status.denied:
    _showSnackbBar('Permission denied');
    break;
  case Status.restricted:
    _showSnackbBar('Permission restricted');
    break;
  case Status.permanentlyDenied:
    _showSnackbBar('Permission denied permanently');
    break;
  case Status.fileNotFound:
    _showSnackbBar('File screenshot not found');
    break;
  case Status.unknown:
    _showSnackbBar('Unknown');
    break;
}
```

## Demo
![Contoh penggunaan plugin](https://github.com/CoderJava/flutter-feedback-plugin/blob/master/screenshot/plugin_demo.gif)
