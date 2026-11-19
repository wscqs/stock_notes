import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/langs/text_key.dart';
import '../controllers/announcement_controller.dart';
import 'announcement_content.dart';

class AnnouncementView extends GetView<AnnouncementController> {
  const AnnouncementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TextKey.gonggao.tr),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: AnnouncementContent(
              onSaveImage: controller.saveQrCode,
            ),
          ),
        ),
      ),
    );
  }
}
