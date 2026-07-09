import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/database/database.dart';
import 'package:stock_notes/common/langs/text_key.dart';

import '../controllers/tagsedit_controller.dart';

class TagseditView extends GetView<TagseditController> {
  const TagseditView({super.key});

  static void show(StockItem stockItem) {
    Get.bottomSheet(
      GetBuilder<TagseditController>(
        init: TagseditController(stockItem: stockItem),
        autoRemove: true,
        builder: (_) => const TagseditView(),
      ),
      isScrollControlled: true,
      backgroundColor: Get.theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.7,
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  TextKey.biaoqian.tr,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      controller.createTag();
                    },
                    child: Text(TextKey.xinjian.tr),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Obx(() {
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.start,
                    children: controller.tags
                        .map((item) => buildHotPopViews(item))
                        .toList(),
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  controller.save();
                },
                child: Container(
                  width: double.infinity,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                  child: Text(
                    TextKey.queren.tr,
                    style: TextStyle(
                      fontSize: 16,
                      color: Get.theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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
