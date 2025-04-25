import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:stock_notes/common/database/database.dart';
import 'package:stock_notes/utils/qs_hud.dart';

import '../../../../common/langs/text_key.dart';

class TagseditController extends GetxController {
  final db = Get.find<AppDatabase>();
  late StockItem stockItem;

  final selTags = <StockItemTag>[].obs;
  final tags = <StockItemTag>[].obs;
  final tagNameController = TextEditingController();
  final tagNameControllerFocusNode = FocusNode();

  List<String> opBtns = [
    TextKey.edit.tr,
    TextKey.delete.tr,
  ];

  @override
  Future<void> onInit() async {
    super.onInit();
    stockItem = Get.arguments;
    // print(stockItem);
    getData();
  }

  Future<void> getData() async {
    tags.value = await db.getStockItemTags();
    var stockTags = await db.getStockTagsByStockItemId(stockItem.id);
    final linkedTagIds = stockTags.map((t) => t.tagId).toSet();
    var tempSelectTags = <StockItemTag>[];
    for (var tag in tags.value) {
      if (linkedTagIds.contains(tag.id)) {
        tempSelectTags.add(tag);
      }
    }
    selTags.assignAll(tempSelectTags);
    tags.refresh();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onTapSelTag(StockItemTag item) {
    if (selTags.contains(item)) {
      selTags.remove(item);
    } else {
      selTags.add(item);
    }
  }

  void createTag() {
    updateTag();
  }

  void updateTag({StockItemTag? item}) {
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

  Future<void> updateTagToDb({StockItemTag? item}) async {
    StockItemTagsCompanion itemCompanion = StockItemTagsCompanion.insert(
      name: tagNameController.text,
    );
    if (item != null) {
      if (item.name == tagNameController.text) {
        //没改动保存直接关闭
        QsHud.dismiss();
        return;
      }
      if (await isHasItem(tagNameController.text)) return;
      StockItemTagsCompanion itemUpdate = itemCompanion.copyWith(
        id: Value(item!.id),
      );
      db.addStockItemTagOnConflictUpdate(itemUpdate);
    } else {
      if (await isHasItem(tagNameController.text)) return;
      db.addStockItemTag(itemCompanion);
    }
    getData();
    QsHud.dismiss();
  }

  Future<bool> isHasItem(String name) async {
    StockItemTag? hasItem = await db.getStockItemTag(name);
    if (hasItem != null) {
      QsHud.showToast(TextKey.biaoqianmingyicunzai.tr);
      return true;
    }
    return false;
  }

  // 标签与股票关系保存
  void save() {
    db.updateStockTagsByStockItemId(stockItem.id, selTags);
    Get.back();
  }

  void onTapOp(String s, StockItemTag item) {
    if (s == TextKey.edit.tr) {
      updateTag(item: item);
    } else if (s == TextKey.delete.tr) {
      QsHud.showConfirmDialog(
          title: TextKey.querengdelete.tr,
          content: "",
          onConfirm: () {
            db.deleteStockItemTag(item);
            getData();
          });
    }
  }
}
