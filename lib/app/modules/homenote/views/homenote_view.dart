import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/homenote_controller.dart';

class HomenoteView extends GetView<HomenoteController> {
  const HomenoteView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
