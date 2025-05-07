import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/langs/text_key.dart';

import '../controllers/use_controller.dart';

class UseView extends GetView<UseController> {
  const UseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TextKey.shiyong.tr),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Text(
          TextKey.shiyongshuomingall.tr,
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}
