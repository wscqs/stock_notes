import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/widget/keep_alive_widget.dart';

import '../controllers/homenote_controller.dart';

class HomenoteView extends GetView<HomenoteController> {
  const HomenoteView({super.key});
  @override
  Widget build(BuildContext context) {
    return KeepAliveWidget(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('HomenoteView'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text(
            'HomenoteView is working',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
