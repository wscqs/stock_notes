import 'dart:convert';
import 'dart:io' as io show Directory, File;

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' hide Value; //Value drift有用
import 'package:path/path.dart' as path;
import 'package:stock_notes/common/langs/text_key.dart';
import 'package:stock_notes/utils/qs_hud.dart';

import '../../../../common/database/DatabaseManager.dart';
import '../../../../common/database/database.dart';
import '../../../../utils/stock_link_utils.dart';
import '../../../routes/app_pages.dart';
import '../../noteedit/controllers/noteedit_controller.dart'
    show ColorSelectorRow;

/// 股票笔记控制器：股票自己的笔记（大备注），存于 StockItems.rNote
/// Get.arguments 为 StockItem
class StocknoteController extends GetxController {
  final QuillController quillController = () {
    return QuillController.basic(
        config: QuillControllerConfig(
      clipboardConfig: QuillClipboardConfig(
        enableExternalRichPaste: true,
        onImagePaste: (imageBytes) async {
          if (kIsWeb) {
            // Dart IO is unsupported on the web.
            return null;
          }
          // Save the image somewhere and return the image URL that will be
          // stored in the Quill Delta JSON (the document).
          final newFileName =
              'image-file-${DateTime.now().toIso8601String()}.png';
          final newPath = path.join(
            io.Directory.systemTemp.path,
            newFileName,
          );
          final file = await io.File(
            newPath,
          ).writeAsBytes(imageBytes, flush: true);
          return file.path;
        },
      ),
    ));
  }();
  final FocusNode editorFocusNode = FocusNode();
  final ScrollController editorScrollController = ScrollController();

  final stockData = Rxn<StockItem>();

  //本页为纯编辑页，默认编辑状态
  final isEditing = true.obs;

  final currentTextColor = Get.theme.colorScheme.onSurface.obs;

  bool canPop = false; // 控制是否允许返回。true不拦截，false 才能进入handlePop判断

  bool get _hasLocalNote => (stockData.value?.rNote ?? "").isNotEmpty;

  String _localPlainText() {
    final localContent = stockData.value?.rNote;
    if (localContent == null || localContent.isEmpty) return '';
    try {
      return Document.fromJson(jsonDecode(localContent)).toPlainText();
    } catch (_) {
      return '';
    }
  }

  Future<bool> handlePop() async {
    final localPlain = _localPlainText();
    final currentPlain = quillController.document.toPlainText();
    //新增且无输入（空文档 toPlainText 为 "\n"），直接返回不弹窗
    if (localPlain.isEmpty && currentPlain.trim().isEmpty) return true;
    if (localPlain == currentPlain) return true;
    // 弹出二次确认对话框
    await showDialog<bool>(
      context: Get.context!,
      builder: (context) => AlertDialog(
        content: Padding(
          padding: const EdgeInsets.only(left: 4, top: 4),
          child: Text(TextKey.shifoubaocungenggai.tr,
              style: TextStyle(fontSize: 16)),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); //关闭Dialog
              Get.back(); //退出页面（不保存）
            },
            child: Text(TextKey.bu.tr + TextKey.baocun.tr),
          ),
          TextButton(
            onPressed: () {
              Get.back(); //先关闭Dialog，save 成功后再后退
              save();
            },
            child: Text(TextKey.baocun.tr),
          ),
        ],
      ),
    );
    return false;
  }

  @override
  void onInit() {
    super.onInit();
    stockData.value = Get.arguments;
    quillController.readOnly = false;
    final content = stockData.value?.rNote;
    if (content != null && content.isNotEmpty) {
      try {
        quillController.document = Document.fromJson(jsonDecode(content));
      } catch (_) {}
    } else {
      //新建默认聚焦弹出键盘
      Future.delayed(500.milliseconds, () {
        editorFocusNode.requestFocus();
      });
    }
    quillController.addListener(() {
      _updateCurrentTextColor();
    });
  }

  @override
  void onClose() {
    quillController.dispose();
    editorScrollController.dispose();
    editorFocusNode.dispose();
    super.onClose();
  }

  /// 根据数据库股票列表，自动识别笔记中的股票名称/代码并包装为 link
  Future<void> _wrapStockLinks() async {
    final db = Get.find<DatabaseManager>().db;
    final allStocks = await db.select(db.stockItems).get();
    final deltaJson = quillController.document.toDelta().toJson();
    final wrappedDelta =
        StockLinkUtils.wrapStockCodesInDelta(deltaJson, allStocks);
    quillController.document = Document.fromJson(wrappedDelta);
  }

  Future<void> save({bool isBack = true}) async {
    //键盘隐藏
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    final stock = stockData.value;
    if (stock == null) {
      if (isBack) Get.back();
      return;
    }
    final db = Get.find<DatabaseManager>().db;
    final content = quillController.document.toPlainText();
    if (content.trim().isEmpty) {
      if (!_hasLocalNote) {
        QsHud.showToast(TextKey.shuruneirongtishi.tr);
        return;
      }
      //已有笔记被删空 -> 清空笔记
      await db.updateStockRNote(stock.id, null);
      QsHud.showToast(TextKey.baocun.tr + TextKey.success.tr);
      if (isBack) {
        canPop = true;
        Get.back();
      }
      return;
    }
    // 自动识别股票代码/名称并包装为可点击的 link
    await _wrapStockLinks();
    final encodedContent =
        jsonEncode(quillController.document.toDelta().toJson());
    await db.updateStockRNote(stock.id, encodedContent);
    stockData.value = stock.copyWith(rNote: Value(encodedContent));
    QsHud.showToast(TextKey.baocun.tr + TextKey.success.tr);
    if (isBack) {
      canPop = true;
      Get.back();
    }
  }

  //显示选择颜色弹窗
  void showColorPicker() {
    SmartDialog.show(
      alignment: Alignment.bottomCenter,
      animationTime: 0.milliseconds,
      maskColor: Colors.transparent,
      builder: (_) {
        final keyboardHeight = MediaQuery.of(_).viewInsets.bottom;

        return Padding(
          padding: EdgeInsets.only(bottom: keyboardHeight),
          child: ColorSelectorRow(
            initialColor: currentTextColor.value,
            onColorSelected: (selectedColor) {
              QsHud.dismiss();
              // 执行颜色选择后的逻辑
              if (selectedColor == Get.theme.colorScheme.onSurface) {
                //清除颜色
                quillController.formatSelection(
                  Attribute.fromKeyValue('color', null),
                );
              } else {
                quillController.formatSelection(
                  Attribute.fromKeyValue(
                    'color',
                    colorToHex(selectedColor),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  String colorToHex(Color color) =>
      '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';

  void _updateCurrentTextColor() {
    final style = quillController.getSelectionStyle();
    final attr = style.attributes[Attribute.color.key];
    if (attr != null && attr.value != null) {
      currentTextColor.value = _fromHex(attr.value);
    } else {
      currentTextColor.value = Get.theme.colorScheme.onSurface;
    }
  }

  /// 点击空白区域：聚焦编辑器（进入编辑状态），光标移到文末
  void focusEditorToEnd() {
    editorFocusNode.requestFocus();
    quillController.moveCursorToEnd();
  }

  /// 处理笔记中股票链接的点击事件
  Future<void> handleLinkTap(String link) async {
    final code = StockLinkUtils.parseStockCodeFromLink(link);
    if (code == null) return;

    final db = Get.find<DatabaseManager>().db;
    // 数据库中 code 可能是小写，优先尝试小写查询
    var stockItem = await db.getStockItemWithTagsByCode(code.toLowerCase());
    stockItem ??= await db.getStockItemWithTagsByCode(code);

    if (stockItem != null) {
      Get.toNamed(Routes.STOCKEDIT, arguments: stockItem);
    } else {
      QsHud.showToast('未找到该股票记录');
    }
  }

  Color _fromHex(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex'; // 添加不透明度
    }
    return Color(int.parse(hex, radix: 16));
  }
}
