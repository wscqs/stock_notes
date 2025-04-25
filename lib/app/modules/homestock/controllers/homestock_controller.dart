import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart' hide Value;
import 'package:stock_notes/common/https/qs_api.dart';
import 'package:stock_notes/common/langs/text_key.dart';

import '../../../../common/database/database.dart';
import '../../../../utils/qs_hud.dart';
import '../../../routes/app_pages.dart';
import '../../base/base_Controller.dart';
import '../../tabs/controllers/tabs_controller.dart';

class HomestockController extends BaseController
    with GetTickerProviderStateMixin {
  final db = Get.find<AppDatabase>();
  final TextEditingController searchController = TextEditingController();
  final query = "".obs;

  late var slidableContexts = <BuildContext>[];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode searchFocusNode = FocusNode();

  late var dbItems = <StockItem>[];
  final items = <StockItem>[].obs; //显示的
  List<String> order = [
    TextKey.all.tr,
    TextKey.collect.tr,
    TextKey.delete.tr,
  ];
  final selectedOrderIndex = 0.obs;

  final tabsController = Get.find<TabsController>();
  final isOperate = false.obs;
  final selItems = <StockItem>[].obs; //选择的items

  final selCondition = ''.obs;
  List<String> selConditions = ['满足买卖', '临近买卖'];

  final selectedSegment = "all".obs;
  final Map<String, String> segments = <String, String>{
    "all": '所有',
    "bug": '买',
    "sale": '卖',
  };

  @override
  Future<void> onInit() async {
    super.onInit();
    getDatas();
    dbSyncSerData(isShowLoading: false);
    // 初始化回调，在这里绑定 refreshAppui 方法
    // eventBuscallbackrefreshAppui = (arg) {
    //   refreshAppui();
    // };
  }

  Future<void> getDatas() async {
    if (selectedOrderIndex.value == 0) {
      dbItems = await db.getStockItemsOnHome();
    } else if (selectedOrderIndex.value == 1) {
      dbItems = await db.getStockItemsOnHomeWithCollect();
    } else if (selectedOrderIndex.value == 2) {
      dbItems = await db.getStockItemsOnHomeWithDelete();
    }
    await _updateDbItemsWithSetTags();
    _updateDbItemsWithSetCondition();
    String query = searchController.text;
    filterItems(query);
  }

  _updateDbItemsWithSetTags() async {
    dbItems = await db.getStockItemsWithTagsByStockItems(dbItems);
  }

  void refreshAppui() {}

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
      Slidable.of(slidableContexts)?.close(duration: 0.milliseconds);
    }
    searchFocusNode.unfocus(); // 关闭键盘
  }

  //是否在删除列表(删除列表有些特殊处理）
  bool isCurrentDeleteList() {
    return selectedOrderIndex.value == 2;
  }

  // void clickMore() {
  //   final database = AppDatabase();
  //   Navigator.of(Get.context!)
  //       .push(MaterialPageRoute(builder: (context) => DriftDbViewer(database)));
  // }

  Future<void> clickRefresh() async {
    dbSyncSerData(isShowLoading: true);
  }

  Future<void> dbSyncSerData({bool isShowLoading = false}) async {
    //db里面数据拿到所有的 code 数据数组
    var stockCodes = dbItems.map((item) => item.code).toList();
    if (stockCodes.isEmpty) {
      return;
    }
    if (isShowLoading) {
      QsHud.showLoading();
    }
    var qTRequest =
        await QsApi.instance().requestStockData(stockCodes: stockCodes);
    // print(qTRequest.toString());
    if (qTRequest != null && qTRequest.length > 0) {
      for (var item in dbItems) {
        for (var serItem in qTRequest) {
          if (item.code == serItem.code) {
            final updatedItem = StockItemsCompanion(
              code: Value(item.code), // where 条件用
              name: Value(serItem.name!),
              currentPrice: Value(serItem.currentPrice), // 要更新的字段
              pbRatio: Value(serItem.pbRatio),
              totalMarketCap: Value(serItem.totalMarketCap),
              peRatioTtm: Value(serItem.peRatioTtm),
            );
            db.updateStock(updatedItem, item.code);
          }
        }
      }
    }
    if (isShowLoading) {
      QsHud.dismiss();
    }
    getDatas();
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

    if (selCondition.isNotEmpty) {
      filterItems = _updateFilterItemsWithSelCondition(filterItems);
    }
    // Get.context 不对，页面初始化后赋值
    slidableContexts =
        List.generate(filterItems.length, (index) => Get.context!);
    items.value = filterItems;
  }

  List<StockItem> _updateFilterItemsWithSelCondition(List<StockItem> list) {
    if (selCondition.value == '满足买卖') {
      ConditionStatus status = ConditionStatus.targetBoth;
      if (selectedSegment.value == 'bug') {
        status = ConditionStatus.targetBuy;
      } else if (selectedSegment.value == 'sale') {
        status = ConditionStatus.targetSell;
      }
      list = list.where((item) => item.homeConditionTarget(status)).toList();
    } else if (selCondition.value == '临近买卖') {
      ConditionStatus status = ConditionStatus.nearBoth;
      if (selectedSegment.value == 'bug') {
        status = ConditionStatus.nearBuy;
      } else if (selectedSegment.value == 'sale') {
        status = ConditionStatus.nearSell;
      }
      list = list.where((item) => item.homeConditionNear(status)).toList();
    }
    return list;
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

  void onTapSelCondition(String name) {
    if (selCondition.value == name) {
      selCondition.value = '';
    } else {
      selCondition.value = name;
    }
    selectedSegment.value = "all";
    getDatas();
  }

  void _updateDbItemsWithSetCondition() {
    for (final item in dbItems) {
      item.setConditions();
    }
  }

  void onTapSelConditionSegment(String value) {
    selectedSegment.value = value;
    getDatas();
  }

  void clickPushTag(StockItem item) {
    Get.toNamed(Routes.TAGSEDIT, arguments: item);
  }
}
