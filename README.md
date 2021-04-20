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

Untuk platform iOS plugin ini memerlukan permission `NSPhotoLibraryAddUsageDescription`. Oleha karena itu, kamu perlu tambahkan permission tersebut didalam file **Info.plist** seperti berikut.

```plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	...
	<key>NSPhotoLibraryAddUsageDescription</key>
    <string>Take pretty screenshots and save it to the PhotoLibrary.</string>
</dict>
</plist>

```

## Cara Pakai

Untuk menggunakan plugin ini sangatlah mudah. Kamu cukup panggil saja fungsi `takeScreenshot(context)` dan cek nilai return-nya apakah outputnya sukses atau gagal.

```dart
final flutterFeedback = FlutterFeedback();
final result = await flutterFeedback.takeScreenshot(context);
switch (result!.status) {
  case Status.success:
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
![Contoh penggunaan plugin](https://bitbucket.org/CoderJavaX/flutter-feedback-plugin/raw/35c6b39cd60ff477e64e6c1d792a84f8f5cc9987/screenshot/plugin_demo.gif)