import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/database/database.dart';
import 'package:stock_notes/common/langs/text_key.dart';

import '../controllers/tagsedit_controller.dart';

class TagseditView extends GetView<TagseditController> {
  const TagseditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TextKey.biaoqian.tr),
        centerTitle: true,
        actions: [
          ElevatedButton(
              onPressed: () {
                controller.save();
              },
              child: Text(TextKey.baocun.tr))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // padding: EdgeInsets.only(left: 16, right: 16, bottom: 4),
              child: Obx(() {
                return Wrap(
                  spacing: 12, // 主轴(水平)方向间距
                  runSpacing: 12, // 纵轴（垂直）方向间距
                  alignment: WrapAlignment.start, //沿主轴方向居中
                  children: controller.tags
                      .map((item) => buildHotPopViews(item))
                      .toList(),
                );
              }),
            ),
            // kSpaceH(16),
            IconButton(
                onPressed: () {
                  controller.createTag();
                },
                icon: Icon(
                  Icons.add_circle,
                  size: 30,
                  color: Get.theme.colorScheme.primary,
                ))
            // FilledButton(
            //     onPressed: () {
            //       controller.creatTag();
            //     },
            //     child: Text(
            //       TextKey.xingjianbiaoqian.tr,
            //       style: TextStyle(fontSize: 12),
            //     ))
          ],
        ),
      ),
    );
  }

  Widget getSelItemView(StockItemTag item) {
    return GestureDetector(
      onTap: () {
        controller.onTapSelTag(item);
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 16),
        decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(4)),
        child: Text(
          item.name,
          style: TextStyle(
            color: controller.selTags.value.contains(item)
                ? Colors.red
                : Get.theme.colorScheme.onSurface.withValues(alpha: 0.5),
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  DropdownButtonHideUnderline buildHotPopViews(StockItemTag item) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        // isExpanded: true,
        openWithLongPress: true,
        customButton: getSelItemView(item),
        items: controller.opBtns
            .map((String item) => DropdownItem<String>(
                  value: item,
                  height: 32,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ))
            .toList(),
        onChanged: (String? value) {
          controller.onTapOp(value!, item);
          // QsHud.showToast(value!);
          // controller.selectedOrderIndex.value =
          //     controller.order.indexOf(value!);
          // controller.getDatas();
        },
        iconStyleData: IconStyleData(
          iconSize: 0,
        ),
        // buttonStyleData: ButtonStyleData(
        //   // padding: EdgeInsets.only(left: 4, right: 4),
        //   height: 40,
        //   width: 72,
        // ),
        dropdownStyleData: DropdownStyleData(
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(8),
          // ),
          width: 58,
          offset: const Offset(-0, 6),
        ),
      ),
    );
  }
}
