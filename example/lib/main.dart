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

  var locale = 'en';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin Flutter Feedback'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
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
                            fileScreenshot: File(result.path!),
                            email: 'kolonel.yudisetiawan@gmail.com',
                            appVersion: '1.0.0',
                            onSubmitFeedback: (listScreenshots, category,
                                description, deviceLogs) async {
                              // jika prosesnya berhasil
                              formFeedbackController.submitFeedback();
                              await Future.delayed(Duration(seconds: 3));
                              formFeedbackController.successFeedback(context);

                              // jika prosesnya gagal bisa pakai ini
                              // formFeedbackController.failureFeedback('gagal submit feedback');
                            },
                            colorPrimary: Colors.blue,
                            colorSecondary: Colors.blue,
                            colorTitleAppBar: Colors.white,
                            colorAppBar: Colors.blue,
                            locale: locale,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio(
                  value: 'en',
                  groupValue: locale,
                  onChanged: (String? value) =>
                      setState(() => locale = value ?? 'en'),
                ),
                Text('English'),
                SizedBox(width: 16),
                Radio(
                  value: 'id',
                  groupValue: locale,
                  onChanged: (String? value) =>
                      setState(() => locale = value ?? 'id'),
                ),
                Text('Indonesia'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackbBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
