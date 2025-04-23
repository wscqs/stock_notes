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
            // actions: [
            //   IconButton(
            //       onPressed: () {
            //         controller.clickMore();
            //       },
            //       icon: Icon(
            //         Icons.more_horiz,
            //         size: 28,
            //       ))
            // ],
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
                      fontSize: 12,
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
        prefixIcon: const Icon(Icons.search),
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

class HomeNoteCell extends StatelessWidget {
  final int index;
  final NoteItem item;
  final controller = Get.find<HomenoteController>();

  HomeNoteCell({
    super.key,
    required this.item,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(item.id),
      endActionPane: buildActionPane(),
      child: Builder(builder: (context) {
        controller.slidableContexts[index] = context;
        return GestureDetector(
          onLongPress: () {
            controller.longPressCell(item);
          },
          child: Card(
            child: InkWell(
              onTap: () {
                controller.clickCell(item);
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Obx(() {
                  return Row(
                    children: [
                      Expanded(child: buildContents()),
                      if (controller.isOperate.value) ...[
                        kSpaceW(16),
                        Icon(controller.selItems.contains(item)
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
    );
  }

  Column buildContents() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              item.title,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        kSpaceH(2),
        Row(
          children: [
            Text(
              item.createdAt.toDateString() ?? "",
              style: TextStyle(fontSize: 12),
            ),
            kSpaceW(8),
            if (item.opTop)
              Icon(
                Icons.push_pin,
                size: 15,
                color: Colors.blue.shade700,
              ),
            if (item.opCollect)
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
                  controller.clickOpRestore(item);
                },
              ),
              SlideAction(
                color: Colors.red,
                icon: Icons.delete_forever,
                onPressed: () {
                  controller.clickOpDelete(item);
                },
              ),
            ]
          : [
              SlideAction(
                color: Colors.blue,
                icon: item.opTop ? Icons.push_pin : Icons.push_pin_outlined,
                onPressed: () {
                  controller.clickOpTop(item);
                },
              ),
              SlideAction(
                color: Colors.yellow,
                icon: item.opCollect ? Icons.star : Icons.star_border_outlined,
                onPressed: () {
                  controller.clickOpCollect(item);
                },
              ),
              SlideAction(
                color: Colors.red,
                icon: Icons.delete_forever,
                onPressed: () {
                  controller.clickOpDelete(item);
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
