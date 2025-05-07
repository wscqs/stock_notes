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
    } else if (type == "near points") {
      title.value = TextKey.lingjinBSD.tr;
      datas.value = [
        // {"name": "跟随系统", "value": "system"},
        {"name": "1%", "value": "0.01"},
        {"name": "2%", "value": "0.02"},
        {"name": "3%", "value": "0.03"},
        {"name": "4%", "value": "0.04"},
        {"name": "5%", "value": "0.05"},
        {"name": "6%", "value": "0.06"},
        {"name": "7%", "value": "0.07"},
        {"name": "8%", "value": "0.08"},
        {"name": "9%", "value": "0.09"},
        {"name": "10%", "value": "0.1"},
        {"name": "15%", "value": "0.15"},
        {"name": "20%", "value": "0.2"},
      ];
      selKey.value = GlobalService.to.rxNearBSPoint.value.toString();
    }
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
    } else if (type == "near points") {
      GlobalService.to.changeNearBSPoint(double.parse(selKey.value));
    }
    // datas.refresh();
    Get.back();
  }
}
