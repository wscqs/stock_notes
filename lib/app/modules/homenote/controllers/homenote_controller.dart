import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:stock_notes/app/modules/base/base_controller.dart';
import 'package:stock_notes/common/comment_style.dart';
import 'package:stock_notes/common/langs/text_key.dart';

import '../../../../common/database/DatabaseManager.dart';
import '../../../../common/database/database.dart';
import '../../../routes/app_pages.dart';
import '../../notetagsedit/views/notetagsedit_view.dart';
import '../../tabs/controllers/tabs_controller.dart';

class HomenoteController extends BaseController
    with GetTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  final query = "".obs;

  SlidableController? slidableController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode searchFocusNode = FocusNode();

  final dbItems = <NoteItem>[].obs;
  // List<NoteItem>
  final items = <NoteItem>[].obs; //显示的
  late var db = Get.find<DatabaseManager>().db;
  List<String> order = [
    TextKey.all.tr,
    TextKey.collect.tr,
    TextKey.delete.tr,
  ];
  final selectedOrderIndex = 0.obs;

  final tabsController = Get.find<TabsController>();
  final isOperate = false.obs;
  final selItems = <NoteItem>[].obs; //选择的items
  final customScrollController = ScrollController();

  final selTags = <NoteItemTag>[].obs;
  final tags = <NoteItemTag>[].obs;

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
      dbItems.value = await db.getNoteItemsOnHome();
    } else if (selectedOrderIndex.value == 1) {
      dbItems.value = await db.getNoteItemsOnHomeWithCollect();
    } else if (selectedOrderIndex.value == 2) {
      dbItems.value = await db.getNoteItemsOnHomeWithDelete();
    }
    dbItems.value =
        await db.getNoteItemsWithTagsByNoteItems(List.from(dbItems));
    String query = searchController.text;
    filterItems(query);
  }

  void refreshAppui() {}

  @override
  void onResume() {
    db = Get.find<DatabaseManager>().db;
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

  //取消一些 UI 页面操作
  void cancelUIoP() {
    slidableController?.close(duration: 0.milliseconds);
    searchFocusNode.unfocus(); // 关闭键盘
  }

  //是否在删除列表(删除列表有些特殊处理）
  bool isCurrentDeleteList() {
    return selectedOrderIndex.value == 2;
  }

  void clickMore() {}

  void filterItems(String query) {
    this.query.value = query;
    var filterItems = <NoteItem>[];
    if (query.isEmpty) {
      filterItems = List.from(dbItems);
    } else {
      filterItems = dbItems
          .where((item) => item.title.contains(query)) // 搜索逻辑
          .toList();
    }
    if (selTags.isNotEmpty) {
      filterItems = _updateFilterItemsWithSelTags(filterItems);
    }
    items.value = filterItems;
  }

  List<NoteItem> _updateFilterItemsWithSelTags(List<NoteItem> filterItems) {
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

  void clickCell(NoteItem item) {
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

  void longPressCell(NoteItem item) {
    if (!isOperate.value) {
      selItems.clear();
    }
    dealUIisOperate(true);
    if (selItems.contains(item)) {
    } else {
      selItems.add(item);
    }
  }

  void pushDetailPage(NoteItem item) {
    cancelUIoP();
    Get.toNamed(Routes.NOTEEDIT, arguments: item.copyWith());
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
      db.deleteNoteList(selItems);
    } else {
      var opSelItems =
          selItems.map((item) => item.copyWith(opDelete: true)).toList();
      db.updateBatchNoteWithOp(opSelItems);
    }
    dealUIisOperate(false);
    getDatas();
  }

  void clickTabOpBack() {
    dealUIisOperate(false);
  }

  void clickOpDelete(NoteItem item) {
    if (isCurrentDeleteList()) {
      //删除列表真正删除
      db.deleteNote(item);
    } else {
      db.updateNoteWithOp(item.copyWith(opDelete: true));
    }
    getDatas();
  }

  //本地删除
  void clickDbDelete(NoteItem item) {
    db.deleteNote(item);
    getDatas();
  }

  void clickOpTop(NoteItem item) {
    db.updateNoteWithOp(item.copyWith(opTop: !item.opTop));
    getDatas();
  }

  void clickOpCollect(NoteItem item) {
    db.updateNoteWithOp(item.copyWith(opCollect: !item.opCollect));
    getDatas();
  }

  void clickOpRestore(NoteItem item) {
    db.updateNoteWithOp(item.copyWith(opDelete: false));
    getDatas();
  }

  void clickPushTag(NoteItem item) {
    NoteTagseditView.show(item);
  }

  void refreshItemTags(NoteItem item) {
    final index = dbItems.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      dbItems[index].tagList = List.from(item.tagList);
    }
    filterItems(searchController.text);
    items.refresh();
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
    tags.value = await db.getNoteItemTags();
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

  Widget getSelTagItemView(NoteItemTag item) {
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

  void onTapSelTag(NoteItemTag item) {
    selTags.value.contains(item)
        ? selTags.value.remove(item)
        : selTags.value.add(item);
    selTags.refresh();
    getDatas();
    SmartDialog.dismiss(status: SmartStatus.attach);
  }

  void clickFilterClose() {
    selTags.value.clear();
    selTags.refresh();
    getDatas();
    SmartDialog.dismiss(status: SmartStatus.attach);
  }
}
