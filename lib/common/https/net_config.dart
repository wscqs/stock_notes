import 'package:dio/dio.dart';

/// dio 配置项
class NetConfig {
  /// Request base url, it can contain sub paths like: https://pub.dev/api/.
  String? baseUrl;

  /// [proxy] is the proxy server of the request.
  String? proxy;

  /// [HttpAdapter] is a bridge between [Dio] and [HttpClient].
  ///
  /// [Dio] implements standard and friendly API for developer.
  /// [HttpClient] is the real object that makes Http
  /// requests.
  ///
  /// We can use any [HttpClient]s not just "dart:io:HttpClient" to
  /// make the HTTP request. All we need is to provide a [HttpClientAdapter].
  ///
  /// If you want to customize the [HttpClientAdapter] you should instead use
  /// either [IOHttpClientAdapter] on `dart:io` platforms
  /// or [BrowserHttpClientAdapter] on `dart:html` platforms.
  ///
  /// ```dart
  /// dio.httpClientAdapter = HttpClientAdapter();
  /// ```  HttpClientAdapter? httpClientAdapter;
  HttpClientAdapter? httpClientAdapter;

  /// Each Dio instance has a interceptor by which you can intercept requests or responses before they are
  /// handled by `then` or `catchError`. the [interceptor] field
  /// contains a [RequestInterceptor] and a [ResponseInterceptor] instance.
  List<Interceptor>? interceptors;

  /// Timeout in milliseconds for opening url.
  /// [Dio] will throw the [DioError] with [DioErrorType.connectionTimeout] type
  ///  when time out.
  Duration? connectTimeout;

  /// Timeout in milliseconds for sending data.
  /// [Dio] will throw the [DioError] with [DioErrorType.sendTimeout] type
  ///  when time out.
  Duration? sendTimeout;

  ///  Timeout in milliseconds for receiving data.
  ///
  ///  Note: [receiveTimeout]  represents a timeout during data transfer! That is to say the
  ///  client has connected to the server, and the server starts to send data to the client.
  ///
  /// `null` meanings no timeout limit.
  Duration? receiveTimeout;

  /// Http request headers. The keys of initial headers will be converted to lowercase,
  /// for example 'Content-Type' will be converted to 'content-type'.
  ///
  /// The key of Header Map is case-insensitive, eg: content-type and Content-Type are
  /// regard as the same key.
  Map<String, dynamic>? headers;

  NetConfig._internal(
    this.baseUrl,
    this.proxy,
    this.httpClientAdapter,
    this.interceptors,
    this.connectTimeout,
    this.sendTimeout,
    this.receiveTimeout,
    this.headers,
  );

  NetConfig.build(HttpConfigBuilder build)
      : this._internal(
          build.baseUrl,
          build.proxy,
          build.httpClientAdapter,
          build.interceptors,
          build.connectTimeout,
          build.sendTimeout,
          build.receiveTimeout,
          build.headers,
        );
}

class HttpConfigBuilder {
  String? _baseUrl;
  String? _proxy;
  HttpClientAdapter? _httpClientAdapter;
  List<Interceptor>? _interceptors;
  Duration? _connectTimeout;
  Duration? _sendTimeout;
  Duration? _receiveTimeout;
  Map<String, dynamic>? _headers;

  HttpConfigBuilder setBaseUrl(String baseUrl) {
    _baseUrl = baseUrl;
    return this;
  }

  HttpConfigBuilder setConnectTimeout(Duration connectTimeout) {
    _connectTimeout = connectTimeout;
    return this;
  }

  HttpConfigBuilder setHttpClientAdapter(HttpClientAdapter httpClientAdapter) {
    _httpClientAdapter = httpClientAdapter;
    return this;
  }

  HttpConfigBuilder addHeaders(Map<String, dynamic> headers) {
    _headers = headers;
    return this;
  }

  HttpConfigBuilder addInterceptor(Interceptor interceptors) {
    _interceptors ??= [];
    _interceptors!.add(interceptors);
    return this;
  }

  HttpConfigBuilder addAllInterceptors(List<Interceptor> interceptors) {
    _interceptors ??= [];
    _interceptors!.addAll(interceptors);
    return this;
  }

  HttpConfigBuilder setProxy(String proxy) {
    _proxy = proxy;
    return this;
  }

  HttpConfigBuilder setReceiveTimeout(Duration receiveTimeout) {
    _receiveTimeout = receiveTimeout;
    return this;
  }

  HttpConfigBuilder setSendTimeout(Duration sendTimeout) {
    _sendTimeout = sendTimeout;
    return this;
  }

  NetConfig create() {
    return NetConfig.build(this);
  }

  String? get baseUrl => _baseUrl;

  String? get proxy => _proxy;

  HttpClientAdapter? get httpClientAdapter => _httpClientAdapter;

  List<Interceptor>? get interceptors => _interceptors;

  Duration? get connectTimeout => _connectTimeout;

  Duration? get sendTimeout => _sendTimeout;

  Duration? get receiveTimeout => _receiveTimeout;

  Map<String, dynamic>? get headers => _headers;
}
