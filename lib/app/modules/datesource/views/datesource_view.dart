import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/comment_style.dart';
import 'package:stock_notes/common/langs/text_key.dart';

import '../../homestock/views/homestock_view.dart';
import '../controllers/datesource_controller.dart';

class DatesourceView extends GetView<DatesourceController> {
  const DatesourceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TextKey.shujuyuan.tr),
        centerTitle: true,
      ),
      body: Obx(() {
        return buildSingleChildScrollView();
      }),
    );
  }

  SingleChildScrollView buildSingleChildScrollView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TextKey.shujuyuan.tr + "：" + controller.selectedDateSource.value,
            style: TextStyle(fontSize: 18),
          ),
          kSpaceH(16),
          Text(
            TextKey.daochu.tr,
            style: TextStyle(fontSize: 18),
          ),
          kSpaceH(12),
          buildDaoChu(),
          kSpaceH(12),
          Text(
            TextKey.daoru.tr,
            style: TextStyle(fontSize: 18),
          ),
          kSpaceH(12),
          buildDaoRu(),
          kSpaceH(12),
          Text(
            TextKey.shujuyuan.tr,
            style: TextStyle(fontSize: 18),
          ),
          kSpaceH(12),
          buildListView()
        ],
      ),
    );
  }

  Widget buildListView() {
    return SlidableAutoCloseBehavior(
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Slidable(
            endActionPane: buildActionPane(index),
            child: buildCellContentView(index),
          );
        },
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: controller.dateSourceList.length,
      ),
    );
  }

  Widget buildCellContentView(int index) {
    return InkWell(
      onTap: () {
        controller
            .clickSelectedDateSource(controller.dateSourceList[index]['name']);
        // controller.clickCell(controller.dateSourceList[index]);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [
          Radio<String>(
            value: controller.dateSourceList[index]['name'],
            groupValue: controller.selectedDateSource.value,
            onChanged: null,
          ),
          Text(controller.dateSourceList[index]['name'],
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }

  ActionPane buildActionPane(int index) {
    return ActionPane(
      extentRatio: 0.35,
      motion: const BehindMotion(),
      children: [
        SlideAction(
          color: Colors.green,
          icon: Icons.edit,
          onPressed: () {
            controller.clickCellEdit(controller.dateSourceList[index]);
          },
        ),
        SlideAction(
          color: Colors.red,
          icon: Icons.delete_forever,
          onPressed: () {
            controller.clickCellDelete(controller.dateSourceList[index]);
          },
        ),
      ],
    );
  }

  Row buildDaoRu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            controller.selectedOption.value = 'doSel';
          },
          child: Row(
            children: [
              Radio<String>(
                value: 'doSel',
                groupValue: controller.selectedOption.value,
                onChanged: null,
              ),
              Text(TextKey.daorubingxuanzhe.tr),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            controller.selectedOption.value = 'doNoSel';
          },
          child: Row(
            children: [
              Radio<String>(
                value: 'doNoSel',
                groupValue: controller.selectedOption.value,
                onChanged: null,
              ),
              Text(TextKey.jindaoru.tr),
            ],
          ),
        ),
        kSpaceMax(),
        ElevatedButton(
          onPressed: () {
            controller.inputBackup();
          },
          child: Text(TextKey.daoru.tr),
        ),
      ],
    );
  }

  Widget buildDaoChu() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 44,
            child: TextField(
              controller: controller.nameText,
              decoration: InputDecoration(
                hintText: TextKey.shurumingzisouziszm.tr,
                border: OutlineInputBorder(),
                counterText: '', // 隐藏计数器
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              ),
              maxLength: 10,
            ),
          ),
        ),
        kSpaceW(16),
        ElevatedButton(
          onPressed: () {
            controller.createBackup();
          },
          child: Text(TextKey.daochu.tr),
        ),
      ],
    );
  }
}
