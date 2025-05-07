import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_notes/app/modules/commonwidget/simple_cell.dart';
import 'package:stock_notes/common/globle_service.dart';
import 'package:stock_notes/common/langs/text_key.dart';

import '../../../routes/app_pages.dart';
import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(TextKey.shezhi.tr),
          centerTitle: true,
        ),
        body: Obx(() {
          final themeMode = GlobalService.to.rxThemeMode.value;
          final local = GlobalService.to.rxLocale.value;
          return Column(
            children: [
              SimpleCell(
                title: TextKey.shensemoshi.tr,
                subTitle: themeMode == ThemeMode.system
                    ? TextKey.gensuixitong.tr
                    : (themeMode == ThemeMode.dark
                        ? TextKey.yikaiqi.tr
                        : TextKey.yiguanbi.tr),
                onPressed: () {
                  Get.toNamed(Routes.SIMPLESEL, arguments: {"type": "theme"});
                },
              ),
              SimpleCell(
                title: TextKey.duoyuyan.tr,
                subTitle: local.languageCode == "zh"
                    ? TextKey.zhongwen.tr
                    : TextKey.English.tr,
                onPressed: () {
                  Get.toNamed(Routes.SIMPLESEL,
                      arguments: {"type": "language"});
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: ListTile(
                  title: Text(
                    TextKey.gupiao.tr,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              SimpleCell(
                title: TextKey.lingjinBSD.tr,
                subTitle:
                    "${(GlobalService.to.rxNearBSPoint.value * 100).toStringAsFixed(0)}%",
                onPressed: () {
                  Get.toNamed(Routes.SIMPLESEL,
                      arguments: {"type": "near points"});
                },
              ),
            ],
          );
        }));
  }
}
