import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/langs/text_key.dart';

import '../../../../common/globle_service.dart';

class SimpleselController extends GetxController {
  String type = ""; //theme,language
  final title = "".obs;
  final datas = [].obs;
  final selKey = "".obs;

  @override
  void onInit() {
    super.onInit();
    type = Get.arguments["type"] ?? "";
    if (type == "theme") {
      title.value = TextKey.shensemoshi.tr;
      datas.value = [
        {"name": TextKey.gensuixitong.tr, "value": "system"},
        {"name": TextKey.shensemoshi.tr, "value": "dark"},
        {"name": TextKey.qiansemoshi.tr, "value": "light"},
      ];
      selKey.value = GlobalService.to.themeMode.name;
    } else if (type == "language") {
      title.value = TextKey.duoyuyan.tr;
      datas.value = [
        // {"name": "跟随系统", "value": "system"},
        {"name": "中文", "value": "zh"},
        {"name": "English", "value": "en"},
      ];
      selKey.value = GlobalService.to.locale.languageCode;
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void sel(int index) {
    selKey.value = datas[index]["value"];
    if (type == "theme") {
      if (selKey.value == "system") {
        GlobalService.to.changeThemeMode(ThemeMode.system);
      } else {
        GlobalService.to.changeThemeMode(
            selKey.value == "dark" ? ThemeMode.dark : ThemeMode.light);
      }
    } else if (type == "language") {
      if (selKey.value == "zh") {
        GlobalService.to.changeLocale(const Locale("zh"));
      } else {
        GlobalService.to.changeLocale(const Locale("en"));
      }
    }
    // datas.refresh();
    Get.back();
  }
}
