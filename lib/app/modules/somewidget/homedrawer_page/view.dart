import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/langs/text_key.dart';

import '../../../routes/app_pages.dart';
import '../../homestock/controllers/homestock_controller.dart';
import 'vc.dart';

class HomedrawerPage extends StatelessWidget {
  HomedrawerPage({Key? key}) : super(key: key);

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
            decoration: BoxDecoration(
              color: Colors.red,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "祝大佬们股票天天红",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          // ListTile(
          //   leading: Icon(Icons.score),
          //   title: Text('我的积分'),
          // ),
          ListTile(
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
            title: Text(TextKey.guanyu.tr),
            onTap: () {
              Get.toNamed(Routes.ABOUT);
            },
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
