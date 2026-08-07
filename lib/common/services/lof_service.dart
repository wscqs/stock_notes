import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../globle_service.dart';

/// LOF套利 机会检测服务
/// 开关打开时请求 talicai funds 接口，funds 中任意 status == 1 即视为有套利机会, 溢价》=5%
class LofService extends GetxService {
  static LofService get to => Get.find();

  static const String fundsApi =
      'https://www.talicai.com/lof/api/v1/funds?start=0&limit=100&premium_rate=5&type=1';

  /// 是否存在可套利 LOF（funds 中任意 status == 1）
  final RxBool rxHasArbitrage = false.obs;

  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  @override
  void onInit() {
    super.onInit();
    // 开关联动：打开立即检测，关闭清除红点
    ever(GlobalService.to.rxLofEnabled, (bool enabled) {
      if (enabled) {
        checkArbitrage();
      } else {
        rxHasArbitrage.value = false;
      }
    });
    // App 启动时检测一次
    checkArbitrage();
  }

  Future<void> checkArbitrage() async {
    if (!GlobalService.to.rxLofEnabled.value) {
      rxHasArbitrage.value = false;
      return;
    }
    try {
      final response = await _dio.get(fundsApi);
      var data = response.data;
      if (data is String) {
        data = jsonDecode(data);
      }
      bool has = false;
      if (data is Map && data['data'] is Map) {
        final funds = data['data']['funds'];
        if (funds is List) {
          has = funds.any((f) => f is Map && f['status'] == 1);
        }
      }
      rxHasArbitrage.value = has;
    } catch (e) {
      // 网络失败静默处理，不影响红点之外的功能
      if (kDebugMode) {
        print('LofService checkArbitrage error: $e');
      }
    }
  }
}
