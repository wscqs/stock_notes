import 'package:get/get.dart';
import 'package:stock_notes/app/modules/messagelist/controllers/messagelist_controller.dart';
import 'package:stock_notes/common/database/DatabaseManager.dart';
import 'package:stock_notes/common/langs/text_key.dart';
import 'package:stock_notes/utils/qs_hud.dart';

import '../../base/base_controller.dart';

class MessagesettingController extends BaseController {
  Future<void> clearAllMessages() async {
    final db = Get.find<DatabaseManager>().db;
    await db.deleteAllMessages();
    // 如果消息列表页面已加载，刷新其列表
    if (Get.isRegistered<MessagelistController>()) {
      await Get.find<MessagelistController>().getDatas();
    }
    QsHud.showToast(TextKey.yiqingkong.tr);
  }
}
