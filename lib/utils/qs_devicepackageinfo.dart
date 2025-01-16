import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class QsDevicePackageInfo {
  // 私有构造函数
  QsDevicePackageInfo._();

  // 获取应用名称
  static Future<String> getAppName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.appName;
  }

  // 获取包名
  static Future<String> getPackageName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }

  static Future<String> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static Future<String> getBuildNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }

  static Future<PackageInfo> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }

  static Future<DeviceInfoPlugin> getDeviceInfoPlugin() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    return deviceInfoPlugin;
  }

  // static Future<String> getDeviceIdentifier() async {
  //   String udid = await FlutterUdid.consistentUdid;
  //   return udid;
  // }

  // 获取设备型号
  Future<String?> getDeviceModel() async {
    // BaseDeviceInfo deviceInfo = await getDeviceInfo();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return '${androidInfo.brand} ${androidInfo.model}';
    }
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.utsname.machine;
    }
    return null;
  }
}
