// /*
//  * Http的缓存策略与处理
//  */
// import 'package:carrotcards/common/extension/String++.dart';
// import 'package:carrotcards/common/https/dio_instance.dart';
// import 'package:carrotcards/utils/qs_cache.dart';
// import 'package:dio/dio.dart';
//
// class CacheControlInterceptor extends Interceptor {
//   @override
//   void onRequest(
//       RequestOptions options, RequestInterceptorHandler handler) async {
//     Map<String, dynamic> headers = options.headers;
//     final String cacheControlName = headers['cache_control'] ?? "";
//     final key = options.uri.toString();
//     //只缓存
//     if (cacheControlName == CachePolicy.ReturnCache_DontLoad.name) {
//       //直接返回缓存
//       final json = await QsCache.get(key);
//       if (json != null) {
//         handler.resolve(Response(
//           statusCode: 200,
//           data: json,
//           statusMessage: '获取缓存成功',
//           requestOptions: RequestOptions(),
//         ));
//       } else {
//         handler.resolve(Response(
//           statusCode: 200,
//           data: json,
//           statusMessage: '获取网络缓存数据失败',
//           requestOptions: RequestOptions(),
//         ));
//       }
//
//       //有缓存用缓存，没缓存用网络请求的数据并存入缓存
//     } else if (cacheControlName == CachePolicy.ReturnCache_ElseLoad.name) {
//       final json = await QsCache.get(key);
//       if (json != null) {
//         handler.resolve(Response(
//           statusCode: 200,
//           data: json,
//           statusMessage: '获取缓存成功',
//           requestOptions: RequestOptions(),
//         ));
//       } else {
//         //处理数据缓存需要的请求头
//         headers['cache_key'] = key;
//         options.headers = headers;
//         //继续转发，走正常的请求
//         handler.next(options);
//       }
//     }
//     // else if (cacheControlName == CachePolicy.ReturnCache_DidLoad.name) {
//     //   final json = await QsCache.get(key);
//     //   if (json != null) {
//     //     Future.delayed(Duration.zero).then((_) {
//     //       handler.resolve(Response(
//     //         statusCode: 200,
//     //         data: json,
//     //         statusMessage: '获取缓存成功',
//     //         requestOptions: RequestOptions(),
//     //       ));
//     //     });
//     //
//     //     // 继续执行请求（无论是否有缓存）
//     //     // headers['cache_key'] = key;
//     //     // options.headers = headers;
//     //     // // super.onRequest(options, handler);
//     //     // // //继续转发，走正常的请求
//     //     // handler.next(options);
//     //     fetchLatestData(options);
//     //   } else {
//     //     //处理数据缓存需要的请求头
//     //     headers['cache_key'] = key;
//     //     options.headers = headers;
//     //     //继续转发，走正常的请求
//     //     handler.next(options);
//     //   }
//     // }
//     else if (cacheControlName == CachePolicy.ReturnNet_DoCache.name) {
//       //处理数据缓存需要的请求头
//       headers['cache_key'] = key;
//       options.headers = headers;
//       //继续转发，走正常的请求
//       handler.next(options);
//     } else {
//       handler.next(options);
//     }
//   }
//
//   // void fetchLatestData(RequestOptions options) async {
//   //   DioInstance.instance().netdocacheRequestOptions(options: options);
//   // }
//
//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) {
//     if (response.statusCode == 200) {
//       //成功的时候设置缓存数据放入 headers 中
//       //响应体中请求体的请求头数据
//       final Map<String, dynamic> requestHeaders =
//           response.requestOptions.headers;
//
//       if (requestHeaders['cache_control'] != null) {
//         final String? cacheKey = requestHeaders['cache_key'];
//         if (cacheKey.isNotEmptyOrNull) {
//           Map<String, dynamic> jsonMap = response.data;
//           QsCache.set(cacheKey!, jsonMap);
//         }
//       }
//     }
//
//     super.onResponse(response, handler);
//   }
//
//   @override
//   Future onError(DioException err, ErrorInterceptorHandler handler) async {
//     final String cacheControlName =
//         err.requestOptions.headers['cache_control'] ?? "";
//     if (cacheControlName == CachePolicy.ReturnNet_DoCache.name) {
//       if (_shouldUseCacheOnError(err)) {
//         final key = err.requestOptions.uri.toString();
//         final json = await QsCache.get(key);
//         if (json != null) {
//           handler.resolve(Response(
//             statusCode: 200,
//             data: json,
//             statusMessage: '获取缓存成功',
//             requestOptions: RequestOptions(),
//           ));
//           return;
//         }
//       }
//     }
//     // 没有缓存或不使用缓存时，继续返回错误
//     handler.next(err);
//   }
//
//   // 根据错误类型决定是否使用缓存
//   bool _shouldUseCacheOnError(DioException err) {
//     return err.type == DioExceptionType.connectionTimeout ||
//         err.type == DioExceptionType.connectionError;
//   }
// }
