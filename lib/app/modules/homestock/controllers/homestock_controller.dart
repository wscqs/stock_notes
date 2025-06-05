import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' hide Value;
import 'package:stock_notes/common/comment_style.dart';
import 'package:stock_notes/common/https/qs_api.dart';
import 'package:stock_notes/common/langs/text_key.dart';

import '../../../../common/database/DatabaseManager.dart';
import '../../../../common/database/database.dart';
import '../../../../utils/qs_cache.dart';
import '../../../../utils/qs_hud.dart';
import '../../../routes/app_pages.dart';
import '../../base/base_Controller.dart';
import '../../tabs/controllers/tabs_controller.dart';

class HomestockController extends BaseController
    with GetTickerProviderStateMixin {
  late var db = Get.find<DatabaseManager>().db;
  final TextEditingController searchController = TextEditingController();
  final query = "".obs;

  SlidableController? slidableController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode searchFocusNode = FocusNode();

  late var dbItems = <StockItem>[];
  final items = <StockItem>[].obs; //显示的
  List<String> order = [
    TextKey.all.tr,
    TextKey.chiyou.tr,
    TextKey.collect.tr,
    TextKey.delete.tr,
  ];
  final selectedOrderIndex = 0.obs;

  final tabsController = Get.find<TabsController>();
  final isOperate = false.obs;
  final selItems = <StockItem>[].obs; //选择的items

  final selCondition = ''.obs;
  int selConditionIndex = -1; //只判断赋值selCondition
  List<String> selConditions = [
    TextKey.mangzumaimai.tr,
    TextKey.lingjinmaimai.tr
  ];

  final selectedSegment = "all".obs;
  Map<String, String> segments = <String, String>{
    "all": TextKey.all.tr,
    "bug": TextKey.buy.tr,
    "sale": TextKey.sale.tr,
  };

  final selTags = <StockItemTag>[].obs;
  final tags = <StockItemTag>[].obs;

  final customScrollController = ScrollController();

  final selectedDateSource = "".obs; //name

  @override
  Future<void> onInit() async {
    super.onInit();
    selectedDateSource.value =
        QsCache.get<String>("selectedDateSourceKey") ?? "";
    await getDatas();
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
      dbItems = await db.getStockItemsOnHomeWithBuy();
    } else if (selectedOrderIndex.value == 2) {
      dbItems = await db.getStockItemsOnHomeWithCollect();
    } else if (selectedOrderIndex.value == 3) {
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
    db = Get.find<DatabaseManager>().db;
    selectedDateSource.value =
        QsCache.get<String>("selectedDateSourceKey") ?? "";
    order = [
      TextKey.all.tr,
      TextKey.chiyou.tr,
      TextKey.collect.tr,
      TextKey.delete.tr,
    ];
    selectedOrderIndex.refresh();
    segments = <String, String>{
      "all": TextKey.all.tr,
      "bug": TextKey.buy.tr,
      "sale": TextKey.sale.tr,
    };
    selectedSegment.refresh();
    selConditions = [TextKey.mangzumaimai.tr, TextKey.lingjinmaimai.tr];
    if (selConditionIndex >= 0) {
      selCondition.value = selConditions[selConditionIndex];
      selCondition.refresh();
    }

    super.onResume();
    getDatas();
  }

  @override
  void onPause() {
    cancelUIoP();
    super.onPause();
  }

  void clickScrollToTop() {
    customScrollController.animateTo(
      0.0,
      duration: 500.milliseconds,
      curve: Curves.easeInOut,
    );
  }

  void closeDrawer() {
    if (scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(scaffoldKey.currentContext!).pop();
    }
  }

  void openDrawer() {
    if (scaffoldKey.currentState?.isDrawerOpen ?? false) {
    } else {
      //打开抽屉
      scaffoldKey.currentState?.openDrawer();
    }
  }

  void deeplinkSearch() {
    cancelUIoP();
    //延迟 1 秒
    Future.delayed(500.milliseconds, () {
      searchFocusNode.requestFocus();
    });
  }

  void deeplinkMeetBS() {
    cancelUIoP();
    selConditions = [TextKey.mangzumaimai.tr, TextKey.lingjinmaimai.tr];
    selConditionIndex = 0;
    if (selConditionIndex >= 0) {
      selCondition.value = selConditions[selConditionIndex];
      selCondition.refresh();
    }
  }

  void deeplinkNearBS() {
    cancelUIoP();
    selConditions = [TextKey.mangzumaimai.tr, TextKey.lingjinmaimai.tr];
    selConditionIndex = 1;
    if (selConditionIndex >= 0) {
      selCondition.value = selConditions[selConditionIndex];
      selCondition.refresh();
    }
  }

  //取消一些 UI 页面操作
  void cancelUIoP() {
    slidableController?.close(
        duration: 0.milliseconds); //还有点细节，里面动画控制器已经自己销毁了，不出问题就这样
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
      if (isShowLoading) {
        QsHud.showToast(TextKey.noData.tr);
      }
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
              code: Value(item.code),
              // where 条件用
              name: Value(serItem.name!),
              currentPrice: Value(serItem.currentPrice),
              // 要更新的字段
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

    if (selTags.isNotEmpty) {
      filterItems = _updateFilterItemsWithSelTags(filterItems);
    }
    items.value = filterItems;
  }

  List<StockItem> _updateFilterItemsWithSelCondition(List<StockItem> list) {
    if (selCondition.value == TextKey.mangzumaimai.tr) {
      ConditionStatus status = ConditionStatus.targetBoth;
      if (selectedSegment.value == 'bug') {
        status = ConditionStatus.targetBuy;
      } else if (selectedSegment.value == 'sale') {
        status = ConditionStatus.targetSell;
      }
      list = list.where((item) => item.homeConditionTarget(status)).toList();
    } else if (selCondition.value == TextKey.lingjinmaimai.tr) {
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

  void clickOpBuy(StockItem item) {
    db.updateStockWithOp(item.copyWith(opBuy: !item.opBuy));
    getDatas();
  }

  void clickOpRestore(StockItem item) {
    db.updateStockWithOp(item.copyWith(opDelete: false));
    getDatas();
  }

  void onTapSelCondition(String name) {
    if (selCondition.value == name) {
      selCondition.value = '';
      selConditionIndex = -1;
    } else {
      selCondition.value = name;
      selConditionIndex = selConditions.indexOf(name);
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

  //标签过滤功能
  Future<void> clickFilterPop(BuildContext context) async {
    await getTagsData();
    SmartDialog.showAttach(
      targetContext: context,
      maskColor: Colors.transparent,
      alignment: Alignment.bottomCenter,
      builder: (_) {
        return getTagsPopWidget();
      },
    );
  }

  Future<void> getTagsData() async {
    tags.value = await db.getStockItemTags();
  }

  Widget getTagsPopWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      color: Get.theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          kSpaceH(8),
          Text(
            TextKey.biaoqian.tr,
            style: TextStyle(
                fontSize: 16,
                color: Get.theme.colorScheme.onSurface.withValues(alpha: 0.8)),
          ),
          kSpaceH(12),
          Obx(() {
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: tags.map((tag) {
                return getSelTagItemView(tag);
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget getSelTagItemView(StockItemTag item) {
    return GestureDetector(
      onTap: () {
        onTapSelTag(item);
      },
      child: Container(
        padding: EdgeInsets.only(left: 12, top: 4, bottom: 4, right: 12),
        decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(4)),
        child: Text(
          item.name,
          style: TextStyle(
            color: selTags.value.contains(item)
                ? Colors.red
                : Get.theme.colorScheme.onSurface.withValues(alpha: 0.5),
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  void onTapSelTag(StockItemTag item) {
    selTags.value.contains(item)
        ? selTags.value.remove(item)
        : selTags.value.add(item);
    // tags.refresh();
    selTags.refresh();
    getDatas();
    SmartDialog.dismiss(status: SmartStatus.attach);
  }

  void clickFilterClose() {
    selCondition.value = '';
    selConditionIndex = -1;
    selectedSegment.value = "all";
    selTags.value.clear();
    selTags.refresh();
    selCondition.refresh();
    getDatas();
    SmartDialog.dismiss(status: SmartStatus.attach);
  }

  List<StockItem> _updateFilterItemsWithSelTags(List<StockItem> filterItems) {
    if (selTags.value.isEmpty) {
      return filterItems;
    } else {
      return filterItems.where((item) {
        return item.tagList.any((tag) {
          return selTags.value.contains(tag);
        });
      }).toList();
    }
  }
}
