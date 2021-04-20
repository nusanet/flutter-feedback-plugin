import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_feedback/flutter_feedback.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin Flutter Feedback'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
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
          },
          child: Text('Take Screenshot'),
        ),
      ),
    );
  }

  void _showSnackbBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}


class PreviewImagePage extends StatelessWidget {
  final File file;

  PreviewImagePage(this.file);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plugin Flutter Feedback')),
      body: Center(
        child: Image.file(
          file,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
