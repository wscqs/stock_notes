import 'package:flutter/material.dart';
import 'package:flutter_auto_size_text/flutter_auto_size_text.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/langs/text_key.dart';

import '../../../routes/app_pages.dart';
import '../../homestock/controllers/homestock_controller.dart';
import 'vc.dart';

class HomedrawerPage extends StatelessWidget {
  HomedrawerPage({super.key});

  final HomedrawerVC vc = Get.put(HomedrawerVC());
  final HomestockController parentVC = Get.find<HomestockController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.red),
            child: GestureDetector(
              onTap: () {
                parentVC.pushFamousPage();
              },
              child: Center(
                child: Obx(() {
                  return AutoSizeText(
                    parentVC.selectedFamous.value,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                    maxLines: 4, // 支持最多显示3行
                    minFontSize: 18, // 最小字体
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  );
                }),
              ),
            ),
          ),
          ListTile(
            tileColor: Theme.of(context).colorScheme.surfaceContainer,
            // leading: Icon(Icons.settings),
            title: Text(TextKey.shezhi.tr),
            onTap: () {
              Get.toNamed(Routes.SETTING);
            },
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 18,
            ),
          ),
          ListTile(
            tileColor: Theme.of(context).colorScheme.surfaceContainer,
            // leading: Icon(Icons.settings),
            title: Text(TextKey.shiyong.tr),
            onTap: () {
              Get.toNamed(Routes.USE);
            },
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 18,
            ),
          ),
          ListTile(
            tileColor: Theme.of(context).colorScheme.surfaceContainer,
            title: Text(TextKey.guanyu.tr),
            onTap: () {
              Get.toNamed(Routes.ABOUT);
            },
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 18,
            ),
          ),
          ListTile(
            tileColor: Theme.of(context).colorScheme.surfaceContainer,
            title: Text(TextKey.shujuyuan.tr),
            subtitle: Text(
              TextKey.daorudaochu.tr,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            subtitleTextStyle: TextStyle(
              fontSize: 11,
            ),
            onTap: () {
              parentVC.closeDrawer();
              vc.clickShujuyuan();
              // vc.clickDaorudaochu();
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  parentVC.selectedDateSource.value,
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
