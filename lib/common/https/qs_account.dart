import '../../model/comment/token_model.dart';
import '../../model/comment/user_model.dart';
import '../../utils/qs_cache.dart';

class QsAccount {
  static bool get isLogin {
    var isLogin = tokenModel?.token?.isNotEmpty ?? false;
    // UserService.to.isLogin.value = isLogin;
    return isLogin;
  }

  static bool get isLoginWithPushLogin {
    // if (!isLogin) {
    //   Get.toNamed(Routes.LOGIN);
    // }
    return isLogin;
  }

  static bool get vip {
    var vip = isLogin && userInfo != null && ("1" == userInfo!.isVip);
    // UserService.to.isVip.value = vip;
    return vip;
  }

  static String? get accessToken {
    return tokenModel?.token;
  }

  static String? get loginToken {
    return tokenModel?.refreshToken;
  }

  static cleanAccount() {
    // UserService.to.isLogin.value = false;
    QsCache.remove("tokenModel");
    QsCache.remove("userModel");
  }

  static saveTokenModel(TokenModel model) {
    QsCache.set("tokenModel", model.toJson());
  }

  static saveUserModel(UserModel model) {
    // UserService.to.isLogin.value = true;
    // UserService.to.userInfo.value = model;
    QsCache.set("userModel", model.toJson());
  }

  static TokenModel? get tokenModel {
    dynamic map = QsCache.get("tokenModel");
    if (map != null) {
      return TokenModel.fromJson(map!);
    } else {
      return null;
    }
  }

  static UserModel? get userInfo {
    dynamic map = QsCache.get("userModel");
    if (map != null) {
      UserModel? model = UserModel.fromJson(map!);
      // UserService.to.userInfo.value = model;
      return model;
    } else {
      // UserService.to.userInfo.value = UserModel();
      return null;
    }
  }
}
