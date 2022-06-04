import 'dart:io';

import 'package:flutter/material.dart';

/// Halaman ini berfungsi untuk menampilkan gambar
class FlutterFeedbackPreviewImagePage extends StatefulWidget {
  /// Path local image yang akan ditampilkan
  final String? pathImage;

  FlutterFeedbackPreviewImagePage(this.pathImage);

  @override
  _FlutterFeedbackPreviewImagePageState createState() =>
      _FlutterFeedbackPreviewImagePageState();
}

class _FlutterFeedbackPreviewImagePageState
    extends State<FlutterFeedbackPreviewImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Image.file(
            File(widget.pathImage ?? ''),
            fit: BoxFit.contain,
            errorBuilder: (context, error, stacktrace) {
              return Image.asset(
                'assets/image_general_placeholder.jpg',
                fit: BoxFit.cover,
              );
            },
          ),
        ),
      ),
    );
  }
}
