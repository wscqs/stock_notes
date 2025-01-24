import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/langs/text_key.dart';

class AboutController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void toCustomerService() {
    Get.dialog(AlertDialog(
      title: Text(TextKey.lianxi.tr),
      content: Text("qq:935966764"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(Get.overlayContext!).pop(); // 明确关闭对话框
            },
            child: Text(TextKey.queding.tr))
      ],
    ));
  }
}
