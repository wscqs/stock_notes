import 'package:dio/dio.dart';

import 'net_config.dart';

class NetOptions {
  /// private constructor
  NetOptions._() : _httpConfigBuilder = HttpConfigBuilder();

  /// the one and only instance of this singleton
  static final instance = NetOptions._();

  final HttpConfigBuilder _httpConfigBuilder;

  final Dio _dio = Dio();

  Dio get dio => _dio;

  // NetDecoder _httpDecoder = DefaultNetDecoder.getInstance();
  //
  // NetDecoder get httpDecoder => _httpDecoder;
  bool _isLogger = true;

  /// Setting the base url for the http request.
  NetOptions setBaseUrl(String baseUrl) {
    _httpConfigBuilder.setBaseUrl(baseUrl);
    return instance;
  }

  /// Setting the connection timeout for the http request.
  NetOptions setConnectTimeout(Duration connectTimeout) {
    _httpConfigBuilder.setConnectTimeout(connectTimeout);
    return instance;
  }

  /// Adding headers to the request.
  NetOptions addHeaders(Map<String, dynamic> headers) {
    _httpConfigBuilder.addHeaders(headers);
    return instance;
  }

  /// Setting the httpClientAdapter for the http request.
  ///  ex: proxy Certificate
  NetOptions setHttpClientAdapter(HttpClientAdapter httpClientAdapter) {
    _httpConfigBuilder.setHttpClientAdapter(httpClientAdapter);
    return instance;
  }

  /// Adding an interceptor to the dio instance.
  NetOptions addInterceptor(Interceptor interceptor) {
    _httpConfigBuilder.addInterceptor(interceptor);
    return instance;
  }

  /// Adding all the interceptors to the dio instance.
  NetOptions addAllInterceptors(List<Interceptor> interceptors) {
    _httpConfigBuilder.addAllInterceptors(interceptors);
    return instance;
  }

  /// Setting the timeout for receiving data.
  NetOptions setReceiveTimeout(Duration receiveTimeout) {
    _httpConfigBuilder.setReceiveTimeout(receiveTimeout);
    return instance;
  }

  /// Setting the timeout for sending data.
  NetOptions setSendTimeout(Duration sendTimeout) {
    _httpConfigBuilder.setSendTimeout(sendTimeout);
    return instance;
  }

  /// Used to enable/disable the logger.
  /// 默认使用 PrettyDioLogger 打印
  NetOptions enableLogger(bool enable) {
    _isLogger = enable;
    return instance;
  }

  /// 配置网络请求并初始化
  void create() {
    var httpConfig = _httpConfigBuilder.create();
    if (httpConfig.interceptors?.isNotEmpty ?? false) {
      _dio.interceptors.addAll(httpConfig.interceptors!);
    }
    if (_isLogger) {
      // dio.interceptors.add(PrettyDioLogger(
      //     requestHeader: true,
      //     requestBody: true,
      //     responseBody: true,
      //     responseHeader: false,
      //     error: true,
      //     compact: true,
      //     maxWidth: 90));
    }
    _dio.options = BaseOptions(
        baseUrl: httpConfig.baseUrl ?? '',
        contentType: 'application/json',
        connectTimeout: httpConfig.connectTimeout,
        sendTimeout: httpConfig.sendTimeout,
        receiveTimeout: httpConfig.receiveTimeout,
        headers: httpConfig.headers);
    if (httpConfig.httpClientAdapter != null) {
      _dio.httpClientAdapter = httpConfig.httpClientAdapter!;
    }
  }
}
