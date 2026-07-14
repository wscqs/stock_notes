import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:stock_notes/common/database/database.dart';
import 'package:stock_notes/utils/qs_hud.dart';

import '../../../../common/database/DatabaseManager.dart';
import '../../../../common/langs/text_key.dart';
import '../../homenote/controllers/homenote_controller.dart';
import '../../noteedit/controllers/noteedit_controller.dart';

class NoteTagseditController extends GetxController {
  final db = Get.find<DatabaseManager>().db;
  final NoteItem noteItem;

  final selTags = <NoteItemTag>[].obs;
  final tags = <NoteItemTag>[].obs;
  final tagNameController = TextEditingController();
  final tagNameControllerFocusNode = FocusNode();

  List<String> opBtns = [
    TextKey.edit.tr,
    TextKey.delete.tr,
  ];

  NoteTagseditController({required this.noteItem});

  @override
  Future<void> onInit() async {
    super.onInit();
    getData();
  }

  Future<void> getData() async {
    tags.value = await db.getNoteItemTags();
    var noteTags = await db.getNoteTagsByNoteItemId(noteItem.id);
    final linkedTagIds = noteTags.map((t) => t.tagId).toSet();
    var tempSelectTags = <NoteItemTag>[];
    for (var tag in tags.value) {
      if (linkedTagIds.contains(tag.id)) {
        tempSelectTags.add(tag);
      }
    }
    selTags.assignAll(tempSelectTags);
    tags.refresh();
  }

  @override
  void onClose() {
    tagNameController.dispose();
    tagNameControllerFocusNode.dispose();
    super.onClose();
  }

  void onTapSelTag(NoteItemTag item) {
    if (selTags.contains(item)) {
      selTags.remove(item);
    } else {
      selTags.add(item);
    }
  }

  void createTag() {
    updateTag();
  }

  void updateTag({NoteItemTag? item}) {
    var title = "";
    if (item != null) {
      tagNameController.text = item.name;
      title = TextKey.xugaibiaoqian.tr;
    } else {
      tagNameController.text = "";
      title = TextKey.xingjianbiaoqian.tr;
    }
    //可输入的文字的警告框
    QsHud.showDialog(AlertDialog(
        title: Text(title),
        content: TextField(
          focusNode: tagNameControllerFocusNode,
          controller: tagNameController,
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
              updateTagToDb(item: item);
              // QsHud.dismiss();
            },
            child: Text(TextKey.baocun.tr),
          ),
        ]));
    //延时 1 秒
    Future.delayed(const Duration(milliseconds: 100), () {
      tagNameControllerFocusNode.requestFocus();
    });
  }

  Future<void> updateTagToDb({NoteItemTag? item}) async {
    NoteItemTagsCompanion itemCompanion = NoteItemTagsCompanion.insert(
      name: tagNameController.text,
    );
    if (item != null) {
      if (item.name == tagNameController.text) {
        //没改动保存直接关闭
        QsHud.dismiss();
        return;
      }
      if (await isHasItem(tagNameController.text)) return;
      NoteItemTagsCompanion itemUpdate = itemCompanion.copyWith(
        id: Value(item!.id),
      );
      db.addNoteItemTagOnConflictUpdate(itemUpdate);
    } else {
      if (await isHasItem(tagNameController.text)) return;
      db.addNoteItemTag(itemCompanion);
    }
    getData();
    QsHud.dismiss();
  }

  Future<bool> isHasItem(String name) async {
    NoteItemTag? hasItem = await db.getNoteItemTag(name);
    if (hasItem != null) {
      QsHud.showToast(TextKey.biaoqianmingyicunzai.tr);
      return true;
    }
    return false;
  }

  // 标签与笔记关系保存
  Future<void> save() async {
    await db.updateNoteTagsByNoteItemId(noteItem.id, selTags);
    noteItem.tagList = selTags.toList();
    Get.back();
    _notifyRefresh();
  }

  void _notifyRefresh() {
    if (Get.isRegistered<HomenoteController>()) {
      Get.find<HomenoteController>().refreshItemTags(noteItem);
    }
    if (Get.isRegistered<NoteeditController>()) {
      Get.find<NoteeditController>().refreshTags();
    }
  }

  void onTapOp(String s, NoteItemTag item) {
    if (s == TextKey.edit.tr) {
      updateTag(item: item);
    } else if (s == TextKey.delete.tr) {
      QsHud.showConfirmDialog(
          title: TextKey.querengdelete.tr,
          content: "",
          onConfirm: () {
            db.deleteNoteItemTag(item);
            getData();
          });
    }
  }
}
