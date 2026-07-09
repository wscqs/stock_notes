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
      preferredSize: Size.fromHeight(76 + 30), // 指定 TabBar 高度
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Get.theme.colorScheme.surface,
              padding:
                  EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
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
              padding: EdgeInsets.only(left: 20, right: 0, bottom: 12),
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
          ],
        );
      }),
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
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.4),
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
                  padding: const EdgeInsets.all(14.0),
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
              // 名称 + 价格 + 状态图标
              Row(
                children: [
                  Flexible(
                    child: Text(
                      widget.item.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Get.theme.colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.item.currentPrice?.isNotEmpty == true) ...[
                    kSpaceW(8),
                    Text(
                      widget.item.currentPrice!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Get.theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
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
                  ],
                  if (yieldRate != null && yieldRateText != null) ...[
                    kSpaceW(4),
                    Text(
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
                    ),
                  ],
                ],
              ),
              kSpaceH(6),
              // 代码行
              Text(
                widget.item.code ?? "",
                style: TextStyle(
                  fontSize: 12,
                  color: Get.theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (widget.item.tagList.isNotEmpty) ...[
                kSpaceH(6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: widget.item.tagList.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: Get.theme.colorScheme.primaryContainer
                            .withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        tag.name ?? "",
                        style: TextStyle(
                          fontSize: 10,
                          color: Get.theme.colorScheme.onPrimaryContainer,
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
                kSpaceH(6),
              ],
              Text(
                widget.item.homeCellShowTime(
                    isMeet: controller.selConditionIndex == 0,
                    isNear: controller.selConditionIndex == 1),
                style: TextStyle(
                  fontSize: 11,
                  color: Get.theme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConditionTags(String conditionInfo) {
    final lines = conditionInfo.split('\n').where((l) => l.isNotEmpty).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.asMap().entries.map((entry) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: entry.key < lines.length - 1 ? 2 : 0),
          child: _buildConditionLine(entry.value),
        );
      }).toList(),
    );
  }

  Widget _buildConditionLine(String line) {
    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontSize: 11,
          color: Get.theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.85),
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

class _ConditionTag extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Color textColor;

  const _ConditionTag({
    required this.text,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
