import 'dart:io';
import 'dart:math' as math;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stock_notes/common/langs/text_key.dart';
import 'package:stock_notes/utils/qs_constants.dart';
import 'package:stock_notes/utils/qs_hud.dart';

import '../../../../common/database/DatabaseManager.dart';
import '../../../../common/database/database.dart';
import '../../../../utils/qs_cache.dart';
import '../../../../utils/qs_utils.dart' as QsView;
import '../../../routes/app_pages.dart';

class HomedrawerVC extends GetxController {
  // 切换数据源后 DatabaseManager 内的 db 会更换，必须每次动态获取，不能缓存
  AppDatabase get db => Get.find<DatabaseManager>().db;
  File? lastBackupFile;

  @override
  void onInit() {
    super.onInit();
  }

  void shareApp() {
    SharePlus.instance.share(ShareParams(text: kAppGithubUrl));
  }

  /// 请喝咖啡 - 打赏作者弹窗
  void showCoffeeDialog() {
    // 桌面端窗口可能很大/很小，图片尺寸按屏幕比例并设上限，弹窗限宽
    final screenSize = MediaQuery.of(Get.context!).size;
    final imgSize =
        math.min(280.0, math.min(screenSize.width * 0.6, screenSize.height * 0.45));
    QsHud.showDialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 340),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      TextKey.qinghekafei.tr,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onLongPress: saveZstImage,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/zst.jpg',
                          width: imgSize,
                          height: imgSize,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      TextKey.changanbaocunerweima.tr,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4),
                    Text(
                      TextKey.weixinsaoyisaoqgz.tr,
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(Icons.close, size: 22),
                  onPressed: () {
                    QsHud.dismiss();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 长按保存赞赏二维码；移动端存相册，桌面端弹系统保存对话框
  Future<void> saveZstImage() async {
    try {
      final data = await rootBundle.load('assets/images/zst.jpg');
      final bytes = data.buffer.asUint8List();
      // macOS 沙盒下 PhotoKit 会被 TCC 强杀，桌面端改用系统保存对话框
      if (Platform.isMacOS || Platform.isWindows) {
        final uri = await FilePicker.saveFile(
          dialogTitle: TextKey.baocun.tr,
          fileName: 'zst.jpg',
          bytes: bytes,
          mimeType: 'image/jpeg',
        );
        if (uri != null) QsHud.showToast(TextKey.success.tr);
        return;
      }
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess && !(await Gal.requestAccess())) {
        QsHud.showToast(TextKey.xuyaoxiangcequanxian.tr);
        return;
      }
      await Gal.putImageBytes(bytes, name: 'zst');
      QsHud.showToast(TextKey.yibaocundaoxiangce.tr);
    } catch (_) {
      QsHud.showToast(TextKey.fails.tr);
    }
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
