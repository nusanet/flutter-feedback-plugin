class DeviceLogs {
  final String email;
  final bool isCheckEmail;
  final String appVersion;
  final bool isCheckAppVersion;
  final String platform;
  final bool isCheckPlatform;
  final String osVersion;
  final bool isCheckOsVersion;
  final String brand;
  final bool isCheckBrand;

  DeviceLogs({
    required this.email,
    required this.isCheckEmail,
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
    return 'DeviceLogs{email: $email, isCheckEmail: $isCheckEmail, appVersion: $appVersion, '
        'isCheckAppVersion: $isCheckAppVersion, platform: $platform, isCheckPlatform: $isCheckPlatform, '
        'osVersion: $osVersion, isCheckOsVersion: $isCheckOsVersion, brand: $brand, isCheckBrand: $isCheckBrand}';
  }
}
