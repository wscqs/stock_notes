import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:stock_notes/common/langs/text_key.dart';
import 'package:stock_notes/utils/qs_cache.dart';
import 'package:stock_notes/utils/qs_hud.dart';
import 'package:stock_notes/utils/qs_view.dart';

import '../../../../common/database/connection/native.dart';
import '../../../../common/database/database.dart';

class DatesourceController extends GetxController {
  final nameText = TextEditingController();
  final selectedOption = "doSel".obs;

  final db = Get.find<AppDatabase>();
  File? lastBackupFile;
  final dateSourceList = <Map<String, dynamic>>[].obs;
  final selectedDateSource = "".obs; //name

  @override
  void onInit() {
    super.onInit();
    loadDateSourceList();
    loadSelDateSource();
    //当前选中的数据源文件更新
    currentLocalBackup();
  }

  void loadSelDateSource() {
    selectedDateSource.value =
        QsCache.get<String>("selectedDateSourceKey") ?? "";
    if (selectedDateSource.value.isNotEmpty) {
      nameText.text = selectedDateSource.value;
    }
  }

  void loadDateSourceList() {
    // 读取数据，返回 List<dynamic>
    List<dynamic>? storedList = QsCache.get("dateSourceListKey");
    if (storedList != null) {
      // 将 List<dynamic> 转换为 List<Map<String, dynamic>>
      List<Map<String, dynamic>> tempDateSourceList =
          List<Map<String, dynamic>>.from(storedList);
      print(tempDateSourceList.toString());
      dateSourceList.value = tempDateSourceList;
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

  Future<void> currentLocalBackup() async {
    var name = nameText.text;
    final backupDir = await getApplicationDocumentsDirectory();
    final file = File(p.join(backupDir.path, 'stocknotes_${name}.db'));
    if (await file.exists()) {
      await file.delete();
    }
    await db.customStatement('VACUUM INTO ?', [file.path]);
    // lastBackupFile = file;
    // saveToDateSourceList(name, isReplace: true);
  }

  Future<void> createBackup() async {
    var name = nameText.text;
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
    shareBackup();
  }

  Future<void> inputBackup() async {
    final picked = await FilePicker.platform.pickFiles();
    if (picked == null) return;
    String filename = picked.files.single.name!;
    final originalPath = picked.files.single.path!;
    if (!filename.endsWith('.db')) {
      QsHud.showToast(TextKey.errorFile.tr);
      return;
    }
    //lastBackupFile 要拷贝到本地
    final backupDir = await getApplicationDocumentsDirectory();
    final localPath = p.join(backupDir.path, filename);
    final copiedFile = await File(originalPath).copy(localPath);

    // 更新全局引用（如果你需要这个变量保留原路径）
    lastBackupFile = copiedFile;
    final baseName = p.basenameWithoutExtension(filename);
    final nameText = baseName.replaceFirst('stocknotes_', '');
    saveToDateSourceList(nameText);
    await setDbDateSource(copiedFile.path);
  }

  Future<void> saveToDateSourceList(String nameText,
      {bool isReplace = false}) async {
    if (lastBackupFile == null ||
        !(await lastBackupFile!.exists()) ||
        nameText.isEmpty) {
      QsHud.showToast(TextKey.noData.tr);
      return;
    }
    final tempDateSourceList = <Map<String, dynamic>>[].obs;
    tempDateSourceList.assignAll(dateSourceList.value);
    if (tempDateSourceList.isEmpty) {
      tempDateSourceList.add({
        'name': nameText,
        'path': lastBackupFile!.path,
      });
    } else if (isReplace) {
      for (var item in tempDateSourceList) {
        if (item['name'] == nameText) {
          item['path'] = lastBackupFile!.path;
          break;
        }
      }
    } else {
      bool isHasSomeName = false;
      isHasSomeName =
          tempDateSourceList.any((element) => element['name'] == nameText);
      if (isHasSomeName) {
        QsHud.showThreeBtnDialog(
            title: TextKey.tongming.tr,
            content: "",
            onFirst: () {},
            onSecond: () {
              saveToDateSourceList(nameText, isReplace: true);
            },
            onThree: () {
              nameText = nameText + "1";
              saveToDateSourceList(nameText);
            },
            firstText: TextKey.quxiao.tr,
            secondText: TextKey.tihuan.tr,
            threeText: TextKey.xinzen.tr);
        return;
      }
      tempDateSourceList.insert(0, {
        'name': nameText,
        'path': lastBackupFile!.path,
      });
    }
    QsCache.set("dateSourceListKey", tempDateSourceList);
    QsCache.set("selectedDateSourceKey", nameText);
    loadSelDateSource();
    dateSourceList.value = tempDateSourceList;
  }

  Future<void> shareBackup() async {
    if (lastBackupFile == null || !(await lastBackupFile!.exists())) {
      QsHud.showToast(TextKey.noFile.tr);
      return;
    }

    final params = ShareParams(
      text: TextKey.fileShare.tr,
      files: [XFile(lastBackupFile!.path)],
    );

    final result = await SharePlus.instance.share(params);
    // if (result.status == ShareResultStatus.success) {
    // }
  }

  void clickSelectedDateSource(String? value) {
    if (selectedDateSource.value == value) {
      return;
    }
    QsCache.set("selectedDateSourceKey", value!);
    loadSelDateSource();
    refresh();
    selDateSource();
  }

  void clickCellEdit(Map<String, dynamic> item) {
    showEditDialog(item);
  }

  Future<void> clickCellDelete(Map<String, dynamic> item) async {
    if (item['name'] == selectedDateSource.value) {
      QsHud.showToast(TextKey.danqianxuanzhongsjybnsc.tr);
      return;
    }
    //要删除文件 item['path']
    final file = File(item['path']);
    if (await file.exists()) {
      await file.delete();
      QsHud.showToast(TextKey.delete.tr + TextKey.success.tr);
    }
    dateSourceList.removeWhere((element) => element['name'] == item['name']);
    QsCache.set("dateSourceListKey", dateSourceList);
    refresh();
  }

  void showEditDialog(Map<String, dynamic> item) {
    TextEditingController textController = TextEditingController();
    textController.text = item['name'];
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
                TextKey.gengaimingzi.tr,
                style: TextStyle(fontSize: 18),
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
              var inputText = textController.text;
              if (inputText.isEmpty) {
                QsHud.showToast(TextKey.qingshuru.tr);
                return;
              } else {
                QsHud.dismiss();
                if (inputText == item['name']) {
                  return;
                }
                if (selectedDateSource.value == item['name']) {
                  QsCache.set("selectedDateSourceKey", inputText);
                  loadSelDateSource();
                }
                //更新
                item['name'] = inputText;
                QsCache.set("dateSourceListKey", dateSourceList.value);
                dateSourceList.refresh();
                refresh();
              }
            },
            child: Text(TextKey.queding.tr),
          ),
        ],
      ),
    );
  }

  //todo:切换数据库还要研究下
  Future<void> setDbDateSource(String filename) async {
    print(filename);
    await db.close();
    QsHud.showLoading(message: TextKey.qiehuanshujuzhong.tr); //速度太快，没出现加载
    final backupDb = sqlite3.open(filename);
    final tempPath = await getTemporaryDirectory();
    final tempDb = p.join(tempPath.path, 'import.db');
    backupDb
      ..execute('VACUUM INTO ?', [tempDb])
      ..dispose();
    final tempDbFile = File(tempDb);
    await tempDbFile.copy((await databaseFile).path);
    await tempDbFile.delete();
    QsHud.showToast(TextKey.qiehuanshujuzhong.tr +
        selectedDateSource.value +
        TextKey.success.tr);
  }

  Future<void> selDateSource() async {
    for (var item in dateSourceList.value) {
      if (item['name'] == selectedDateSource.value) {
        await setDbDateSource(item['path']);
      }
    }
  }
}
