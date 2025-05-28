import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:stock_notes/common/langs/text_key.dart';
import 'package:stock_notes/utils/qs_hud.dart';

import '../../../../common/database/DatabaseManager.dart';
import '../../../../utils/qs_cache.dart';
import '../../../../utils/qs_utils.dart' as QsView;
import '../../../routes/app_pages.dart';

class HomedrawerVC extends GetxController {
  final db = Get.find<DatabaseManager>().db;
  File? lastBackupFile;

  @override
  void onInit() {
    super.onInit();
  }

  void clickShujuyuan() {
    String selectedDateSourceKey = QsCache.get("selectedDateSourceKey") ?? "";
    if (selectedDateSourceKey.isEmpty) {
      showFirstShujuyuanDialog();
    } else {
      Get.toNamed(Routes.DATESOURCE);
    }
  }

  void showFirstShujuyuanDialog() {
    TextEditingController textController = TextEditingController();

    QsHud.showDialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                TextKey.shoucichuangjianshujuyuan.tr,
                style: TextStyle(fontSize: 18), // 可选：设置文本样式
              ),
            ),
            SizedBox(height: 10), // 间距
            TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: TextKey.shurumingzisouziszm.tr,
                border: OutlineInputBorder(),
                counterText: '', // 隐藏计数器
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              ),
              maxLength: 10,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              QsHud.dismiss();
            },
            child: Text(TextKey.quxiao.tr),
          ),
          TextButton(
            onPressed: () {
              if (textController.text.isEmpty) {
                QsHud.showToast(TextKey.qingshuru.tr);
                return;
              } else {
                QsHud.dismiss();
                initSaveDataSource(textController.text);
              }
            },
            child: Text(TextKey.queding.tr),
          ),
        ],
      ),
    );
  }

  Future<void> initSaveDataSource(String nameText) async {
    var name = nameText;
    if (name.isEmpty) {
      QsHud.showToast(TextKey.qingshuru.tr + TextKey.shurumingzisouziszm.tr);
      return;
    }
    QsView.hideKeyboard();
    final backupDir = await getApplicationDocumentsDirectory();
    final file = File(p.join(backupDir.path, 'stocknotes_${name}.db'));
    if (await file.exists()) {
      await file.delete();
    }
    await db.customStatement('VACUUM INTO ?', [file.path]);
    lastBackupFile = file;
    saveToDateSourceList(nameText);
  }

  Future<void> saveToDateSourceList(String nameText) async {
    if (lastBackupFile == null || !(await lastBackupFile!.exists())) {
      QsHud.showToast(TextKey.noData.tr);
      return;
    }
    final tempDateSourceList = <Map<String, dynamic>>[].obs;
    tempDateSourceList.add({
      'name': nameText,
      'path': lastBackupFile!.path,
    });
    QsCache.set("dateSourceListKey", tempDateSourceList);
    QsCache.set("selectedDateSourceKey", nameText);

    Get.toNamed(Routes.DATESOURCE);
  }
}
