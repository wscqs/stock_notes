// import 'package:carrotcards/common/https/qs_account.dart';
// import 'package:carrotcards/common/https/qs_request.dart';
// import 'package:carrotcards/model/empty_model.dart';
// import 'package:carrotcards/model/user_model.dart';
//
// import '../../model/token_model.dart';
// import '../../utils/qs_cache.dart';
// import '../../utils/qs_devicepackageinfo.dart';
//
// class QsApi {
//   static QsApi? _instance;
//
//   QsApi._();
//
//   static QsApi instance() {
//     return _instance ??= QsApi._();
//   }
//
//   static void refreshToken(
//       {required FinishedCallback<bool> completionHandler}) {
//     Map<String, dynamic> map = {
//       "refresh_token": QsAccount.loginToken,
//     };
//     QsRequest.goSafe(
//         url: "api/customer/get_accesstoken",
//         params: map,
//         decodeType: TokenModel(),
//         completionHandler: (model, error) {
//           if (model != null) {
//             TokenModel tempModel = model as TokenModel;
//             tempModel.refreshToken = QsAccount.loginToken;
//             QsAccount.saveTokenModel(tempModel);
//             completionHandler(true, null);
//           } else {
//             completionHandler(false, null);
//           }
//         });
//   }
//
//   static void register<T>(
//       {required String email,
//       required String password,
//       required String nickname,
//       T? decodeType,
//       required FinishedCallback<T> completionHandler}) {
//     Map<String, dynamic> map = {
//       "email": email,
//       "password": password,
//       "nickname": nickname,
//     };
//     QsRequest.go(
//         url: "api/customer/register",
//         params: map,
//         decodeType: decodeType,
//         showHUD: true,
//         completionHandler: completionHandler);
//   }
//
//   //登录成功判断，model 不为空（model是 tokenModel）
//   static void login<T>(
//       {required String email,
//       required String password,
//       T? decodeType,
//       required FinishedCallback<T> completionHandler}) {
//     Map<String, dynamic> map = {
//       "email": email,
//       "password": password,
//     };
//     if (decodeType == null) {
//       decodeType = TokenModel() as T?;
//     }
//     QsRequest.go(
//         url: "api/customer/pass_login",
//         params: map,
//         decodeType: decodeType,
//         showHUD: true,
//         completionHandler: (model, error) {
//           if (model != null) {
//             QsAccount.saveTokenModel(model as TokenModel);
//             get_userinfo(completionHandler: (model1, error) {
//               var array = QsCache.get("cache_mess");
//               if (array != null) {
//                 customer_save_mes(
//                     cache_mes: array,
//                     completionHandler: (result, error) {
//                       if (error == null) {
//                         QsCache.remove("cache_mess");
//                       }
//                       completionHandler(model, error);
//                     });
//               } else {
//                 completionHandler(model, error);
//               }
//             });
//           }
//           if (error != null) {
//             completionHandler(null, error);
//           }
//         });
//   }
//
//   static void get_userinfo<T>(
//       {T? decodeType, required FinishedCallback<T> completionHandler}) {
//     Map<String, dynamic> map = {};
//     if (decodeType == null) {
//       decodeType = UserModel() as T?;
//     }
//     QsRequest.goSafe(
//         url: "api/customer/get_userinfo",
//         params: map,
//         decodeType: decodeType,
//         cache: CachePolicy.ReturnCache_DidLoad,
//         // showHUD: true,
//         completionHandler: (model, error) {
//           if (model != null) {
//             UserModel? userModel = model as UserModel;
//             if (userModel != null) {
//               QsAccount.saveUserModel(userModel!);
//             }
//           }
//           completionHandler(model, error);
//         });
//   }
//
//   static void forget_password<T>(
//       {required String email,
//       T? decodeType,
//       required FinishedCallback<T> completionHandler}) {
//     Map<String, dynamic> map = {
//       "email": email,
//     };
//     if (decodeType == null) {
//       decodeType = EmptyModel() as T?;
//     }
//     QsRequest.go(
//         url: "api/customer/forget_password",
//         params: map,
//         decodeType: decodeType,
//         showHUD: true,
//         completionHandler: completionHandler);
//   }
//
//   static void update_password<T>(
//       {required String password,
//       required String new_password,
//       required String confirm_password,
//       T? decodeType,
//       required FinishedCallback<T> completionHandler}) {
//     Map<String, dynamic> map = {
//       "password": password,
//       "confirm_password": confirm_password,
//       "new_password": new_password,
//     };
//     if (decodeType == null) {
//       decodeType = EmptyModel() as T?;
//     }
//     QsRequest.goSafe(
//         url: "api/customer/update_password",
//         params: map,
//         decodeType: decodeType,
//         showHUD: true,
//         completionHandler: completionHandler);
//   }
//
//   static void update_nickname<T>(
//       {required String nickname,
//       T? decodeType,
//       required FinishedCallback<T> completionHandler}) {
//     Map<String, dynamic> map = {
//       "nickname": nickname,
//     };
//     if (decodeType == null) {
//       decodeType = EmptyModel() as T?;
//     }
//     QsRequest.goSafe(
//         url: "api/customer/update_nickname",
//         params: map,
//         decodeType: decodeType,
//         showHUD: true,
//         completionHandler: completionHandler);
//   }
//
//   static void customer_save_mes<T>(
//       {required List<dynamic> cache_mes,
//       T? decodeType,
//       required FinishedCallback<T> completionHandler}) {
//     Map<String, dynamic> map = {
//       "cache_mes": cache_mes.join(","),
//     };
//     if (decodeType == null) {
//       decodeType = EmptyModel() as T?;
//     }
//     QsRequest.goSafe(
//         url: "api/customer/save_mes",
//         params: map,
//         decodeType: decodeType,
//         showHUD: true,
//         completionHandler: completionHandler);
//   }
//
//   //占卜
//   static void reading_check<T>(
//       {T? decodeType, required FinishedCallback<T> completionHandler}) {
//     Map<String, dynamic> map = {};
//     if (decodeType == null) {
//       decodeType = EmptyModel() as T?;
//     }
//     QsRequest.goSafe(
//         url: "api/customer/reading_check",
//         params: map,
//         decodeType: decodeType,
//         showHUD: true,
//         completionHandler: completionHandler);
//   }
//
//   static void get_chat_messagelist<T>(
//       {T? decodeType, required FinishedCallback<T> completionHandler}) {
//     Map<String, dynamic> map = {
//       "business": "home",
//     };
//     if (decodeType == null) {
//       decodeType = EmptyModel() as T?;
//     }
//     QsRequest.goSafe(
//         url: "api/customer/get_chat_messagelist",
//         params: map,
//         cache: CachePolicy.ReturnCache_DidLoad,
//         decodeType: decodeType,
//         // showHUD: true,
//         completionHandler: completionHandler);
//   }
//
//   static void get_chat_message<T>(
//       {required String message_id,
//       T? decodeType,
//       required FinishedCallback<T> completionHandler}) {
//     Map<String, dynamic> map = {
//       "message_id": message_id,
//     };
//     if (decodeType == null) {
//       decodeType = EmptyModel() as T?;
//     }
//     QsRequest.goSafe(
//         url: "api/customer/get_chat_message",
//         params: map,
//         cache: CachePolicy.ReturnCache_DidLoad,
//         decodeType: decodeType,
//         showHUD: true,
//         completionHandler: completionHandler);
//   }
//
//   static void col_chatgpt_message<T>(
//       {required String message_id,
//       required String status,
//       T? decodeType,
//       required FinishedCallback<T> completionHandler}) {
//     Map<String, dynamic> map = {
//       "message_id": message_id,
//       "status": status,
//     };
//     if (decodeType == null) {
//       decodeType = EmptyModel() as T?;
//     }
//     QsRequest.goSafe(
//         url: "api/customer/col_chatgpt_message",
//         params: map,
//         decodeType: decodeType,
//         // showHUD: true,
//         completionHandler: completionHandler);
//   }
//
//   static void del_chatgpt_message<T>(
//       {required String message_id,
//       T? decodeType,
//       required FinishedCallback<T> completionHandler}) {
//     Map<String, dynamic> map = {
//       "message_id": message_id,
//     };
//     if (decodeType == null) {
//       decodeType = EmptyModel() as T?;
//     }
//     QsRequest.goSafe(
//         url: "api/customer/del_chatgpt_message",
//         params: map,
//         decodeType: decodeType,
//         showHUD: true,
//         completionHandler: completionHandler);
//   }
//
//   static void testvip_edit<T>(
//       {required String is_vip,
//       T? decodeType,
//       required FinishedCallback<T> completionHandler}) {
//     Map<String, dynamic> map = {
//       "is_vip": is_vip,
//     };
//     if (decodeType == null) {
//       decodeType = EmptyModel() as T?;
//     }
//     QsRequest.goSafe(
//         url: "api/customer/vip_edit",
//         params: map,
//         decodeType: decodeType,
//         showHUD: true,
//         completionHandler: completionHandler);
//   }
//
//   static void verify_purchase<T>(
//       {required String package_name,
//       required String product_id,
//       required String purchase_token,
//       T? decodeType,
//       required FinishedCallback<T> completionHandler}) async {
//     String package_name = await QsDevicePackageInfo.getPackageName();
//     Map<String, dynamic> map = {
//       "package_name": package_name,
//       "product_id": product_id,
//       "purchase_token": purchase_token,
//     };
//     if (decodeType == null) {
//       decodeType = EmptyModel() as T?;
//     }
//     QsRequest.goSafe(
//         url: "api/customer/verify_subscription",
//         params: map,
//         decodeType: decodeType,
//         showHUD: true,
//         completionHandler: completionHandler);
//   }
//
//   // static void register(
//   //     {required String email,
//   //     required String password,
//   //     required String smtp_code}) {
//   //   Map<String, dynamic> map = {
//   //     "email": email,
//   //     "password": password,
//   //     "smtp_code": smtp_code,
//   //   };
//   //   QsRequest.go(
//   //       url: "api/customer/register",
//   //       params: map,
//   //       decodeType: SimpleModel(),
//   //       completionHandler: (model, error) {
//   //         if (model != null) {
//   //           debugPrint("成功返回$model");
//   //         }
//   //         if (error != null) {
//   //           debugPrint("失败了：msg=${error.message}");
//   //         }
//   //       });
//   // }
//
//   // static DioInstance request = DioInstance.instance();
//
//   // Future<TestHomeList> homeList() async {
//   //   // Map<String, dynamic> map = {
//   //   //   "mobile": mobile,
//   //   //   "area_code": "86",
//   //   //   "code": code,
//   //   // };
//   //   Response response = await request.go(
//   //       path: "app/getExpertList", cachePolicy: CachePolicy.ReturnNet_DoCache);
//   //   TestHomeList homeList = TestHomeList.fromJson(response.data);
//   //   print(homeList.toString());
//   //   return homeList;
//   // }
//
//   // static void homeList() {
//   //   QsRequest.go(
//   //       url: "banner/json",
//   //       decodeType: BannerModel(),
//   //       completionHandler: (model, error) {
//   //         if (model != null) {
//   //           debugPrint("成功返回$model");
//   //         }
//   //         if (error != null) {
//   //           debugPrint("失败了：msg=${error.message}");
//   //         }
//   //       });
//   // }
//
//   // static void homeList1<T>(
//   //     {T? decodeType, required FinishedCallback<T> completionHandler}) {
//   //   QsRequest.go(
//   //       url: "banner/json",
//   //       cache: CachePolicy.ReturnCache_DidLoad,
//   //       decodeType: decodeType,
//   //       completionHandler: completionHandler);
//   // }
// }
//
// // import 'package:dio/dio.dart';
// //
// // import 'dio_instance.dart';
// //
// // class QsApi {
// //   static QsApi? _instance;
// //   QsApi._();
// //   static QsApi instance() {
// //     return _instance ??= QsApi._();
// //   }
// //
// //   static DioInstance request = DioInstance.instance();
// //
// //   Future<StatusModel> actionPhoneVerCode(
// //       String mobile, String vcode, String key) async {
// //     Map<String, dynamic> map = {
// //       "mobile": mobile,
// //       "vcode": vcode,
// //       "key": key,
// //       "event": "login"
// //     };
// //     Response response =
// //         await request.get(path: "api/sendPhoneCode", param: map);
// //     return StatusModel.fromJson(response.data);
// //   }
// //
// //   Future<TokenModel> actionLogin(String mobile, String code) async {
// //     Map<String, dynamic> map = {
// //       "mobile": mobile,
// //       "area_code": "86",
// //       "code": code,
// //     };
// //     Response response =
// //         await request.get(path: "login/loginbymobile", param: map);
// //     TokenModel tokenModel = TokenModel.fromJson(response.data);
// //     QsAccount.saveTokenModel(tokenModel);
// //     return tokenModel;
// //   }
// //
// //   Future<TokenModel> actionAccessToken() async {
// //     Response response = await request.goSafe(path: "api/freshaccesstoken");
// //     TokenModel tokenModel = TokenModel.fromJson(response.data);
// //     QsAccount.saveTokenModel(tokenModel);
// //     return tokenModel;
// //   }
// //
// //   Future<UserModel> actionUserGetuserinfo() async {
// //     Map<String, dynamic> map = {
// //       "access_token": QsAccount.tokenModel!.accessToken,
// //     };
// //     Response response =
// //         await request.goSafe(path: "user/getuserinfo", param: map);
// //     UserModel userModel = UserModel.fromJson(response.data);
// //     QsAccount.saveUserModel(userModel);
// //     return userModel;
// //   }
// //
// //   Future<BusinessListModel> actionBusinessList() async {
// //     Map<String, dynamic> map = {"start": "0", "num": "1000"};
// //     Response response = await request.get(path: "business/list", param: map);
// //     BusinessListModel model = BusinessListModel.fromJson(response.data);
// //     return model;
// //   }
// //
// //   Future<ChatListModel> actionChatList() async {
// //     Response response = await request.goSafe(path: "chat/list");
// //     ChatListModel model = ChatListModel.fromJson(response.data);
// //     return model;
// //   }
// //
// //   ///获取首页文章列表
// //   // Future<HomeListData?> homeList(String pageCount) async {
// //   //   Response response =
// //   //       await DioInstance.instance().get(path: "article/list/$pageCount/json");
// //   //   return HomeData.fromJson(response.data).data;
// //   //   // return null;
// //   // }
// // }
