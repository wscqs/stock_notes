import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/extension/DateTime++.dart';
import 'package:stock_notes/common/widget/keep_alive_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../common/comment_style.dart';
import '../../../../common/database/database.dart';
import '../../../../common/langs/text_key.dart';
import '../../../../common/widget/qs_empty_view.dart';
import '../../homestock/views/homestock_view.dart';
import '../controllers/homenote_controller.dart';

class HomenoteView extends GetView<HomenoteController> {
  const HomenoteView({super.key});

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
            title: Text(TextKey.biji.tr),
            centerTitle: true,
            bottom: buildSectionTop(),
          ),
          body: _obx(),
        ),
      ),
    );
  }

  PreferredSize buildSectionTop() {
    return PreferredSize(
      preferredSize: Size.fromHeight(76), // 指定 TabBar 高度
      child: Obx(() {
        return Container(
          padding: EdgeInsets.all(16),
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
        );
      }),
    );
  }

  DropdownButtonHideUnderline buildHotPopViews() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
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
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(8),
          // ),
          width: 80,
          offset: const Offset(-8, 0),
        ),
      ),
    );
  }

  Widget _contentView() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: controller.items.isEmpty
          ? QsEmptyView(
              message: TextKey.noData.tr,
            )
          : listView(),
    );
  }

  Widget listView() {
    return SlidableAutoCloseBehavior(
      child: ListView.builder(
        itemCount: controller.items.length,
        itemBuilder: (context, index) {
          return HomeNoteCell(
            item: controller.items[index],
            index: index,
          );
        },
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

  Widget _obx() => Obx(() => _visibilityDetector());

  Widget _visibilityDetector() {
    return VisibilityDetector(
        key: Key("value"),
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
        child: _contentView());
  }
}

class HomeNoteCell extends StatefulWidget {
  final int index;
  final NoteItem item;

  HomeNoteCell({
    super.key,
    required this.item,
    required this.index,
  });

  @override
  State<HomeNoteCell> createState() => _HomeNoteCellState();
}

class _HomeNoteCellState extends State<HomeNoteCell>
    with TickerProviderStateMixin {
  final controller = Get.find<HomenoteController>();
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
        endActionPane: buildActionPane(),
        controller: slidableController,
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

  Column buildContents() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              widget.item.title,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        kSpaceH(2),
        Row(
          children: [
            Text(
              widget.item.createdAt.toDateString() ?? "",
              style: TextStyle(fontSize: 12),
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
          ],
        ),
      ],
    );
  }

  ActionPane buildActionPane() {
    final isRestoreMode = controller.selectedOrderIndex == 2;

    return ActionPane(
      extentRatio: isRestoreMode ? 0.35 : 0.52,
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
                color: Colors.blue,
                icon: widget.item.opTop
                    ? Icons.push_pin
                    : Icons.push_pin_outlined,
                onPressed: () {
                  controller.clickOpTop(widget.item);
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

// class SlideAction extends StatelessWidget {
//   const SlideAction({
//     Key? key,
//     required this.color,
//     required this.icon,
//     this.flex = 1,
//     this.onPressed,
//     this.label,
//   }) : super(key: key);
//
//   final Color color;
//   final IconData icon;
//   final int flex;
//   final String? label;
//   final VoidCallback? onPressed;
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomSlidableAction(
//       flex: flex,
//       backgroundColor: color,
//       foregroundColor: Colors.white,
//       borderRadius: BorderRadius.circular(20),
//       onPressed: (_) {
//         // print(icon);
//         onPressed?.call();
//       },
//       child: Icon(
//         icon,
//         size: 28,
//       ),
//       padding: EdgeInsets.zero,
//     );
//   }
// }
