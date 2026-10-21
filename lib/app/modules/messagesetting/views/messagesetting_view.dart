import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_notes/app/modules/commonwidget/simple_cell.dart';
import 'package:stock_notes/common/globle_service.dart';
import 'package:stock_notes/common/langs/text_key.dart';
import 'package:stock_notes/utils/qs_hud.dart';

import '../controllers/messagesetting_controller.dart';

class MessagesettingView extends GetView<MessagesettingController> {
  const MessagesettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TextKey.xiaoxishezhi.tr),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SimpleCell(
            title: TextKey.xiaohongdiantixing.tr,
            isShowRightArrow: false,
            rightWidget: Obx(() {
              return Switch(
                value: GlobalService.to.rxMsgRedDotEnabled.value,
                onChanged: (value) {
                  GlobalService.to.changeMsgRedDotEnabled(value);
                },
              );
            }),
            onPressed: () {
              GlobalService.to.changeMsgRedDotEnabled(
                  !GlobalService.to.rxMsgRedDotEnabled.value);
            },
          ),
          SimpleCell(
            title: TextKey.anchicunguolvtixing.tr,
            bottomSubTitle: TextKey.maichutixingjinchicang.tr,
            isShowRightArrow: false,
            rightWidget: Obx(() {
              return Switch(
                value: GlobalService.to.rxMsgHoldFilterEnabled.value,
                onChanged: (value) {
                  GlobalService.to.changeMsgHoldFilterEnabled(value);
                },
              );
            }),
            onPressed: () {
              GlobalService.to.changeMsgHoldFilterEnabled(
                  !GlobalService.to.rxMsgHoldFilterEnabled.value);
            },
          ),
          SimpleCell(
            title: TextKey.qingkongxiaoxiliebiao.tr,
            bottomSubTitle: TextKey.qingkonghouwufahuifu.tr,
            isShowRightArrow: false,
            rightWidget: Text(
              TextKey.qingkong.tr,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 14,
              ),
            ),
            onPressed: () {
              QsHud.showConfirmDialog(
                title: TextKey.querenshanchu.tr,
                content: TextKey.querenshanchusuoyouxiaoxi.tr,
                confirmText: TextKey.queding.tr,
                cancelText: TextKey.quxiao.tr,
                onConfirm: () {
                  controller.clearAllMessages();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
