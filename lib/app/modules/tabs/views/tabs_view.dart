import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widget/double_press_back.dart';
import '../controllers/tabs_controller.dart';

class TabsView extends GetView<TabsController> {
  const TabsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => _scaffold());
  }

  Widget _scaffold() {
    return DoublePressBackWidget(
      child: Scaffold(
        body: PageView(
          physics: NeverScrollableScrollPhysics(), // 禁止滚动
          controller: controller.pageController,
          children: controller.pages,
          onPageChanged: (index) {
            // controller.setCurrentIndex(index);
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          // shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(0)),
          shape: CircleBorder(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          color: Colors.white, //底部工具栏的颜色。
          padding: const EdgeInsets.symmetric(horizontal: 0),
          height: 60,
          notchMargin: 10,
          child: Row(
            //里边可以放置大部分Widget，让我们随心所欲的设计底栏
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                icon: Icon(
                  Icons.trending_up,
                  size: 30,
                ),
                color: controller.currentIndex == 0 ? Colors.red : Colors.grey,
                onPressed: () {
                  controller.clickTab(0);
                },
              ),
              IconButton(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                icon: Icon(
                  Icons.event_note,
                  size: 30,
                ),
                color: controller.currentIndex == 1 ? Colors.red : Colors.grey,
                onPressed: () {
                  controller.clickTab(1);
                },
              ),
            ],
          ),
          // child: BottomNavigationBar(
          //     fixedColor: Colors.orange, //选中的颜色
          //     currentIndex: controller.currentIndex.value, //第几个菜单选中
          //     // backgroundColor: Colors.brown, // 设置底部导航栏的背景颜色
          //     onTap: (index) {
          //       controller.setCurrentIndex(index);
          //       controller.pageController.jumpToPage(index);
          //     },
          //     type: BottomNavigationBarType.fixed, //如果有4个或者4个以上的
          //     items: const [
          //       BottomNavigationBarItem(
          //           icon: Icon(Icons.trending_up), label: "stock"),
          //       BottomNavigationBarItem(
          //           icon: Icon(Icons.event_note), label: "note"),
          //     ]),
        ),
      ),
    );
  }
}
