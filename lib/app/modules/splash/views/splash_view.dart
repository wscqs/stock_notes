import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    final SplashController controller = Get.put(SplashController());
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlutterLogo(size: 100), // 这里是闪屏页的内容，你可以自定义
            // SizedBox(height: 20),
            // Text('欢迎使用应用！', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
