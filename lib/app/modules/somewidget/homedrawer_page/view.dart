import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'vc.dart';

class HomedrawerPage extends StatelessWidget {
  HomedrawerPage({Key? key}) : super(key: key);

  final HomedrawerVC vc = Get.put(HomedrawerVC());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const <Widget>[
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
          ListTile(
            leading: Icon(Icons.score),
            title: Text('我的积分'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('系统设置'),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('关于'),
          ),
        ],
      ),
    );
  }
}
