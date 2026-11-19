import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/langs/text_key.dart';

class AnnouncementContent extends StatelessWidget {
  const AnnouncementContent({
    super.key,
    this.compact = false,
    this.onSaveImage,
  });

  final bool compact;
  final Future<void> Function()? onSaveImage;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final size = MediaQuery.sizeOf(context);
      final availableWidth = constraints.maxWidth.isFinite
          ? constraints.maxWidth - 40
          : size.width * 0.75;
      final qrSize = math.max(
        120.0,
        math.min(compact ? 200.0 : 240.0,
            math.min(availableWidth, size.height * (compact ? 0.28 : 0.4))),
      );
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              TextKey.gonggaoneirong1.tr,
              style: const TextStyle(fontSize: 15, height: 1.7),
            ),
            const SizedBox(height: 12),
            Text(
              TextKey.gonggaoneirong2.tr,
              style: const TextStyle(fontSize: 15, height: 1.7),
            ),
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onLongPress: onSaveImage == null ? null : () => onSaveImage!(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ColoredBox(
                    color: Colors.white,
                    child: Image.asset(
                      'assets/images/zst.jpg',
                      width: qrSize,
                      height: qrSize,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                TextKey.changanbaocunerweima.tr,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                TextKey.weixinsaoyisaoqgz.tr,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    });
  }
}
