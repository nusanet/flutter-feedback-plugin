import 'status.dart';

class StatusScreenshot {
  final Status status;
  final String? path;

  StatusScreenshot(
    this.status, {
    this.path,
  });

  @override
  String toString() {
    return 'StatusScreenshot{status: $status, path: $path}';
  }
}
