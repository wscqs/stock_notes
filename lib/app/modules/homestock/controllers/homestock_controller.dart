import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/database/database.dart';
import '../../base/base_Controller.dart';

class HomestockController extends BaseController {
  final TextEditingController searchController = TextEditingController();
  final query = "".obs;
  // final database = AppDatabase();
  //
  // final items = [
  //   "Apple",
  //   "Banana",
  //   "Orange",
  //   "Grapes",
  //   "Mango",
  //   "Pineapple",
  //   "Strawberry",
  //   "Blueberry"
  // ].obs;
  final dbItems = <StockItem>[].obs;
  // List<StockItem>
  final items = <StockItem>[].obs; //显示的
  final db = AppDatabase();

  @override
  Future<void> onInit() async {
    super.onInit();
    getDatas();
    // filteredItems.value = items; // 默认显示所有项目

    // 初始化回调，在这里绑定 refreshAppui 方法
    // eventBuscallbackrefreshAppui = (arg) {
    //   refreshAppui();
    // };
  }

  Future<void> getDatas() async {
    dbItems.value = await db.getStockItemsByTimeDesc();
    String query = searchController.text;
    filterItems(query);
  }

  void refreshAppui() {
    // filteredItems.value = items;
    // getDatas();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onResume() {
    super.onResume();
    getDatas();
  }

  @override
  void onPause() {
    super.onPause();
    FocusScope.of(Get.context!).unfocus(); // 关闭键盘
  }

  void clickMore() {
    final database = AppDatabase();
    Navigator.of(Get.context!)
        .push(MaterialPageRoute(builder: (context) => DriftDbViewer(database)));
  }

  void filterItems(String query) {
    this.query.value = query;
    if (query.isEmpty) {
      items.value = dbItems;
    } else {
      items.value = dbItems
          .where((item) =>
              item.name.contains(query) || item.code.contains(query)) // 搜索逻辑
          .toList();
    }
  }

  void pushDetailPage(StockItem item) {
    // Get.toNamed(Routes.STOCKEDIT, arguments: item);
    // Get.toNamed(Routes.NOTEDETAIL);
    // Get.toNamed(Routes.STOCKEDIT, arguments: item);
    db.updateStock(item);
    getDatas();
  }

  clickSearchClose() {
    searchController.clear();
    getDatas();
  }
}
