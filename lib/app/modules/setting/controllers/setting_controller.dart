import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/langs/text_key.dart';
import 'package:stock_notes/common/services/stock_name_service.dart';
import 'package:stock_notes/utils/qs_hud.dart';

class SettingController extends GetxController {
  final isRefreshingStockCodes = false.obs;

  /// 手动刷新本地 A 股全量 code/name 缓存
  Future<void> refreshAllStockCodes() async {
    if (isRefreshingStockCodes.value) return;
    isRefreshingStockCodes.value = true;
    try {
      final map = await StockNameService.refreshStockMap(
        onProgress: (page, total) {
          if (kDebugMode) {
            print('StockNameService manual refresh page=$page total=$total');
          }
        },
      );
      if (map.isNotEmpty) {
        QsHud.showToast(TextKey.quanlianggupiaoshuaxinchenggong.tr
            .replaceFirst('%s', map.length.toString()));
      } else {
        QsHud.showToast(TextKey.quanlianggupiaoshuaxinshibai.tr);
      }
    } catch (e) {
      QsHud.showToast(TextKey.quanlianggupiaoshuaxinshibai.tr);
    } finally {
      isRefreshingStockCodes.value = false;
    }
  }
}
