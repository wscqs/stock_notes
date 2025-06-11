import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/langs/text_key.dart';
import 'package:stock_notes/utils/qs_hud.dart';

import '../../../../common/comment_style.dart';
import '../../homestock/views/homestock_view.dart';
import '../controllers/famous_controller.dart';

class FamousView extends GetView<FamousController> {
  const FamousView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TextKey.mingyanjinju.tr),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              QsHud.showKnowDialog(
                  title: "此数据仅存设备", content: "（导入导出不操作此数据）", onConfirm: () {});
            },
            icon: Icon(Icons.info_outline),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false, // 禁止调整布局避免键盘遮挡
      body: Obx(
        () {
          return SlidableAutoCloseBehavior(
            child: ReorderableListView(
              padding: EdgeInsets.only(top: 8, bottom: 66),
              children: [
                for (int index = 0; index < controller.datas.length; index++)
                  FamousViewCell(
                    key: ValueKey(controller.datas[index]),
                    title: controller.datas[index]["key"] == TextKey.zhufuhuayu
                        ? TextKey.zhufuhuayu.tr
                        : controller.datas[index]["value"],
                    onPressed: () {
                      controller.select(controller.datas[index]["key"]);
                    },
                    isCheck: controller.selKey.value ==
                        controller.datas[index]["key"],
                    index: index,
                  )
              ],
              onReorder: (int oldIndex, int newIndex) {
                controller.reorder(oldIndex, newIndex);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.addFamous();
        },
        foregroundColor: Colors.white,
        shape: CircleBorder(),
        child: const Icon(
          Icons.add,
          size: 36,
        ),
      ),
    );
  }
}

class FamousViewCell extends StatelessWidget {
  final int? index;
  final String? title;
  final VoidCallback? onPressed;
  final double? radius;
  final bool? isCheck;
  final controller = Get.find<FamousController>();

  FamousViewCell({
    super.key,
    this.title,
    this.onPressed,
    this.radius = 0,
    this.isCheck = false,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      // controller: controller.slidableController,
      // key: ValueKey(index),
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const BehindMotion(),
        children: [
          SlideAction(
            color: Colors.blue,
            icon: Icons.edit,
            label: "Edit",
            onPressed: () {
              controller.clickEdit(index);
            },
          ),
          SlideAction(
            color: Colors.red,
            icon: Icons.delete_forever,
            label: "Delete",
            onPressed: () {
              controller.clickDelete(index);
            },
          ),
        ],
      ),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius!),
            color: Theme.of(context).colorScheme.surfaceContainerLow,
          ),
          child: Row(
            children: [
              Icon(
                isCheck! ? Icons.radio_button_checked : Icons.radio_button_off,
                size: 20,
                color: isCheck! ? Colors.red : Colors.grey,
              ),
              kSpaceW(12),
              Expanded(child: Text(title ?? "")),
              kSpaceW(8),
              //排序的 icon
              Icon(
                Icons.drag_handle,
                size: 20,
                color: Colors.grey,
              )
            ],
          ),
        ),
      ),
    );
  }
}
