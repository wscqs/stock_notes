import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/comment_style.dart';
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
                return HomeStockCell(
                  index: index,
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

class HomeStockCell extends StatelessWidget {
  final int index;
  const HomeStockCell({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(index),
      endActionPane: ActionPane(
        extentRatio: 0.8,
        motion: const BehindMotion(),
        children: [
          SlideAction(
            color: Colors.green,
            icon: Icons.vertical_align_top,
            // flex: 2,
          ),
          SlideAction(
            color: Colors.blue,
            icon: Icons.tab,
            // flex: 2,
          ),
          SlideAction(
            color: Colors.yellow,
            icon: Icons.star,
            // flex: 2,
          ),
          SlideAction(
            color: Colors.red,
            icon: Icons.delete_forever,
            // flex: 1,
            onPressed: () {
              // controller.deleteHistory(index);
            },
          ),
        ],
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                spacing: 8,
                children: [
                  Text(
                    "春秋航空",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "16.00",
                    style: TextStyle(fontSize: 16),
                  ),
                  kSpaceMax(),
                  Text(
                    "买",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              kSpaceH(2),
              Row(
                spacing: 4,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      "沪",
                      style: TextStyle(
                        fontSize: 9,
                      ),
                    ),
                  ),
                  Text(
                    "SZ601021",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              kSpaceH(4),
              Row(
                spacing: 8,
                children: [
                  Expanded(
                    child: Text(
                      "16.00",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Text(
                    "2012年7月2号",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SlideAction extends StatelessWidget {
  const SlideAction({
    Key? key,
    required this.color,
    required this.icon,
    this.flex = 1,
    this.onPressed,
    this.label,
  }) : super(key: key);

  final Color color;
  final IconData icon;
  final int flex;
  final String? label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomSlidableAction(
      flex: flex,
      backgroundColor: color,
      foregroundColor: Colors.white,
      borderRadius: BorderRadius.circular(20),
      onPressed: (_) {
        // print(icon);
        onPressed?.call();
      },
      child: Icon(
        icon,
        size: 28,
      ),
      padding: EdgeInsets.zero,
    );
    // return SlidableAction(
    //   flex: flex,
    //   backgroundColor: color,
    //   foregroundColor: Colors.white,
    //   borderRadius: BorderRadius.circular(20),
    //   onPressed: (_) {
    //     // print(icon);
    //     onPressed?.call();
    //   },
    //   icon: icon,
    //   label: label,
    //   // padding: EdgeInsets.zero,
    // );
  }
}
