import 'dart:convert';
import 'dart:io' as io show Directory, File;

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart' hide Value; //Value drift有用
import 'package:path/path.dart' as path;
import 'package:stock_notes/common/langs/text_key.dart';
import 'package:stock_notes/utils/qs_hud.dart';

import '../../../../common/database/database.dart';

class NoteeditController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final QuillController quillController = () {
    return QuillController.basic(
        config: QuillControllerConfig(
      clipboardConfig: QuillClipboardConfig(
        enableExternalRichPaste: true,
        onImagePaste: (imageBytes) async {
          if (kIsWeb) {
            // Dart IO is unsupported on the web.
            return null;
          }
          // Save the image somewhere and return the image URL that will be
          // stored in the Quill Delta JSON (the document).
          final newFileName =
              'image-file-${DateTime.now().toIso8601String()}.png';
          final newPath = path.join(
            io.Directory.systemTemp.path,
            newFileName,
          );
          final file = await io.File(
            newPath,
          ).writeAsBytes(imageBytes, flush: true);
          return file.path;
        },
      ),
    ));
  }();
  final FocusNode editorFocusNode = FocusNode();
  final ScrollController editorScrollController = ScrollController();

  final localData = Rxn<NoteItem>();
  final isLocalData = false.obs;

  final isEditing = false.obs;

  bool canPop = false; // 控制是否允许返回。true不拦截，false 才能进入handlePop判断
  Future<bool> handlePop() async {
    if (isLocalData.value) {
      final localContent = localData.value?.content;
      final localTitle = localData.value?.title!;
      if (localTitle == titleController.text &&
          localContent != null &&
          localContent.isNotEmpty) {
        final localDocContent =
            Document.fromJson(jsonDecode(localContent)).toPlainText();
        final currentDocContent = quillController.document.toPlainText();
        if (localDocContent == currentDocContent) {
          return true;
        }
      }
    } else {
      String content = quillController.document.toPlainText().trim();
      if (titleController.text.isEmpty && content.length == 0) return true;
    }
    // 弹出二次确认对话框
    final confirm = await showDialog<bool>(
      context: Get.context!,
      // barrierDismissible: false,
      builder: (context) => AlertDialog(
        // title: const Text('是否保存更改?'),
        content: Padding(
          padding: const EdgeInsets.only(left: 4, top: 4),
          child: Text(TextKey.shifoubaocungenggai.tr,
              style: TextStyle(fontSize: 16)),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); //第一个关闭Dialog
              Get.back();
            },
            child: Text(TextKey.bu.tr + TextKey.baocun.tr),
          ),
          TextButton(
            onPressed: () {
              save();
              Get.back();
              Get.back();
            },
            child: Text(TextKey.baocun.tr),
          ),
        ],
      ),
    );
    return false;
  }

  @override
  void onInit() {
    super.onInit();
    editorFocusNode.addListener(() {
      if (editorFocusNode.hasFocus) {
        print("Editor is focused (editing).");
        isEditing.value = true;
      } else {
        print("Editor is not focused.");
        isEditing.value = false;
      }
    });
    localData.value = Get.arguments;
    if (localData.value != null) {
      isLocalData.value = true;
      _dealHasLocalDataRefreshUI();
    } else {
      //新建
      Future.delayed(500.milliseconds, () {
        editorFocusNode.requestFocus();
      });
    }
  }

  void _dealHasLocalDataRefreshUI() {
    titleController.text = localData.value?.title ?? "";
    final content = localData.value?.content;
    if (content != null && content.isNotEmpty) {
      quillController.document = Document.fromJson(jsonDecode(content));
      // quillController.readOnly = true;
    }
  }

  @override
  void onClose() {
    quillController.dispose();
    editorScrollController.dispose();
    editorFocusNode.dispose();
    super.onClose();
  }

  Future<void> save() async {
    //键盘隐藏
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    final db = Get.find<AppDatabase>();
    String title = titleController.text;
    if (title.isEmpty) {
      String content = quillController.document.toPlainText();
      if (content.isEmpty || content.trim().isEmpty) {
        QsHud.showToast(TextKey.shuruneirongtishi.tr);
        return;
      } else {
        //标题赋值 content 前 18 个字符
        if (content.length > 18) {
          title = content.substring(0, 18);
        } else {
          title = content;
        }
      }
    }
    title = title.trim();
    final deltaJson = quillController.document.toDelta().toJson();
    final encodedContent = jsonEncode(deltaJson);
    NoteItemsCompanion itemsCompanion =
        NoteItemsCompanion.insert(title: title, content: Value(encodedContent));
    if (localData.value != null) {
      //localData 更新
      NoteItemsCompanion itemUpdate = itemsCompanion.copyWith(
        id: Value(localData.value!.id),
      );
      db.addNoteOnConflictUpdate(itemUpdate);
    } else {
      db.addNote(itemsCompanion);
    }
    QsHud.showToast(TextKey.baocun.tr + TextKey.success.tr);
    Get.back();
  }
}
