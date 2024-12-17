import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/stockdetail_controller.dart';

class StockdetailView extends GetView<StockdetailController> {
  const StockdetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StockdetailView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'StockdetailView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
