import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/notedetail_controller.dart';

class NotedetailView extends GetView<NotedetailController> {
  const NotedetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NotedetailView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'NotedetailView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
