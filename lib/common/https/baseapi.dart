import 'package:get_storage/get_storage.dart';

class BaseAPI {
  static const String testEnvironmentKey = 'testEnvironment';
  static final GetStorage _storage = GetStorage();

  static String getBaseURL() {
    bool isTestEnvironment = _storage.read(testEnvironmentKey) ?? false;
    return isTestEnvironment
        ? 'http://www.test.kezhitong.com.cn/'
        // : "https://www.wanandroid.com/";
        : 'https://www.znpai.cn/';
  }

  static String getBaseAPIURL() {
    return getBaseURL() + 'api/';
  }

  static String getProtocolURL() {
    return getBaseURL() + 'protocol.html?type=app_service';
  }

  static String getPrivacyURL() {
    return getBaseURL() + 'protocol.html?type=app_private';
  }

  static String getVipServiceURL() {
    return getBaseURL() + 'protocol.html?type=vip_service';
  }
}
