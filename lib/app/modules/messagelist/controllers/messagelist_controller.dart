import 'package:get/get.dart';
import 'package:stock_notes/common/extension/DateTime++.dart';
import 'package:stock_notes/common/langs/text_key.dart';

import '../../../../common/database/DatabaseManager.dart';
import '../../../../common/database/database.dart';
import '../../../../utils/qs_hud.dart';
import '../../../routes/app_pages.dart';
import '../../base/base_controller.dart';

class MessagelistController extends BaseController {
  late var db = Get.find<DatabaseManager>().db;
  final messages = <MessageItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    getDatas();
    // 进入页面即全部标记已读（清首页角标）
    db.markAllMessagesRead();
  }

  Future<void> getDatas() async {
    messages.value = await db.getMessages();
  }

  String _condLabel(MessageItem msg) {
    return switch (msg.condKind) {
      1 => TextKey.jige.tr,
      2 => TextKey.shizhi.tr,
      _ => TextKey.shiyin.tr,
    };
  }

  // 卡片标题名称部分：名称(代码)
  String msgTitleName(MessageItem msg) {
    return '${msg.stockName}(${msg.stockCode})';
  }

  // 卡片标题维度值部分（价格维度显示为最新价）：最新价X / 市值X / 市盈(MMT)X
  String msgTitleValue(MessageItem msg) {
    final label = msg.condKind == 1 ? TextKey.zuixinjia.tr : _condLabel(msg);
    return '$label${msg.currentValue ?? ''}';
  }

  // 标题行右侧条件标签（同首页cell）：价格:满足B / 市值:满足S
  String msgConditionTag(MessageItem msg) {
    final kindLabel = msg.condKind == 3
        ? TextKey.stockCellPe.tr
        : _condLabel(msg); // 市盈标签同首页用「市盈」
    final dirLabel =
        (msg.msgType == 1 ? TextKey.mangzuB.tr : TextKey.mangzuS.tr)
            .replaceAll('买', 'B')
            .replaceAll('卖', 'S');
    return '$kindLabel:$dirLabel';
  }

  // 消息文案：你关注的 名称(代码) 于 时间 达到X, 低于买入目标价格Y了。
  String msgContent(MessageItem msg) {
    final condLabel = _condLabel(msg);
    final dirLabel = msg.msgType == 1
        ? TextKey.msgDiyuMairuMubiao.tr
        : TextKey.msgGaoyuMaichuMubiao.tr;
    return '${TextKey.msgNiguanzhude.tr}${msg.stockName}(${msg.stockCode})'
        '${TextKey.msgYu.tr}${msg.createdAt.toDateTimeString()}'
        '${TextKey.msgDadao.tr}${msg.currentValue ?? ''}, '
        '$dirLabel$condLabel${msg.targetValue ?? ''}${TextKey.msgLe.tr}';
  }

  Future<void> clickLookDetail(MessageItem msg) async {
    final item = await db.getStockItem(msg.stockCode);
    if (item == null || item.opDelete) {
      QsHud.showToast(TextKey.gupiaobucunzai.tr);
      return;
    }
    Get.toNamed(Routes.STOCKEDIT, arguments: item.copyWith());
  }

  Future<void> deleteMsg(MessageItem msg) async {
    await db.deleteMessage(msg);
    messages.remove(msg);
  }
}
