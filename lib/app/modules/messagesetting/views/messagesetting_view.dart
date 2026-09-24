import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_notes/app/modules/commonwidget/simple_cell.dart';
import 'package:stock_notes/common/globle_service.dart';
import 'package:stock_notes/common/langs/text_key.dart';

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
        ],
      ),
    );
  }
}
