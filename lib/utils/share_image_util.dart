import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../common/langs/text_key.dart';
import 'qs_hud.dart';

/// 通用滚动内容截图分享工具
class ShareImageUtil {
  ShareImageUtil._();

  /// 生成的 PNG 最大高度（像素），超过则放弃截图，避免 OOM
  static const int _maxImageHeight = 16000;

  /// 把 [key] 对应的滚动 widget 截图并分享
  /// [subject] 分享文字主题/标题
  /// [filePrefix] 临时文件名前缀
  static Future<void> share({
    required GlobalKey key,
    required String subject,
    required String filePrefix,
  }) async {
    final ctx = key.currentContext;
    if (ctx == null || !ctx.mounted) return;
    // 收起键盘并取消焦点，避免截图里出现光标/键盘
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      await WidgetsBinding.instance.endOfFrame;
      final currentContext = ctx;
      if (!currentContext.mounted) return;
      await Future.delayed(const Duration(milliseconds: 100));
      if (!currentContext.mounted) return;

      final tempDir = await getTemporaryDirectory();
      await _cleanupOldTempFiles(tempDir);
      if (!currentContext.mounted) return;

      final file = await _capture(key, currentContext, filePrefix, tempDir);
      if (file == null || !currentContext.mounted) return;

      if (!currentContext.mounted) return;
      await _shareFile(file, subject, currentContext);
    } on Exception catch (e) {
      debugPrint('ShareImageUtil error: $e');
      if (key.currentContext?.mounted ?? false) {
        QsHud.dismiss();
        QsHud.showToast(TextKey.fails.tr);
      }
    }
  }

  static Future<File?> _capture(
    GlobalKey key,
    BuildContext context,
    String filePrefix,
    Directory tempDir,
  ) async {
    if (!context.mounted) return null;
    QsHud.showLoading();
    try {
      final renderObject = key.currentContext?.findRenderObject();
      if (renderObject == null || renderObject is! RenderRepaintBoundary) {
        QsHud.dismiss();
        QsHud.showToast(TextKey.fails.tr);
        return null;
      }

      final boundary = renderObject;
      final pixelRatio = MediaQuery.devicePixelRatioOf(context);
      final logicalHeight = boundary.size.height;
      final imageHeight = (logicalHeight * pixelRatio).ceil();
      if (imageHeight > _maxImageHeight) {
        QsHud.dismiss();
        QsHud.showToast(TextKey.fails.tr);
        return null;
      }

      final image = await boundary.toImage(pixelRatio: pixelRatio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        QsHud.dismiss();
        QsHud.showToast(TextKey.fails.tr);
        return null;
      }

      final pngBytes = byteData.buffer.asUint8List();
      final sanitizedPrefix =
          filePrefix.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
      final fileName =
          '${sanitizedPrefix}_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(path.join(tempDir.path, fileName));
      await file.writeAsBytes(pngBytes);
      QsHud.dismiss();
      return file;
    } on Exception catch (e) {
      QsHud.dismiss();
      debugPrint('ShareImageUtil._capture error: $e');
      QsHud.showToast(TextKey.fails.tr);
      return null;
    }
  }

  static Future<void> _shareFile(
    File file,
    String subject,
    BuildContext context,
  ) async {
    if (!context.mounted) return;
    final size = MediaQuery.sizeOf(context);
    final origin = Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.85),
      width: 2,
      height: 2,
    );
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: subject,
        subject: subject,
        sharePositionOrigin: origin,
      ),
    );
    // 分享完成后延迟清理临时文件
    Future.delayed(const Duration(minutes: 5)).then((_) async {
      try {
        await file.delete();
      } catch (e) {
        debugPrint('ShareImageUtil delete temp file error: $e');
      }
    });
  }

  /// 兜底清理：删除 24 小时前的分享临时图片，避免磁盘堆积
  static Future<void> _cleanupOldTempFiles(Directory tempDir) async {
    try {
      final now = DateTime.now();
      await for (final entity in tempDir.list()) {
        if (entity is! File) continue;
        final name = path.basename(entity.path);
        if (name.contains('_share_') && name.endsWith('.png')) {
          final stat = await entity.stat();
          if (now.difference(stat.modified).inHours >= 24) {
            try {
              await entity.delete();
            } catch (_) {
              // 忽略清理失败的文件
            }
          }
        }
      }
    } catch (e) {
      debugPrint('ShareImageUtil cleanup error: $e');
    }
  }
}
