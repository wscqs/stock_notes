import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/langs/text_key.dart';
import '../../../../common/web/webview_page.dart';
import '../../../../common/web/webview_widget.dart';
import '../../../../utils/qs_constants.dart';
import '../../../../utils/qs_devicepackageinfo.dart';

class AboutController extends GetxController {
  final version = ''.obs;
  final buildNumber = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    version.value = await QsDevicePackageInfo.getVersion();
    buildNumber.value = await QsDevicePackageInfo.getBuildNumber();
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

  final Uri _url = Uri.parse(kAppGithubUrl);

  void toGithub() {
    launchUrl(_url);
  }

  /// 意见反馈：应用内 WebView 打开腾讯问卷
  void toFeedback() {
    Get.to(() => WebViewPage(
          loadResource: kFeedbackUrl,
          webViewType: WebViewType.URL,
          title: TextKey.yijianfankui.tr,
        ));
  }
}
