// import 'package:carrotcards/common/https/interceptor/res_data_json_interceptor.dart';
// import 'package:carrotcards/common/https/qs_account.dart';
// import 'package:carrotcards/common/https/qs_request.dart';
// import 'package:dio/dio.dart';
//
// import 'interceptor/print_log_interceptor.dart';
//
// ///http的请求方式
// class HttpMethod {
//   //HEAD、PUT、DELETE、OPTIONS、TRACE、CONNECT
//   static const String POST = "POST";
//   static const String GET = "GET";
//   static const String PUT = "PUT";
//   static const String DELETE = "DELETE";
//   static const String OPTIONS = "OPTIONS";
//   static const String TRACE = "TRACE";
//   static const String CONNECT = "CONNECT";
// }
//
// // enum CachePolicy {
// //   Default, //默认，不使用缓存
// //   ReturnNet_DoCache, //返回网路，并缓存（异常尝试返回缓存）
// //   // ReturnCache_DidLoad, //如果有缓存则返回缓存,然后加载网络返回更新缓存 （我iOS这么设计，但flutter好像不太规范）
// //   ReturnCache_ElseLoad, //如果有缓存则返回缓存不加载网络，否则加载网络数据并且缓存数据
// //   ReturnCache_DontLoad, //只用缓存（离线模式）
// // }
//
// class DioInstance {
//   static DioInstance? _instance;
//
//   DioInstance._internal();
//
//   static DioInstance instance() {
//     return _instance ??= DioInstance._internal();
//   }
//
//   Dio _dio = Dio();
//   final _defaultTimeout = const Duration(seconds: 30);
//   var _inited = false;
//
//   void initDio({
//     required String baseUrl,
//     String? method = HttpMethod.GET,
//     Duration? connectTimeout,
//     Duration? receiveTimeout,
//     Duration? sendTimeout,
//     ResponseType? responseType = ResponseType.json,
//     String? contentType,
//   }) async {
//     _dio.options = buildBaseOptions(
//         method: method,
//         baseUrl: baseUrl,
//         connectTimeout: connectTimeout ?? _defaultTimeout,
//         receiveTimeout: receiveTimeout ?? _defaultTimeout,
//         sendTimeout: sendTimeout ?? _defaultTimeout,
//         responseType: responseType,
//         contentType: contentType);
//     // _dio.interceptors.add(CookieInterceptor());
//     // // final cookieJar = CookieJar();
//     // _dio.interceptors.add(CookieManager(cookieJar));
//     _dio.interceptors.add(ResDataJsonInterceptor());
//     _dio.interceptors.add(PrintLogInterceptor());
//     // _dio.interceptors.add(RequestInterceptor());
//     // _dio.interceptors.add(CacheControlInterceptor());
//     _inited = true;
//   }
//
//   ///自己业务
//   Future<Response> go({
//     required String path,
//     String method = HttpMethod.GET,
//     Map<String, dynamic>? param,
//     CachePolicy cachePolicy = CachePolicy.Default,
//     Options? options,
//     CancelToken? cancelToken,
//   }) async {
//     Map<String, dynamic> headers = <String, String>{};
//     headers['cache_control'] = cachePolicy.name;
//
//     if (HttpMethod.GET == method) {
//       return get(
//           path: path,
//           param: param,
//           headers: headers,
//           options: options,
//           cancelToken: cancelToken);
//     } else {
//       return post(
//           path: path,
//           queryParameters: param,
//           headers: headers,
//           options: options,
//           cancelToken: cancelToken);
//     }
//   }
//
//   ///自己业务(带token)
//   Future<Response> goSafe({
//     required String path,
//     String method = HttpMethod.GET,
//     Map<String, dynamic>? param,
//     CachePolicy cachePolicy = CachePolicy.Default,
//     Options? options,
//     CancelToken? cancelToken,
//   }) async {
//     if (param == null) {
//       param = <String, dynamic>{};
//     }
//     if (QsAccount.accessToken != null) {
//       param["access_token"] = QsAccount.accessToken!;
//     }
//     return go(
//         path: path,
//         method: method,
//         param: param,
//         cachePolicy: cachePolicy,
//         options: options,
//         cancelToken: cancelToken);
//   }
//
//   // //只有缓存加载逻辑用
//   // Future<Response> netdocacheRequestOptions(
//   //     {required RequestOptions options}) async {
//   //   options.headers['cache_control'] = CachePolicy.ReturnNet_DoCache.name;
//   //   return _dio.request(options.path,
//   //       options: _requestOptionsToOptions(options));
//   // }
//   //
//   // Options _requestOptionsToOptions(RequestOptions requestOptions) {
//   //   return Options(
//   //     method: requestOptions.method,
//   //     sendTimeout: requestOptions.sendTimeout,
//   //     receiveTimeout: requestOptions.receiveTimeout,
//   //     extra: requestOptions.extra,
//   //     headers: requestOptions.headers,
//   //     responseType: requestOptions.responseType,
//   //     contentType: requestOptions.contentType.toString(),
//   //     validateStatus: requestOptions.validateStatus,
//   //     receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
//   //     followRedirects: requestOptions.followRedirects,
//   //     maxRedirects: requestOptions.maxRedirects,
//   //     requestEncoder: requestOptions.requestEncoder,
//   //     responseDecoder: requestOptions.responseDecoder,
//   //     listFormat: requestOptions.listFormat,
//   //   );
//   // }
//
//   ///get请求方式
//   Future<Response> get({
//     required String path,
//     Object? data,
//     Map<String, dynamic>? param,
//     Map<String, dynamic>? headers,
//     Options? options,
//     CancelToken? cancelToken,
//   }) async {
//     if (!_inited) {
//       throw Exception("you should call initDio() first!");
//     }
//     return await _dio.get(path,
//         queryParameters: param,
//         options: options ??
//             Options(
//               headers: headers,
//               method: HttpMethod.GET,
//               receiveTimeout: _defaultTimeout,
//               sendTimeout: _defaultTimeout,
//               responseType: ResponseType.json,
//             ),
//         cancelToken: cancelToken);
//   }
//
//   ///post请求方式
//   Future<Response> post(
//       {required String path,
//       Object? data,
//       Map<String, dynamic>? queryParameters,
//       Map<String, dynamic>? headers,
//       Options? options,
//       CancelToken? cancelToken}) async {
//     if (!_inited) {
//       throw Exception("you should call initDio() first!");
//     }
//     return await _dio.post(path,
//         data: data,
//         queryParameters: queryParameters,
//         cancelToken: cancelToken,
//         options: options ??
//             Options(
//               headers: headers,
//               method: HttpMethod.POST,
//               receiveTimeout: _defaultTimeout,
//               sendTimeout: _defaultTimeout,
//               responseType: ResponseType.json,
//             ));
//   }
//
//   BaseOptions buildBaseOptions({
//     required String baseUrl,
//     String? method = HttpMethod.GET,
//     Duration? connectTimeout,
//     Duration? receiveTimeout,
//     Duration? sendTimeout,
//     ResponseType? responseType = ResponseType.json,
//     String? contentType,
//   }) {
//     return BaseOptions(
//         method: method,
//         baseUrl: baseUrl,
//         connectTimeout: connectTimeout ?? _defaultTimeout,
//         receiveTimeout: receiveTimeout ?? _defaultTimeout,
//         sendTimeout: sendTimeout ?? _defaultTimeout,
//         responseType: responseType,
//         contentType: contentType);
//   }
//
//   void changeBaseUrl(String baseUrl) {
//     _dio.options.baseUrl = baseUrl;
//   }
// }
