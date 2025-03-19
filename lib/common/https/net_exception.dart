/// A custom exception class.
// const kNetworkDontUse = "当前网络不可用";
// const kServiceDontUse = "服务端出差了，请稍后重试";
const kServiceDontUse =
    "The server is on a business trip. Please try again later.";
const kNetworkDontUse =
    "The current network is unavailable, please check the network settings";

class NetException implements Exception {
  final String? _message;

  String get message => _message ?? 'Request error';

  final int? _code;

  int get code => _code ?? -1;

  NetException([this._message, this._code]);

  factory NetException.netError() {
    return NetException(kNetworkDontUse, 555);
  }

  factory NetException.serError() {
    return NetException(kServiceDontUse, 404);
  }

  @override
  String toString() {
    return "code:$code--message=$message";
  }
}
