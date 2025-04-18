import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:stock_notes/app/modules/base/base_Controller.dart';
import 'package:stock_notes/common/langs/text_key.dart';

import '../../../../common/database/database.dart';
import '../../../routes/app_pages.dart';
import '../../tabs/controllers/tabs_controller.dart';

class HomenoteController extends BaseController
    with GetTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  final query = "".obs;

  late var slidableContexts = <BuildContext>[];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode searchFocusNode = FocusNode();

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

  final tabsController = Get.find<TabsController>();
  final isOperate = false.obs;
  final selItems = <StockItem>[].obs; //选择的items

  @override
  Future<void> onInit() async {
    super.onInit();
    getDatas();
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

  void refreshAppui() {}

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

  void closeDrawer() {
    if (scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(scaffoldKey.currentContext!).pop();
    }
  }

  //取消一些 UI 页面操作
  void cancelUIoP() {
    // Slidable.of(Get.context!)
    //     ?.close(); //跳到别的页面关闭。无效。就是 context获取的不对，别的方法尝试，无解决。
    // FocusScope.of(get.currentContext!).unfocus();//有一些异常
    //关闭左滑
    for (var slidableContexts in slidableContexts) {
      Slidable.of(slidableContexts)?.close();
    }
    searchFocusNode.unfocus(); // 关闭键盘
  }

  //是否在删除列表(删除列表有些特殊处理）
  bool isCurrentDeleteList() {
    return selectedOrderIndex.value == 2;
  }

  void clickMore() {}

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

  void clickCell(StockItem item) {
    if (isOperate.value) {
      if (selItems.contains(item)) {
        selItems.remove(item);
      } else {
        selItems.add(item);
      }
    } else {
      pushDetailPage(item);
    }
  }

  void longPressCell(StockItem item) {
    if (!isOperate.value) {
      selItems.clear();
    }
    dealUIisOperate(true);
    if (selItems.contains(item)) {
    } else {
      selItems.add(item);
    }
  }

  void pushDetailPage(StockItem item) {
    cancelUIoP();
    Get.toNamed(Routes.STOCKEDIT, arguments: item.copyWith());
  }

  clickSearchClose() {
    searchController.clear();
    getDatas();
  }

  void dealUIisOperate(bool isOperate) {
    this.isOperate.value = isOperate;
    this.isOperate.refresh();
    Get.find<TabsController>().isOperate.value = isOperate;
    if (!isOperate) {
      selItems.clear();
    }
  }

  void clickTabOpAllCheck() {
    selItems.addAll(items);
  }

  void clickTabOpBatchDelete() {
    if (isCurrentDeleteList()) {
      db.deleteStockList(selItems);
    } else {
      var opSelItems =
          selItems.map((item) => item.copyWith(opDelete: true)).toList();
      db.updateBatchStockWithOp(opSelItems);
    }
    dealUIisOperate(false);
    getDatas();
  }

  void clickTabOpBack() {
    dealUIisOperate(false);
  }

  void clickOpDelete(StockItem item) {
    if (isCurrentDeleteList()) {
      //删除列表真正删除
      db.deleteStock(item);
    } else {
      db.updateStockWithOp(item.copyWith(opDelete: true));
    }
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
