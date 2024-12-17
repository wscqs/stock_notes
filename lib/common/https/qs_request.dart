// import 'dart:convert';
//
// import 'package:carrotcards/common/https/qs_account.dart';
// import 'package:carrotcards/common/https/qs_api.dart';
// import 'package:carrotcards/utils/qs_cache.dart';
// import 'package:carrotcards/utils/qs_hud.dart';
// import 'package:carrotcards/utils/qs_netcon.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
//
// import 'base_net_model.dart';
// import 'net_exception.dart';
// import 'net_options.dart';
//
// export 'package:dio/io.dart' show IOHttpClientAdapter;
//
// /// 上传的data 真实格式
// enum DataType { mp3, img }
//
// /// 缓存策略
// enum CachePolicy {
//   Default, // 不提供缓存
//   ReturnCache_DidLoad, // 有缓存则返回缓存且都加载网络
//   // ReturnCache_ElseLoad, // 有缓存则返回缓存，不加载网络
//   // ReturnCache_DontLoad, // 有缓存则返回缓存且不加载网络
//   // ReturnCacheOrNil_DidLoad, // 有缓存返回缓存，没有缓存返回空且都加载网络
//   // Reload_IgnoringLocalCache, // 忽略缓存并加载网络
//   // ReturnCache_WhenLoadFail // 加载失败返回缓存
// }
//
// typedef FinishedCallback<T> = Function(T? result, NetException? error);
//
// class QsRequest {
//   //要先初始化
//   static void initDio() {
//     NetOptions.instance
//         // header
//         // .addHeaders({"aaa": '111'})
//         // .setBaseUrl("https://www.wanandroid.com/")
//         // .setBaseUrl("http://3.21.234.60:1001/")
//         // .setBaseUrl("https://testtlp.wlspapp.com/")
//         .setBaseUrl("https://tlp.wlspapp.com/")
//         // .addInterceptor(PrintLogInterceptor())
//         // 代理/https
//         // .setHttpClientAdapter(IOHttpClientAdapter()
//         //   ..onHttpClientCreate = (client) {
//         //     client.findProxy = (uri) {
//         //       return 'PROXY 192.168.31.182:8888';
//         //     };
//         //     client.badCertificateCallback =
//         //         (X509Certificate cert, String host, int port) => true;
//         //     return client;
//         //   })
//         // cookie
//         // .addInterceptor(CookieManager(CookieJar()))
//         // dio_http_cache
//         // .addInterceptor(DioCacheManager(CacheConfig(
//         //   baseUrl: "https://www.wanandroid.com/",
//         // )).interceptor)
//         // dio_cache_interceptor
//         // .addInterceptor(DioCacheInterceptor(
//         //     options: CacheOptions(
//         //   store: MemCacheStore(),
//         //   policy: CachePolicy.forceCache,
//         //   hitCacheOnErrorExcept: [401, 403],
//         //   maxStale: const Duration(days: 7),
//         //   priority: CachePriority.normal,
//         //   cipher: null,
//         //   keyBuilder: CacheOptions.defaultCacheKeyBuilder,
//         //   allowPostMethod: false,
//         // )))
//         //  全局解析器
//         // .setHttpDecoder(MyHttpDecoder.getInstance())
//         //  超时时间
//         .setConnectTimeout(const Duration(milliseconds: 3000))
//         // 允许打印log，默认未 true
//         .enableLogger(false)
//         .create();
//   }
//
//   /// 通用请求方法
//   static void go<T>({
//     required String url,
//     String method = 'GET',
//     Map<String, dynamic>? params,
//     T? decodeType,
//     CachePolicy cache = CachePolicy.Default,
//     bool showHUD = false,
//     bool showErrorToast = true,
//     required FinishedCallback<T> completionHandler,
//   }) async {
//     final fullUrl = getFullUrl(url, params);
//     debugPrint(fullUrl);
//     // print(fullUrl);
//     bool isNeedSer = false;
//     switch (cache) {
//       case CachePolicy.Default:
//         isNeedSer = true;
//         break;
//       case CachePolicy.ReturnCache_DidLoad:
//         final cacheData = await QsCache.get(fullUrl);
//         if (cacheData != null) {
//           final object = _transformBean<T>(cacheData, decodeType, true);
//           completionHandler(object, null);
//           isNeedSer = true;
//         } else {
//           isNeedSer = true;
//         }
//         break;
//       // case CachePolicy.ReturnCache_ElseLoad:
//       //   final cacheData = await QsCache.get(fullUrl);
//       //   if (cacheData != null) {
//       //     final object = _transformBean<T>(cacheData, decodeType);
//       //     completionHandler(object, null);
//       //   } else {
//       //     isNeedSer = true;
//       //   }
//       //   break;
//       // case CachePolicy.ReturnCache_DontLoad:
//       //   final cacheData = await QsCache.get(fullUrl);
//       //   if (cacheData != null) {
//       //     final object = _transformBean<T>(cacheData, decodeType);
//       //     completionHandler(object, null);
//       //   }
//       //   break;
//       //
//       // case CachePolicy.ReturnCacheOrNil_DidLoad:
//       //   final cacheData = await QsCache.get(fullUrl);
//       //   completionHandler(
//       //       cacheData != null ? _transformBean<T>(cacheData, decodeType) : null,
//       //       null);
//       //   isNeedSer = true;
//       //   break;
//       // case CachePolicy.Reload_IgnoringLocalCache:
//       //   isNeedSer = true;
//       //   break;
//     }
//
//     if (isNeedSer) {
//       _request(
//         url: url,
//         method: method,
//         params: params,
//         decodeType: decodeType,
//         cache: cache,
//         showHUD: showHUD,
//         showErrorToast: showErrorToast,
//         completionHandler: completionHandler,
//       );
//     }
//   }
//
//   /// 安全请求（带token）
//   static Future<void> goSafe<T>({
//     required String url,
//     String method = 'GET',
//     Map<String, dynamic>? params,
//     T? decodeType,
//     CachePolicy cache = CachePolicy.Default,
//     bool showHUD = false,
//     bool showErrorToast = true,
//     required FinishedCallback<T> completionHandler,
//   }) async {
//     final accessToken = QsAccount.accessToken;
//     if (accessToken != null) {
//       params ??= {};
//       params['token'] = accessToken;
//     }
//     go(
//       url: url,
//       method: method,
//       params: params,
//       decodeType: decodeType,
//       cache: cache,
//       showHUD: showHUD,
//       showErrorToast: showErrorToast,
//       completionHandler: completionHandler,
//     );
//   }
//
//   // /// 安全上传（带token）
//   // static Future<void> goSafeUpload({
//   //   required String url,
//   //   Map<String, dynamic>? params,
//   //   DataType dataType = DataType.img,
//   //   String pathExtension = '',
//   //   bool showHUD = false,
//   //   required FinishedCallback completionHandler,
//   // }) async {
//   //   final accessToken = QSUserAccount.accessToken;
//   //   if (accessToken != null) {
//   //     params ??= {};
//   //     params['access_token'] = accessToken;
//   //
//   //     try {
//   //       final formData = FormData();
//   //       params.forEach((key, value) {
//   //         if (value is List) {
//   //           for (var i = 0; i < value.length; i++) {
//   //             final fileName =
//   //                 '$i${DateTime.now().toString()}${_getExtension(dataType, pathExtension)}';
//   //             formData.files.add(MapEntry(key + "[$i]",
//   //                 MultipartFile.fromBytes(value[i], filename: fileName)));
//   //           }
//   //         } else if (value is List<int>) {
//   //           final fileName =
//   //               '${DateTime.now().toString()}${_getExtension(dataType, pathExtension)}';
//   //           formData.files.add(MapEntry(
//   //               key, MultipartFile.fromBytes(value, filename: fileName)));
//   //         } else {
//   //           formData.fields.add(MapEntry(key, value.toString()));
//   //         }
//   //       });
//   //
//   //       final response = await dio.post(url, data: formData);
//   //       final json = response.data;
//   //       if (json['errorno'] == 10001) {
//   //         // Handle token error
//   //         await QSService.actionAccessToken((isSuccess) {
//   //           if (isSuccess) {
//   //             goSafeUpload(
//   //               url: url,
//   //               params: params,
//   //               dataType: dataType,
//   //               pathExtension: pathExtension,
//   //               showHUD: showHUD,
//   //               completionHandler: completionHandler,
//   //             );
//   //           }
//   //         });
//   //       } else {
//   //         final object = _transformBean<T>(json);
//   //         completionHandler(object, null);
//   //       }
//   //     } catch (e) {
//   //       if (showErrorToast) {
//   //         showErrorToastFunc(kServiceDontUse);
//   //       }
//   //       completionHandler(null, e as DioError);
//   //     }
//   //   } else {
//   //     completionHandler(null, null);
//   //     postLoginNotification();
//   //   }
//   // }
//
//   /// 发送请求
//   static void _request<T>({
//     required String url,
//     String method = 'GET',
//     Map<String, dynamic>? params,
//     Options? options,
//     T? decodeType,
//     CachePolicy cache = CachePolicy.Default,
//     bool showHUD = false,
//     bool showErrorToast = true,
//     required FinishedCallback<T> completionHandler,
//   }) async {
//     if (!await QsNetcon.isNetworkAvailable()) {
//       if (showErrorToast) {
//         showErrorToastFunc(kNetworkDontUse);
//       }
//       completionHandler(null, NetException.netError());
//       return;
//     }
//
//     try {
//       if (showHUD) {
//         QsHud.showLoading();
//       }
//       final response = await NetOptions.instance.dio.request(
//         url,
//         queryParameters: params,
//         options: _checkOptions(method, options),
//       );
//       // final response = await dio.request(url,
//       //     queryParameters: params, options: Options(method: method));
//       var json = response.data;
//       if (json != null) {
//         //错误处理
//         if (json['code'] != null && json['code'] != "0") {
//           final int code = int.parse(json['code']);
//           if (code == 10000) {
//             // print("token过期");
//             QsApi.refreshToken(completionHandler: (isSuccess, error) {
//               if (isSuccess!) {
//                 goSafe<T>(
//                   url: url,
//                   method: method,
//                   params: params,
//                   decodeType: decodeType,
//                   cache: cache,
//                   showHUD: showHUD,
//                   showErrorToast: showErrorToast,
//                   completionHandler: completionHandler,
//                 );
//               }
//             });
//             return;
//           } else if (json['code'] == '11000') {
//             //登录过期
//             // print("登录过期");
//             QsHud.showToast("Login expired");
//             QsAccount.cleanAccount();
//           }
//           if (showErrorToast) {
//             showErrorToastFunc(json['msg'] ?? 'request failed');
//           }
//           completionHandler(null, NetException(json['msg'], code));
//           return;
//         } else {
//           if (json['data'] != null) {
//             json = json['data'];
//           }
//         }
//       }
//       final object = _transformBean<T>(json, decodeType, false);
//       if (cache != CachePolicy.Default) {
//         QsCache.set(getFullUrl(url, params), json);
//       }
//       if (showHUD) {
//         QsHud.dismiss();
//       }
//       completionHandler(object, null);
//     } catch (e) {
//       if (showErrorToast) {
//         showErrorToastFunc(kServiceDontUse);
//       }
//       completionHandler(null, NetException.serError());
//     }
//   }
//
//   static Options _checkOptions(String method, Options? options) {
//     options ??= Options();
//     options.method = method;
//     return options;
//   }
//
//   /// 获取全路径
//   static String getFullUrl(String url, [Map<String, dynamic>? params]) {
//     // 获取 dio 的 baseUrl
//     final baseUrl = NetOptions.instance.dio.options.baseUrl;
//
//     // 拼接 baseUrl 和 url，确保不重复 "/"
//     final fullUrl = baseUrl.endsWith('/') || url.startsWith('/')
//         ? '$baseUrl$url'
//         : '$baseUrl/$url';
//
//     // 如果有查询参数，拼接参数
//     if (params != null && params.isNotEmpty) {
//       final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');
//       return '$fullUrl?$query';
//     } else {
//       return fullUrl;
//     }
//   }
//
//   /// 转化 JSON 到 Bean
//   static T? _transformBean<T>(dynamic json, T? decodeType, bool isCache) {
//     if (decodeType is BaseNetModel) {
//       var data = decodeType.fromJson(json) as T;
//       if (data is BaseNetModel) {
//         data.isCache = isCache;
//       }
//       return data;
//     } else {
//       return json;
//     }
//   }
//
//   /// 获取事件流
//   /// url: 请求地址
//   /// requestData: 请求数据
//   /// 返回值: 事件流
//   ///
//   static Stream<String> requestEventStream(
//       String url, Map<String, dynamic> requestData) async* {
//     try {
//       final response = await NetOptions.instance.dio.post(
//         url,
//         options: Options(
//           responseType: ResponseType.stream,
//           headers: {
//             'Content-Type': 'application/json',
//           },
//         ),
//         data: jsonEncode(requestData),
//       );
//       // 正确处理响应体为 ResponseBody 类型
//       final ResponseBody responseBody = response.data;
//       // 监听响应体的流，逐步读取字节数据并转换为字符串
//       await for (var chunk in responseBody.stream) {
//         // 将字节块转换为字符串
//         String data = utf8.decode(chunk);
//         // print("dddddd" + data);
//         // 按行分割数据 (一次性返回多条）
//         final lines = data.trim().split('\n');
//         for (var line in lines) {
//           // if (line.startsWith('data:')) {
//           //   final jsonData = line.substring(5).trim(); // 去掉前缀 "data: "
//           //   yield jsonDecode(jsonData); // 转换为 Map
//           // }
//           yield line;
//         }
//         // yield data;
//       }
//     } catch (e) {
//       yield 'Error: $e';
//     }
//   }
//
//   /// 获取文件扩展名
//   static String _getExtension(DataType dataType, String pathExtension) {
//     switch (dataType) {
//       case DataType.mp3:
//         return pathExtension.isNotEmpty ? '.$pathExtension' : '.mp3';
//       case DataType.img:
//       default:
//         return '.png';
//     }
//   }
//
//   /// 显示错误提示
//   static void showErrorToastFunc(String message) {
//     QsHud.dismiss();
//     // UI 显示错误提示，类似 showErrorToast
//     QsHud.showToast(message);
//   }
//
//   /// 发送登录通知
//   static void postLoginNotification() {
//     // 发送需要登录的通知
//   }
// }
//
// // class MBACache {
// //   static Future<Map<String, dynamic>?> fetchJson(String url) async {
// //     // 从缓存中获取数据
// //     return null;
// //   }
// //
// //   static void setJson(Map<String, dynamic> json, String url) {
// //     // 保存数据到缓存
// //   }
// // }
//
// // class QSUserAccount {
// //   static String? get accessToken => 'access_token_value';
// // }
//
// // class QSService {
// //   static Future<void> actionAccessToken(
// //       Function(bool) completionHandler) async {
// //     // 更新 Access Token 的逻辑
// //     completionHandler(true);
// //   }
// // }
