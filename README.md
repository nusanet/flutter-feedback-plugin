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

Untuk platform iOS plugin ini memerlukan permission `NSPhotoLibraryUsageDescription`. Oleha karena itu, kamu perlu tambahkan permission tersebut didalam file **Info.plist** seperti berikut.

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
