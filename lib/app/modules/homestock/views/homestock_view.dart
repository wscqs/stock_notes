import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/widget/keep_alive_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../somewidget/homedrawer_page/view.dart';
import '../controllers/homestock_controller.dart';

class HomestockView extends GetView<HomestockController> {
  const HomestockView({super.key});
  @override
  Widget build(BuildContext context) {
    return KeepAliveWidget(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('股票'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  controller.clickMore();
                },
                icon: Icon(
                  Icons.more_horiz,
                  size: 28,
                ))
          ],
          // leading: Builder(builder: (BuildContext context) {
          //   return IconButton(
          //       icon: Icon(Icons.wifi_tethering),
          //       onPressed: () {
          //         Scaffold.of(context).openDrawer();
          //       });
          // }),
        ),
        drawer: HomedrawerPage(),
        body: _obx(),
      ),
    );
  }

  Widget _contentView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: controller.searchController,
            onChanged: controller.filterItems, // 监听输入内容
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: "Search...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: controller.filteredItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(controller.filteredItems[index]),
                );
              },
            ),
          ),
        ],
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
