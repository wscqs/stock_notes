import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/langs/text_key.dart';

import '../../../../common/database/database.dart';
import '../../../routes/app_pages.dart';
import '../../base/base_Controller.dart';

class HomestockController extends BaseController
    with GetTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  final query = "".obs;

  late var slidableContexts = <BuildContext>[];

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
  final db = Get.find<AppDatabase>();
  List<String> order = [
    TextKey.all.tr,
    TextKey.collect.tr,
    TextKey.delete.tr,
  ];
  final selectedOrderIndex = 0.obs;

  @override
  Future<void> onInit() async {
    // slidableController = SlidableController(this);
    super.onInit();
    getDatas();
    // filteredItems.value = items; // 默认显示所有项目

    // 初始化回调，在这里绑定 refreshAppui 方法
    // eventBuscallbackrefreshAppui = (arg) {
    //   refreshAppui();
    // };
  }

  Future<void> getDatas() async {
    if (selectedOrderIndex.value == 0) {
      dbItems.value = await db.getStockItemsOnHome();
    } else if (selectedOrderIndex.value == 1) {
      dbItems.value = await db.getStockItemsOnHomeWithCollect();
    } else if (selectedOrderIndex.value == 2) {
      dbItems.value = await db.getStockItemsOnHomeWithDelete();
    }
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
    order = [
      TextKey.all.tr,
      TextKey.collect.tr,
      TextKey.delete.tr,
    ];
    selectedOrderIndex.refresh();
    super.onResume();
    getDatas();
  }

  @override
  void onPause() {
    cancelUIoP();
    super.onPause();
  }

  //取消一些 UI 页面操作
  void cancelUIoP() {
    // Slidable.of(Get.context!)
    //     ?.close(); //跳到别的页面关闭。无效。就是 context获取的不对，别的方法尝试，无解决。
    //关闭左滑
    for (var slidableContexts in slidableContexts) {
      Slidable.of(slidableContexts)?.close();
    }
    FocusScope.of(Get.context!).unfocus(); // 关闭键盘
  }

  void clickMore() {
    final database = AppDatabase();
    Navigator.of(Get.context!)
        .push(MaterialPageRoute(builder: (context) => DriftDbViewer(database)));
  }

  void filterItems(String query) {
    this.query.value = query;
    var filterItems = <StockItem>[];
    if (query.isEmpty) {
      filterItems = dbItems;
    } else {
      filterItems = dbItems
          .where((item) =>
              item.name.contains(query) || item.code.contains(query)) // 搜索逻辑
          .toList();
    }
    // Get.context 不对，页面初始化后赋值
    slidableContexts =
        List.generate(filterItems.length, (index) => Get.context!);
    items.value = filterItems;
  }

  void pushDetailPage(StockItem item) {
    Get.toNamed(Routes.STOCKEDIT, arguments: item.copyWith());
  }

  clickSearchClose() {
    searchController.clear();
    getDatas();
  }

  //只是到历史记录
  void clickOpDelete(StockItem item) {
    db.updateStockWithOp(item.copyWith(opDelete: true));
    getDatas();
  }

  //本地删除
  void clickDbDelete(StockItem item) {
    db.deleteStock(item);
    getDatas();
  }

  void clickOpTop(StockItem item) {
    db.updateStockWithOp(item.copyWith(opTop: !item.opTop));
    getDatas();
  }

  void clickOpCollect(StockItem item) {
    db.updateStockWithOp(item.copyWith(opCollect: !item.opCollect));
    getDatas();
  }

  void clickOpRestore(StockItem item) {
    db.updateStockWithOp(item.copyWith(opDelete: false));
    getDatas();
  }
}
