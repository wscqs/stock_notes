import 'package:connectivity_plus/connectivity_plus.dart';

class QsNetcon {
  /// 判断设备是否连接网络
  static Future<bool> isNetworkAvailable() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return !connectivityResult.contains(ConnectivityResult.none);
  }

  /// 判断设备是否连接移动网络
  static Future<bool> isConnectedToMobile() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult.contains(ConnectivityResult.mobile);
  }

  /// 判断设备是否连接WiFi
  static Future<bool> isConnectedToWiFi() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult.contains(ConnectivityResult.wifi);
  }
}
