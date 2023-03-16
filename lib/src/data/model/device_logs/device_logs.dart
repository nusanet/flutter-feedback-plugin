class DeviceLogs {
  final String username;
  final String labelUsername;
  final bool isCheckUsername;
  final String appVersion;
  final bool isCheckAppVersion;
  final String platform;
  final bool isCheckPlatform;
  final String osVersion;
  final bool isCheckOsVersion;
  final String brand;
  final bool isCheckBrand;

  DeviceLogs({
    required this.username,
    required this.labelUsername,
    required this.isCheckUsername,
    required this.appVersion,
    required this.isCheckAppVersion,
    required this.platform,
    required this.isCheckPlatform,
    required this.osVersion,
    required this.isCheckOsVersion,
    required this.brand,
    required this.isCheckBrand,
  });

  @override
  String toString() {
    return 'DeviceLogs{username: $username, labelUsername: $labelUsername, isCheckUsername: $isCheckUsername, '
        'appVersion: $appVersion, isCheckAppVersion: $isCheckAppVersion, platform: $platform, '
        'isCheckPlatform: $isCheckPlatform, osVersion: $osVersion, isCheckOsVersion: $isCheckOsVersion, '
        'brand: $brand, isCheckBrand: $isCheckBrand}';
  }
}
