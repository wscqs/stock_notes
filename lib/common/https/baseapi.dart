class BaseAPI {
  // static const String testEnvironmentKey = 'testEnvironment';
  // static final GetStorage _storage = GetStorage();

  static String getBaseURL() {
    return 'https://cctest.wlspapp.com/';
    return 'https://cc.wlspapp.com/';
    // bool isTestEnvironment = _storage.read(testEnvironmentKey) ?? false;
    // isTestEnvironment = true;
    // return isTestEnvironment
    //     ? 'https://cctest.wlspapp.com/'
    //     : 'https://cc.wlspapp.com/';
  }

  static String getBaseAPIURL() {
    return getBaseURL() + 'api/';
  }

  static String getDeleteAccount() {
    return getBaseURL() + 'jb.html';
  }

  static String getProtocolURL() {
    // return "https://www.znpai.cn/protocol.html?type=app_service";
    return "https://cc.wlspapp.com/rich_text/article/2.html";
    return getBaseURL() + 'protocol.html?type=app_service';
  }

  static String getPrivacyURL() {
    return "https://cc.wlspapp.com/rich_text/article/3.html";
    return "https://www.znpai.cn/protocol.html?type=app_private";
    // return getBaseURL() + 'protocol.html?type=app_private';
  }

  static String getVipServiceURL() {
    return getBaseURL() + 'protocol.html?type=vip_service';
  }
}
