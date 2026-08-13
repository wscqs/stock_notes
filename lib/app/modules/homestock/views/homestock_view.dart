import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:stock_notes/common/comment_style.dart';
import 'package:stock_notes/common/langs/text_key.dart';
import 'package:stock_notes/common/widget/keep_alive_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../common/database/database.dart';
import '../../../../common/widget/qs_empty_view.dart';
import '../../../../utils/qs_hud.dart';
import '../../../routes/app_pages.dart';
import '../../somewidget/homedrawer_page/view.dart';
import '../controllers/homestock_controller.dart';

class HomestockView extends GetView<HomestockController> {
  const HomestockView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.cancelUIoP();
      },
      child: KeepAliveWidget(
        child: Scaffold(
          key: controller.scaffoldKey,
          appBar: AppBar(
            title: Text(TextKey.gupiao.tr),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(
                  RemixIcons.exchange_box_line,
                  // size: 24,
                ),
                tooltip: TextKey.jiaoyi.tr,
                onPressed: () => Get.toNamed(Routes.TRADELIST),
              ),
              IconButton(
                  onPressed: () {
                    controller.clickRefresh();
                  },
                  icon: Icon(
                    Icons.replay_circle_filled_rounded,
                    size: 28,
                  )),
            ],
            // bottom: buildSectionTop(),
          ),
          body: _visibilityDetectorWithCustomScrollView(context),
          drawer: HomedrawerPage(),
        ),
      ),
    );
  }

  CustomScrollView buildCustomScrollView(BuildContext context) {
    return CustomScrollView(
      controller: controller.customScrollController,
      slivers: [
        SliverFloatingHeader(child: buildSectionTop()),
        SliverPadding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          sliver: Obx(() {
            return controller.items.isEmpty
                ? SliverFillRemaining(
                    child: QsEmptyView(message: TextKey.noData.tr),
                  )
                : listViewAsSliver(); // 你需要把 listView() 改成返回 SliverList
          }),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ),
      ],
    );
  }

  PreferredSize buildSectionTop() {
    return PreferredSize(
      preferredSize: Size.fromHeight(76 + 30 + 38 + 4), // 包含标签 tab 栏高度
      child: Obx(() {
        final hasTags = controller.tags.isNotEmpty;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Get.theme.colorScheme.surface,
              padding:
                  EdgeInsets.only(left: 16, right: 16, bottom: 12, top: 12),
              child: Row(
                children: [
                  IgnorePointer(
                    ignoring: controller.isOperate.value,
                    child: Opacity(
                      opacity: controller.isOperate.value ? 0.8 : 1,
                      child: buildHotPopViews(),
                    ),
                  ),
                  kSpaceW(8),
                  Expanded(child: buildTopSearch()),
                ],
              ),
            ),
            Container(
              color: Get.theme.colorScheme.surface,
              padding: EdgeInsets.only(left: 20, right: 0, bottom: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      alignment: WrapAlignment.start,
                      children: controller.selConditions
                          .map((name) => getSelConditionItemView(name))
                          .toList(),
                    ),
                  ),
                  if (controller.selCondition.value.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 0, right: 0),
                      child: buildConditionSegmentedControl(),
                    ),
                  if (controller.selCondition.value.isNotEmpty ||
                      controller.selTags.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 0),
                      child: buildFilterCloseBtn(controller: controller),
                    ),
                  buildFilterBtn(),
                ],
              ),
            ),
            // 标签滚动 tab 栏
            if (hasTags) buildScrollableTagTabBar(),
          ],
        );
      }),
    );
  }

  /// 构建标签滚动 tab 栏（参考雪球分组 tab 样式）
  Widget buildScrollableTagTabBar() {
    return Container(
      color: Get.theme.colorScheme.surface,
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 38,
              child: ListView.builder(
                controller: controller.tagTabScrollController,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 8),
                itemCount: controller.tags.length + 1, // +1 for "全部"
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // "全部" tab：无选中或多选时高亮
                    final isSelected = controller.selTags.isEmpty ||
                        controller.selTags.length > 1;
                    final key = controller.tagTabItemKeys
                        .putIfAbsent('all', () => GlobalKey());
                    return _buildTabItem(
                      key: key,
                      label: TextKey.all.tr,
                      isSelected: isSelected,
                      onTap: () => controller.onTapTagTab(null),
                    );
                  }
                  final tag = controller.tags[index - 1];
                  // 多选时单个标签不高亮
                  final isSelected = controller.selTags.length == 1 &&
                      controller.selTags.contains(tag);
                  final key = controller.tagTabItemKeys
                      .putIfAbsent(tag.id.toString(), () => GlobalKey());
                  return _buildTabItem(
                    key: key,
                    label: tag.name,
                    isSelected: isSelected,
                    onTap: () => controller.onTapTagTab(tag),
                  );
                },
              ),
            ),
          ),
          // 右侧固定管理按钮
          _buildTagManageBtn(),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required GlobalKey key,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        key: key,
        padding: EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: isSelected ? 15 : 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    // ? Get.theme.colorScheme.primary.withValues(alpha: 0.9)
                    ? Get.theme.colorScheme.onSurface.withValues(alpha: 0.8)
                    : Get.theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            SizedBox(height: 4),
            Container(
              width: 8,
              height: 2,
              decoration: BoxDecoration(
                color: isSelected
                    ? Get.theme.colorScheme.onSurface.withValues(alpha: 0.8)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 右侧固定管理按钮（参考雪球）
  Widget _buildTagManageBtn() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        TagManagerDialog.show(controller);
      },
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 12, bottom: 4),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.menu_outlined,
              size: 16,
              color: Get.theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ],
        ),
      ),
    );
  }

  Builder buildFilterBtn() {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: InkWell(
            onTap: () {
              controller.clickFilterPop(context);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Icon(
                Icons.filter_list_outlined,
                color: Get.theme.colorScheme.onSurface.withValues(alpha: 0.8),
                size: 18,
              ),
            )),
      );
    });
  }

  CupertinoSegmentedControl<String> buildConditionSegmentedControl() {
    return CupertinoSegmentedControl<String>(
      selectedColor: Colors.red,
      disabledColor: Colors.white,
      unselectedColor: Colors.grey.withValues(alpha: 0.15),
      borderColor: Colors.grey.withValues(alpha: 0.15),
      onValueChanged: (String value) {
        controller.onTapSelConditionSegment(value);
      },
      padding: EdgeInsets.zero,
      children: {
        for (var entry in controller.segments.entries)
          entry.key: Padding(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            child: Text(
              entry.value,
              style: TextStyle(
                color: controller.selectedSegment.value == entry.key
                    ? Colors.red
                    : Colors.grey,
                fontSize: 12,
              ),
            ),
          )
      },
    );
  }

  Widget getSelConditionItemView(String name) {
    return InkWell(
      onTap: () {
        controller.onTapSelCondition(name);
      },
      child: Container(
        padding: EdgeInsets.only(left: 8, top: 4, bottom: 4, right: 8),
        decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(4)),
        child: Text(
          name,
          style: TextStyle(
              color: name == controller.selCondition.value
                  ? Colors.red
                  : Get.theme.colorScheme.onSurface.withValues(alpha: 0.5),
              fontSize: 13,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  DropdownButtonHideUnderline buildHotPopViews() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        // openWithLongPress: true,
        hint: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.order[controller.selectedOrderIndex.value],
              ),
              Icon(
                Icons.arrow_drop_down,
                size: 20,
              )
            ],
          ),
        ),
        items: controller.order
            .map((String item) => DropdownItem<String>(
                  value: item,
                  height: 44,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ))
            .toList(),
        onChanged: (String? value) {
          controller.selectedOrderIndex.value =
              controller.order.indexOf(value!);
          controller.getDatas();
        },
        iconStyleData: IconStyleData(
          iconSize: 0,
        ),
        buttonStyleData: ButtonStyleData(
          padding: EdgeInsets.only(left: 4, right: 4),
          height: 44,
          width: 72,
        ),
        dropdownStyleData: DropdownStyleData(
          width: 80,
          offset: const Offset(-8, 0),
        ),
      ),
    );
  }

  Widget listViewAsSliver() {
    return SlidableAutoCloseBehavior(
      child: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => HomeStockCell(
            item: controller.items[index],
            index: index,
          ),
          childCount: controller.items.length,
        ),
      ),
    );
  }

  Widget buildTopSearch() {
    return TextField(
      focusNode: controller.searchFocusNode,
      controller: controller.searchController,
      onChanged: controller.filterItems, // 监听输入内容
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 2),
        prefixIconConstraints:
            BoxConstraints(minWidth: 40, minHeight: 40), // 限制Icon尺寸
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12, right: 8), // 控制Icon和文本的距离
          child: Icon(Icons.search, size: 20),
        ),
        hintText: "${TextKey.search.tr} ...",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        suffixIcon: controller.query.value.isNotEmpty
            ? SizedBox(
                width: 44,
                height: 44,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: controller.clickSearchClose,
                ),
              )
            : null,
      ),
    );
  }

  // Widget _obx() => Obx(() => _visibilityDetector());

  Widget _visibilityDetectorWithCustomScrollView(BuildContext context) {
    return VisibilityDetector(
        key: Key("HomestockViewVisibilityKey"),
        onVisibilityChanged: (VisibilityInfo info) {
          if (info.visibleFraction == 0) {
            // print('Widget is not visible');
            controller.onPause();
          } else if (info.visibleFraction == 1) {
            // print('Widget is fully visible');
            controller.onResume();
          } else {
            // print('Widget is partially visible');
          }
        },
        child: buildCustomScrollView(context));
  }
}

class buildFilterCloseBtn extends StatelessWidget {
  const buildFilterCloseBtn({
    super.key,
    required this.controller,
  });

  final HomestockController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: InkWell(
          onTap: () {
            controller.clickFilterClose();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Icon(
              Icons.filter_list_off_outlined,
              size: 18,
              color: Colors.blueAccent,
            ),
          )),
    );
  }
}

class HomeStockCell extends StatefulWidget {
  final int index;
  final StockItem item;

  HomeStockCell({
    super.key,
    required this.item,
    required this.index,
  });

  @override
  State<HomeStockCell> createState() => _HomeStockCellState();
}

class _HomeStockCellState extends State<HomeStockCell>
    with TickerProviderStateMixin {
  final controller = Get.find<HomestockController>();
  // 将控制器声明在 State 中
  late final SlidableController slidableController;

  @override
  void initState() {
    super.initState();
    // 在 initState 中初始化控制器（仅一次）
    slidableController = SlidableController(this);
  }

  @override
  void dispose() {
    // 释放控制器资源
    slidableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (event) {
        controller.slidableController = slidableController;
      },
      child: Slidable(
        key: ValueKey(widget.item.id),
        controller: slidableController,
        endActionPane: buildActionPane(),
        child: Builder(builder: (context) {
          return GestureDetector(
            onLongPress: () {
              controller.longPressCell(widget.item);
            },
            child: Container(
              margin: const EdgeInsets.only(top: 4, bottom: 8),
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Get.theme.colorScheme.outlineVariant
                      .withValues(alpha: 0.2),
                  width: 0.5,
                ),
              ),
              child: InkWell(
                onTap: () {
                  controller.clickCell(widget.item);
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  // padding: const EdgeInsets.all(12.0),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  child: Obx(() {
                    return Row(
                      children: [
                        Expanded(child: buildContents()),
                        if (controller.isOperate.value) ...[
                          kSpaceW(12),
                          Icon(controller.selItems.contains(widget.item)
                              ? Icons.check_box_rounded
                              : Icons.check_box_outline_blank_rounded)
                        ],
                      ],
                    );
                  }),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget buildContents() {
    final conditionInfo = widget.item.showCellConditionInfo() ?? "";
    final yieldRate = widget.item.holdingYieldRate;
    final yieldRateText = widget.item.holdingYieldRateText;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 左侧信息
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 名称 + 价格
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      widget.item.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Get.theme.colorScheme.onSurface
                            .withValues(alpha: 0.9),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.item.currentPrice?.isNotEmpty == true) ...[
                    kSpaceW(8),
                    Text(
                      widget.item.currentPrice!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Get.theme.colorScheme.onSurface
                            .withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ],
              ),
              kSpaceH(2),
              // 代码行 + 状态图标
              Row(
                children: [
                  Flexible(
                    child: Text(
                      widget.item.code ?? "",
                      style: TextStyle(
                        fontSize: 12,
                        color: Get.theme.colorScheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  kSpaceW(2),
                  if (widget.item.opTop) ...[
                    kSpaceW(4),
                    Icon(
                      Remix.pushpin_fill,
                      size: 13,
                      color: Colors.blue.shade400,
                    ),
                  ],
                  if (widget.item.opCollect) ...[
                    kSpaceW(4),
                    Icon(
                      Remix.star_fill,
                      size: 13,
                      color: Colors.amber.shade400,
                    ),
                  ],
                  if (widget.item.opBuy) ...[
                    kSpaceW(4),
                    Icon(
                      // Remix.wallet_3_fill,
                      Icons.trending_up,
                      size: 13,
                      color: Colors.red.shade400,
                    ),
                    // 持有操作状态小标签（锁仓/停买/停卖），跟随持有标
                    if (widget.item.rHoldStatus != 0) ...[
                      kSpaceW(4),
                      _buildHoldStatusTag(widget.item.rHoldStatus),
                    ],
                  ],
                  if (yieldRate != null && yieldRateText != null) ...[
                    kSpaceW(4),
                    Flexible(
                      child: Text(
                        yieldRateText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: yieldRate > 0
                              ? Colors.red
                              : yieldRate < 0
                                  ? Colors.green
                                  : Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ],
              ),
              if (widget.item.tagList.isNotEmpty) ...[
                kSpaceH(4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: widget.item.tagList.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: Get.theme.colorScheme.primaryContainer
                            .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        tag.name ?? "",
                        style: TextStyle(
                          fontSize: 10,
                          color: Get.theme.colorScheme.onPrimaryContainer
                              .withValues(alpha: 0.8),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
        // 右侧信息
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (conditionInfo.isNotEmpty) ...[
                _buildConditionTags(conditionInfo),
                kSpaceH(4),
              ],
              Text(
                widget.item.homeCellShowTime(
                    isMeet: controller.selConditionIndex == 0,
                    isNear: controller.selConditionIndex == 1),
                style: TextStyle(
                  fontSize: 11,
                  color: Get.theme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 持有操作状态小标签：1=锁仓, 2=停买, 3=停卖（统一蓝色）
  Widget _buildHoldStatusTag(int status) {
    final text = switch (status) {
      1 => TextKey.suocang.tr,
      2 => TextKey.tingmai.tr,
      3 => TextKey.tingmaichu.tr,
      _ => '',
    };
    if (text.isEmpty) return const SizedBox.shrink();
    final color = Colors.blue.shade400;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color.withValues(alpha: 0.9),
        ),
      ),
    );
  }

  Widget _buildConditionTags(String conditionInfo) {
    final lines = conditionInfo.split('\n').where((l) => l.isNotEmpty).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.asMap().entries.map((entry) {
        return _buildConditionLine(entry.value);
      }).toList(),
    );
  }

  Widget _buildConditionLine(String line) {
    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontSize: 11,
          color: Get.theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          height: 1.22,
        ),
        children: line.split('').map((char) {
          if (char == 'B') {
            return TextSpan(
              text: char,
              style: TextStyle(
                color: Colors.red.shade400,
                fontWeight: FontWeight.w700,
              ),
            );
          } else if (char == 'S') {
            return TextSpan(
              text: char,
              style: TextStyle(
                color: Colors.blue.shade400,
                fontWeight: FontWeight.w700,
              ),
            );
          }
          return TextSpan(text: char);
        }).toList(),
      ),
    );
  }

  ActionPane buildActionPane() {
    final isRestoreMode = controller.selectedOrderIndex == 3;

    return ActionPane(
      extentRatio: isRestoreMode ? 0.35 : 0.8,
      motion: const BehindMotion(),
      children: isRestoreMode
          ? [
              SlideAction(
                color: Colors.green,
                icon: Icons.restore,
                onPressed: () {
                  controller.clickOpRestore(widget.item);
                },
              ),
              SlideAction(
                color: Colors.red,
                icon: Icons.delete_forever,
                onPressed: () {
                  controller.clickOpDelete(widget.item);
                },
              ),
            ]
          : [
              SlideAction(
                color: Colors.redAccent,
                icon:
                    widget.item.opBuy ? Icons.trending_flat : Icons.trending_up,
                onPressed: () {
                  controller.clickOpBuy(widget.item);
                },
              ),
              SlideAction(
                color: Colors.blue,
                icon: widget.item.opTop
                    ? Icons.push_pin
                    : Icons.push_pin_outlined,
                onPressed: () {
                  controller.clickOpTop(widget.item);
                },
              ),
              SlideAction(
                color: Colors.orange,
                icon: widget.item.tagList.isNotEmpty
                    ? Remix.price_tag_3_fill
                    : Remix.price_tag_3_line,
                onPressed: () {
                  controller.clickPushTag(widget.item);
                },
              ),
              SlideAction(
                color: Colors.yellow,
                icon: widget.item.opCollect
                    ? Icons.star
                    : Icons.star_border_outlined,
                onPressed: () {
                  controller.clickOpCollect(widget.item);
                },
              ),
              SlideAction(
                color: Colors.red,
                icon: Icons.delete_forever,
                onPressed: () {
                  controller.clickOpDelete(widget.item);
                },
              ),
            ],
    );
  }
}

class SlideAction extends StatelessWidget {
  const SlideAction({
    super.key,
    required this.color,
    required this.icon,
    this.flex = 1,
    this.onPressed,
    this.label,
  });

  final Color color;
  final IconData icon;
  final int flex;
  final String? label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomSlidableAction(
      flex: flex,
      // autoClose: true,
      backgroundColor: color,
      foregroundColor: Colors.white,
      borderRadius: BorderRadius.circular(20),
      onPressed: (_) {
        // print(icon);
        onPressed?.call();
      },
      padding: EdgeInsets.zero,
      child: Icon(
        icon,
        size: 28,
      ),
    );
  }
}

/// 标签管理弹窗
class TagManagerDialog extends StatelessWidget {
  final HomestockController controller;
  final _editControllers = <int, TextEditingController>{};

  TagManagerDialog({super.key, required this.controller});

  static void show(HomestockController controller) {
    Get.bottomSheet(
      TagManagerDialog(controller: controller),
      isScrollControlled: true,
      backgroundColor: Get.theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 在覆盖 MediaQuery 之前读取键盘高度
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return MediaQuery(
      // 将 viewInsets 置零，阻止 bottom sheet 被键盘顶起
      data: MediaQuery.of(context).copyWith(viewInsets: EdgeInsets.zero),
      child: Listener(
        onPointerMove: (event) {
          // 下拉手势时关闭键盘
          if (event.delta.dy > 0) {
            FocusScope.of(context).unfocus();
          }
        },
        child: Container(
          constraints: BoxConstraints(
            maxHeight: Get.height * 0.5,
          ),
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // 顶部导航栏：返回 | 管理 | 新建
                _buildAppBar(),
                // 标签列表
                Expanded(
                  child: Obx(() {
                    final tags = controller.tags;
                    if (tags.isEmpty) {
                      return Center(
                        child: Text(
                          TextKey.noData.tr,
                          style: TextStyle(
                            color: Get.theme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                          ),
                        ),
                      );
                    }
                    return ReorderableListView.builder(
                      // 底部添加键盘高度内边距，使输入框可滚动到键盘上方
                      padding: EdgeInsets.only(
                        bottom: keyboardHeight,
                      ),
                      itemCount: tags.length,
                      onReorder: (oldIndex, newIndex) {
                        controller.reorderTag(oldIndex, newIndex);
                      },
                      itemBuilder: (context, index) {
                        return _buildTagCell(tags[index], index);
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Get.theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              FocusScope.of(Get.context!).unfocus();
              _disposeControllers();
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios_new, size: 20),
          ),
          Expanded(
            child: Text(
              TextKey.guanli.tr + TextKey.biaoqian.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _showCreateTagDialog();
            },
            child: Text(TextKey.xinjian.tr),
          ),
        ],
      ),
    );
  }

  Widget _buildTagCell(StockItemTag tag, int index) {
    // 确保每个 tag 有自己的 TextEditingController
    final editController = _editControllers.putIfAbsent(
      tag.id,
      () => TextEditingController(text: tag.name),
    );
    // 如果 tag.name 变了（如从其他地方更新），同步 controller
    if (editController.text != tag.name) {
      editController.text = tag.name;
    }

    return Dismissible(
      key: ValueKey(tag.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        bool confirmed = false;
        await showDialog(
          context: Get.context!,
          builder: (ctx) => AlertDialog(
            title: Text(TextKey.querengdelete.tr),
            content: Text(tag.name),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(TextKey.quxiao.tr),
              ),
              TextButton(
                onPressed: () {
                  confirmed = true;
                  Navigator.of(ctx).pop(true);
                },
                child: Text(TextKey.queren.tr),
              ),
            ],
          ),
        );
        return confirmed;
      },
      onDismissed: (direction) {
        controller.deleteTag(tag);
        _editControllers.remove(tag.id)?.dispose();
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        color: Colors.red,
        child: Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.surfaceContainerHighest
              .withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            // 删除按钮
            GestureDetector(
              onTap: () {
                QsHud.showConfirmDialog(
                  title: TextKey.querengdelete.tr,
                  content: tag.name,
                  onConfirm: () {
                    controller.deleteTag(tag);
                    _editControllers.remove(tag.id)?.dispose();
                  },
                );
              },
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Icon(
                  RemixIcons.subtract_line,
                  size: 20,
                  color: Colors.red.shade300,
                ),
              ),
            ),
            // 标签名（可编辑）
            Expanded(
              child: TextField(
                controller: editController,
                style: TextStyle(
                  fontSize: 15,
                  color: Get.theme.colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                  hintText: TextKey.biaoqian.tr,
                  hintStyle: TextStyle(
                    color:
                        Get.theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    controller.renameTag(tag, value.trim());
                  }
                },
              ),
            ),
            // 拖拽排序手柄
            ReorderableDragStartListener(
              index: index,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.drag_handle,
                  size: 22,
                  color: Get.theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ),
            SizedBox(width: 4),
          ],
        ),
      ),
    );
  }

  void _showCreateTagDialog() {
    final textController = TextEditingController();
    final focusNode = FocusNode();
    QsHud.showDialog(AlertDialog(
      title: Text(TextKey.xingjianbiaoqian.tr),
      content: TextField(
        focusNode: focusNode,
        controller: textController,
        decoration: InputDecoration(
          hintText: TextKey.biaoqian.tr,
        ),
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
            final name = textController.text.trim();
            if (name.isNotEmpty) {
              controller.createNewTag(name);
            }
            QsHud.dismiss();
          },
          child: Text(TextKey.baocun.tr),
        ),
      ],
    ));
    Future.delayed(const Duration(milliseconds: 100), () {
      focusNode.requestFocus();
    });
  }

  void _disposeControllers() {
    for (var c in _editControllers.values) {
      c.dispose();
    }
    _editControllers.clear();
  }
}
