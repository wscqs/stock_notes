import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widget/double_press_back.dart';
import '../controllers/tabs_controller.dart';

class TabsView extends GetView<TabsController> {
  const TabsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => _scaffold(context));
  }

  Widget _scaffold(BuildContext context) {
    return DoublePressBackWidget(
      child: Scaffold(
        extendBody: true, // 使 body 的内容扩展到 bottomNavigationBar 的下方
        resizeToAvoidBottomInset: false, // 禁止调整布局避免键盘遮挡
        body: PageView(
          physics: NeverScrollableScrollPhysics(), // 禁止滚动
          controller: controller.pageController,
          children: controller.pages,
          onPageChanged: (index) {
            // controller.setCurrentIndex(index);
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.pushCreatePage();
          },
          child: const Icon(
            Icons.add,
            size: 36,
          ),
          foregroundColor: Colors.white,
          backgroundColor: Colors.red,
          shape: CircleBorder(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: MediaQuery.of(context).viewInsets.bottom > 0
            ? const SizedBox.shrink() // 键盘弹起时隐藏 BottomNavigationBar
            : BottomAppBar(
                shape: CircularNotchedRectangle(),
                // color: Colors.black.withValues(alpha: 0.5), // 可调整透明度配合模糊效果
                padding: const EdgeInsets.symmetric(horizontal: 0),
                height: 60,
                notchMargin: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IconButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                      icon: Icon(
                        Icons.trending_up,
                        size: 30,
                      ),
                      color: controller.currentIndex == 0
                          ? Colors.red
                          : Colors.grey,
                      onPressed: () {
                        controller.clickTab(0);
                      },
                    ),
                    IconButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                      icon: Icon(
                        Icons.event_note,
                        size: 30,
                      ),
                      color: controller.currentIndex == 1
                          ? Colors.red
                          : Colors.grey,
                      onPressed: () {
                        controller.clickTab(1);
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
