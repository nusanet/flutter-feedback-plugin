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
  final formFeedbackController = FormFeedbackController();

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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return FlutterFeedbackPluginPage(
                        File(result.path!),
                        (listScreenshots, category) async {
                          formFeedbackController.submitFeedback();
                          await Future.delayed(Duration(seconds: 3));
                          formFeedbackController.successFeedback();

                          // jika prosesnya gagal bisa pakai ini
                          // formFeedbackController.failureFeedback('gagal submit feedback');
                        },
                        colorTitleAppBar: Colors.white,
                      );
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