import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/langs/text_key.dart';

class AboutController extends GetxController {
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

  final Uri _url = Uri.parse('https://github.com/wscqs/stock_notes');

  void toGithub() {
    launchUrl(_url);
  }
}
