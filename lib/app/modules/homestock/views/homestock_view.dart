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
      behavior: HitTestBehavior.opaque, // 一定要 opaque，全区域都接收
      onPointerDown: (event) {
        controller.slidableController = slidableController;
      },
      child: Slidable(
        key: ValueKey(widget.item.id),
        controller: slidableController,
        endActionPane: buildActionPane(),
        child: Builder(builder: (context) {
          // controller.slidableContexts[index] = context;
          return GestureDetector(
            onLongPress: () {
              controller.longPressCell(widget.item);
            },
            child: Card(
              child: InkWell(
                onTap: () {
                  controller.clickCell(widget.item);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Obx(() {
                    return Row(
                      children: [
                        Expanded(child: buildContents()),
                        if (controller.isOperate.value) ...[
                          kSpaceW(16),
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
    return Stack(
      children: [
        Column(
          children: [
            Row(
              children: [
                Text(
                  widget.item.name,
                  style: TextStyle(fontSize: 16),
                ),
                kSpaceW(8),
                Text(
                  widget.item.currentPrice ?? "",
                  style: TextStyle(fontSize: 16),
                ),
                kSpaceW(8),
                if (widget.item.opTop)
                  Icon(
                    Icons.push_pin,
                    size: 15,
                    color: Colors.blue.shade700,
                  ),
                if (widget.item.opCollect)
                  Icon(
                    Icons.star,
                    size: 15,
                    color: Colors.yellow.shade700,
                  ),
                if (widget.item.opBuy)
                  Icon(
                    Icons.trending_up,
                    size: 15,
                    color: Colors.red.shade700,
                  ),
                kSpaceMax(),
              ],
            ),
            kSpaceH(2),
            Row(
              spacing: 4,
              children: [
                Text(
                  widget.item.code ?? "",
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  (widget.item.marketType ?? "") == "51" ? "· 深" : "· 沪",
                  style: TextStyle(
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            kSpaceH(4),
            Row(
              children: [
                if (widget.item.tagList.length > 0)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(
                      RemixIcons.price_tag_3_line,
                      size: 10,
                    ),
                  ),
                Expanded(
                  child: Text(
                    widget.item.homeCellShowTagNames() ?? "",
                    style: TextStyle(fontSize: 10),
                  ),
                ),
                kSpaceW(8),
                SizedBox(
                  width: 76,
                  child: Text(
                    widget.item.homeCellShowTime(
                        isMeet: controller.selConditionIndex == 0,
                        isNear: controller.selConditionIndex == 1),
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
        Positioned(
          right: 0,
          top: 0,
          child: SizedBox(
            width: 76,
            child: Text.rich(
              TextSpan(
                style: TextStyle(fontSize: 10), // 默认样式
                children: (widget.item.showCellConditionInfo() ?? "")
                    .split('')
                    .map((char) {
                  if (char == 'B') {
                    return TextSpan(
                        text: char,
                        style: TextStyle(color: Colors.red, fontSize: 11));
                  } else if (char == 'S') {
                    return TextSpan(
                        text: char,
                        style: TextStyle(color: Colors.blue, fontSize: 11));
                  } else {
                    return TextSpan(text: char); // 默认样式
                  }
                }).toList(),
              ),
            ),
          ),
        )
      ],
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
                icon: Remix.price_tag_3_line,
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
