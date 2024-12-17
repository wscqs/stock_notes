import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/homestock_controller.dart';

class HomestockView extends GetView<HomestockController> {
  const HomestockView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomestockView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'HomestockView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
