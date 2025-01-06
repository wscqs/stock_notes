import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../somewidget/homedrawer_page/view.dart';
import '../controllers/homestock_controller.dart';

class HomestockView extends GetView<HomestockController> {
  const HomestockView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomestockView'),
        centerTitle: true,
        // leading: Builder(builder: (BuildContext context) {
        //   return IconButton(
        //       icon: Icon(Icons.wifi_tethering),
        //       onPressed: () {
        //         Scaffold.of(context).openDrawer();
        //       });
        // }),
      ),
      drawer: HomedrawerPage(),
      body: const Center(
        child: Text(
          'HomestockView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
