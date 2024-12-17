import 'dart:convert';

import 'package:dio/dio.dart';

class ResDataJsonInterceptor extends InterceptorsWrapper {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data is String) {
      try {
        // 尝试解析字符串为JSON
        response.data = jsonDecode(response.data);
      } catch (e) {
        // 解析失败，可能不是JSON字符串，可以根据需要处理
      }
    }
    return handler.next(response); // 继续执行后续处理
  }
}
