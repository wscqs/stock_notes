import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/comment_style.dart';
import 'package:stock_notes/common/extension/DateTime++.dart';
import 'package:stock_notes/common/langs/text_key.dart';
import 'package:stock_notes/common/widget/keep_alive_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../common/database/database.dart';
import '../../somewidget/homedrawer_page/view.dart';
import '../controllers/homestock_controller.dart';

class HomestockView extends GetView<HomestockController> {
  const HomestockView({super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 关闭键盘
      },
      child: KeepAliveWidget(
        child: Scaffold(
          appBar: AppBar(
            title: Text(TextKey.gupiao.tr),
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
              hintText: TextKey.search.tr + " ...",
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
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: controller.items.length,
              itemBuilder: (context, index) {
                return HomeStockCell(
                  item: controller.items[index],
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
  // final int index;
  final StockItem item;
  final controller = Get.find<HomestockController>();
  HomeStockCell({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(item.id),
      endActionPane: ActionPane(
        extentRatio: 0.7,
        motion: const BehindMotion(),
        children: [
          SlideAction(
            color: Colors.blue,
            icon: item.opTop ? Icons.push_pin : Icons.push_pin_outlined,
            onPressed: () {
              controller.clickOpTop(item);
            },
            // flex: 2,
          ),
          SlideAction(
            color: Colors.orange,
            icon: Icons.tab,
            // flex: 2,
          ),
          SlideAction(
            color: Colors.yellow,
            icon: item.opCollect ? Icons.star : Icons.star_border_outlined,
            onPressed: () {
              controller.clickOpCollect(item);
            },
            // flex: 2,
          ),
          SlideAction(
            color: Colors.red,
            icon: Icons.delete_forever,
            // flex: 1,
            onPressed: () {
              controller.clickOpDelete(item);
            },
          ),
        ],
      ),
      child: Card(
        child: InkWell(
          onTap: () {
            controller.pushDetailPage(item);
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  // spacing: 8,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(fontSize: 16),
                    ),
                    kSpaceW(8),
                    Text(
                      item.currentPrice ?? "",
                      style: TextStyle(fontSize: 16),
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
                      padding: EdgeInsets.symmetric(vertical: 1, horizontal: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Center(
                        child: Text(
                          (item.marketType ?? "") == "51" ? "深" : "沪",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      item.code ?? "",
                      style: TextStyle(fontSize: 14),
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
                      item.createdAt.toDateString() ?? "",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
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
