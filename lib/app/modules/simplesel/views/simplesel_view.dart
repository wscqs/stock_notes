import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../commonwidget/simple_cell.dart';
import '../controllers/simplesel_controller.dart';

//选择页，比如深色模式与多语言用
class SimpleselView extends GetView<SimpleselController> {
  const SimpleselView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Obx(() {
            return Text(controller.title.value);
          }),
          centerTitle: true,
        ),
        body: Obx(() {
          return ListView.builder(
            itemCount: controller.datas.length,
            itemBuilder: (context, index) {
              return SimpleCell(
                title: controller.datas[index]["name"],
                onPressed: () {
                  controller.sel(index);
                },
                isShowRightArrow: false,
                isCheck:
                    controller.selKey.value == controller.datas[index]["value"],
              );
            },
          );
        }));
  }
}
