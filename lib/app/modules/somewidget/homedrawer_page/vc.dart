import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:stock_notes/common/langs/text_key.dart';
import 'package:stock_notes/utils/qs_hud.dart';

import '../../../../common/database/connection/native.dart';
import '../../../../common/database/database.dart';

class HomedrawerVC extends GetxController {
  final db = Get.find<AppDatabase>();
  File? lastBackupFile;

  void clickDaorudaochu() {
    QsHud.showConfirmDialog(
        title: TextKey.daorudaochu.tr,
        content: "",
        cancelText: TextKey.daoru.tr,
        confirmText: TextKey.daochu.tr,
        onCancel: () {
          restoreBackup();
        },
        onConfirm: () {
          createBackup();
        });
  }

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> closeDb() async {
    await db.close();
  }

  //todo 看下怎么调整
  Future<void> reopenDb() async {
    // 关键：清除旧数据库实例并重新创建
    // Get.delete<AppDatabase>();
    // Get.put(AppDatabase());
    update();
  }

  Future<void> createBackup() async {
    final backupDir = await getApplicationDocumentsDirectory();
    final file = File(p.join(backupDir.path, 'drift_example_backup.db'));

    if (await file.exists()) {
      await file.delete();
    }

    await db.customStatement('VACUUM INTO ?', [file.path]);

    lastBackupFile = file;
    shareBackup();
  }

  Future<void> shareBackup() async {
    if (lastBackupFile == null || !(await lastBackupFile!.exists())) {
      Get.snackbar('Error', 'No backup available to share',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final params = ShareParams(
      text: 'Database Backup File',
      files: [XFile(lastBackupFile!.path)],
    );

    final result = await SharePlus.instance.share(params);
    // if (result.status == ShareResultStatus.success) {
    // }
  }

  Future<void> restoreBackup() async {
    await closeDb();

    final picked = await FilePicker.platform.pickFiles();
    if (picked == null) return;

    final backupDb = sqlite3.open(picked.files.single.path!);

    final tempPath = await getTemporaryDirectory();
    final tempDb = p.join(tempPath.path, 'import.db');

    backupDb
      ..execute('VACUUM INTO ?', [tempDb])
      ..dispose();

    final tempDbFile = File(tempDb);
    await tempDbFile.copy((await databaseFile).path);
    await tempDbFile.delete();

    await reopenDb();

    Get.snackbar('Restore Complete', 'Database restored successfully',
        snackPosition: SnackPosition.BOTTOM);
  }
}
