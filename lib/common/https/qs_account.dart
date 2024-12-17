// import '../../model/token_model.dart';
// import '../../model/user_model.dart';
// import '../../utils/qs_cache.dart';
//
// class QsAccount {
//   static bool get isLogin {
//     return tokenModel?.token?.isNotEmpty ?? false;
//   }
//
//   static String? get accessToken {
//     return tokenModel?.token;
//   }
//
//   static String? get loginToken {
//     return tokenModel?.refreshToken;
//   }
//
//   static bool get vip {
//     return isLogin && userInfo != null && ("1" == userInfo!.is_vip);
//   }
//
//   static cleanAccount() {
//     QsCache.remove("tokenModel");
//     QsCache.remove("userModel");
//   }
//
//   static saveTokenModel(TokenModel model) {
//     QsCache.set("tokenModel", model.toJson());
//   }
//
//   static saveUserModel(UserModel model) {
//     QsCache.set("userModel", model.toJson());
//   }
//
//   static TokenModel? get tokenModel {
//     dynamic map = QsCache.get("tokenModel");
//     if (map != null) {
//       return TokenModel.fromJson(map!);
//     } else {
//       return null;
//     }
//   }
//
//   static UserModel? get userInfo {
//     dynamic map = QsCache.get("userModel");
//     if (map != null) {
//       return UserModel.fromJson(map!);
//     } else {
//       return null;
//     }
//   }
// }
