import 'dart:convert';
import 'dart:io' as io show Directory, File;

import 'package:drift/drift.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' hide Value; //Value drift有用
import 'package:path/path.dart' as path;
import 'package:stock_notes/common/langs/text_key.dart';
import 'package:stock_notes/utils/qs_hud.dart';
import 'package:stock_notes/utils/share_image_util.dart';

import '../../../../common/database/DatabaseManager.dart';
import '../../../../common/database/database.dart';
import '../../../../utils/stock_link_utils.dart';
import '../../../routes/app_pages.dart';
import '../../notetagsedit/views/notetagsedit_view.dart';

class NoteeditController extends GetxController {
  final TextEditingController titleController = TextEditingController();
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
  final contentKey = GlobalKey(); // 用于截图滚动全部内容

  final localData = Rxn<NoteItem>();
  final isLocalData = false.obs;

  final isEditing = false.obs;

  final currentTextColor = Get.theme.colorScheme.onSurface.obs;
  final isShowColorPicker = false.obs;

  bool canPop = false; // 控制是否允许返回。true不拦截，false 才能进入handlePop判断
  Future<bool> handlePop() async {
    if (isLocalData.value) {
      final localContent = localData.value?.content;
      final localTitle = localData.value?.title!;
      if (localTitle == titleController.text &&
          localContent != null &&
          localContent.isNotEmpty) {
        final localDocContent =
            Document.fromJson(jsonDecode(localContent)).toPlainText();
        final currentDocContent = quillController.document.toPlainText();
        if (localDocContent == currentDocContent) {
          return true;
        }
      }
    } else {
      String content = quillController.document.toPlainText().trim();
      if (titleController.text.isEmpty && content.length == 0) return true;
    }
    // 弹出二次确认对话框
    final confirm = await showDialog<bool>(
      context: Get.context!,
      // barrierDismissible: false,
      builder: (context) => AlertDialog(
        // title: const Text('是否保存更改?'),
        content: Padding(
          padding: const EdgeInsets.only(left: 4, top: 4),
          child: Text(TextKey.shifoubaocungenggai.tr,
              style: TextStyle(fontSize: 16)),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); //第一个关闭Dialog
              Get.back();
            },
            child: Text(TextKey.bu.tr + TextKey.baocun.tr),
          ),
          TextButton(
            onPressed: () {
              save();
              Get.back();
              Get.back();
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
    //判断是否在 macOS/Windows（桌面端默认进入编辑状态）
    if (defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows) {
      isEditing.value = true;
      quillController.readOnly = false;
    } else {
      editorFocusNode.addListener(() {
        if (editorFocusNode.hasFocus) {
          // print("Editor is focused (editing).");
          isEditing.value = true;
          quillController.readOnly = false;
          // 预览态切编辑态后，等键盘弹起再触发一次光标跟随，
          // 否则 flutter_quill 内部 focus 监听未注册，光标会被键盘挡住
          _ensureCursorVisibleAfterKeyboard();
        } else {
          // print("Editor is not focused.");
          isEditing.value = false;
          quillController.readOnly = true;
        }
      });
      // 初始化时根据焦点状态设置 readOnly（已有笔记默认无焦点，进入预览状态）
      quillController.readOnly = !editorFocusNode.hasFocus;
    }
    localData.value = Get.arguments;
    if (localData.value != null) {
      isLocalData.value = true;
      _dealHasLocalDataRefreshUI();
      refreshTags();
    } else {
      //新建
      Future.delayed(500.milliseconds, () {
        editorFocusNode.requestFocus();
      });
    }
    quillController.addListener(() {
      _updateCurrentTextColor();
    });
  }

  void _dealHasLocalDataRefreshUI() {
    titleController.text = localData.value?.title ?? "";
    final content = localData.value?.content;
    if (content != null && content.isNotEmpty) {
      quillController.document = Document.fromJson(jsonDecode(content));
      // quillController.readOnly = true;
    }
  }

  @override
  void onClose() {
    quillController.dispose();
    editorScrollController.dispose();
    editorFocusNode.dispose();
    super.onClose();
  }

  /// 切换编辑/预览模式
  Future<void> toggleEditMode() async {
    if (isEditing.value) {
      // 从编辑切换到预览：先包装股票链接，再取消焦点
      await _wrapStockLinks();
      editorFocusNode.unfocus();
    } else {
      // 从预览切换到编辑：请求焦点，由 listener 自动设置 readOnly
      editorFocusNode.requestFocus();
    }
  }

  /// 键盘弹起后重新触发 flutter_quill 的光标跟随滚动。
  /// 预览态切编辑态时 flutter_quill 内部未注册 focus 监听，
  /// 点击后光标可能被键盘遮挡，需等视口稳定后再推一次 selection。
  void _ensureCursorVisibleAfterKeyboard() {
    Future.delayed(550.milliseconds, () {
      if (!editorFocusNode.hasFocus) return;
      final selection = quillController.selection;
      quillController.updateSelection(selection, ChangeSource.local);
    });
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

  //进入别的页面后后退刷新UI(现在只改变了标签）
  Future<void> refreshTags() async {
    if (isLocalData.value) {
      final db = Get.find<DatabaseManager>().db;
      var noteItem = await db.getNoteItemWithTags(localData.value!.id);
      if (noteItem != null) {
        localData.value!.tagList = noteItem.tagList;
        localData.refresh();
      }
    }
  }

  //标签
  void clickPushTag() {
    if (!isLocalData.value) {
      QsHud.showConfirmDialog(
          title: TextKey.biaoqian.tr,
          content: TextKey.cicaozuoxubaocun.tr,
          confirmText: TextKey.baocunbingcaozu.tr,
          onConfirm: () async {
            await save(isBack: false);
            if (isLocalData.value) {
              clickPushTag();
            }
          });
      return;
    }
    NoteTagseditView.show(localData.value!);
  }

  //收藏
  void clickOpCollect() {
    if (!isLocalData.value) return;
    final db = Get.find<DatabaseManager>().db;
    localData.value =
        localData.value!.copyWith(opCollect: !localData.value!.opCollect);
    localData.refresh();
    db.updateNoteWithOp(localData.value!);
  }

  //删除（已在删除列表则真正删除）
  void clickOpDelete() {
    if (!isLocalData.value) return;
    final db = Get.find<DatabaseManager>().db;
    if (localData.value!.opDelete) {
      db.deleteNote(localData.value!);
      QsHud.showToast(TextKey.delete.tr + TextKey.success.tr);
    } else {
      db.updateNoteWithOp(localData.value!.copyWith(opDelete: true));
      QsHud.showToast(TextKey.yidaoshanchuliebiao.tr);
    }
    canPop = true;
    Get.back();
  }

  Future<void> save({bool isBack = true}) async {
    //键盘隐藏
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    final db = Get.find<DatabaseManager>().db;
    String title = titleController.text;
    if (title.isEmpty) {
      String content = quillController.document.toPlainText();
      if (content.isEmpty || content.trim().isEmpty) {
        QsHud.showToast(TextKey.shuruneirongtishi.tr);
        return;
      } else {
        //标题赋值 content 前 18 个字符
        if (content.length > 18) {
          title = content.substring(0, 18);
        } else {
          title = content;
        }
      }
    }
    title = title.trim();
    // 自动识别股票代码/名称并包装为可点击的 link
    await _wrapStockLinks();
    final encodedContent = jsonEncode(quillController.document.toDelta().toJson());
    NoteItemsCompanion itemsCompanion =
        NoteItemsCompanion.insert(title: title, content: Value(encodedContent));
    if (localData.value != null) {
      //localData 更新
      NoteItemsCompanion itemUpdate = itemsCompanion.copyWith(
        id: Value(localData.value!.id),
      );
      db.addNoteOnConflictUpdate(itemUpdate);
    } else {
      final id = await db.addNote(itemsCompanion);
      localData.value = await db.getNoteItemWithTags(id);
      isLocalData.value = true;
    }
    QsHud.showToast(TextKey.baocun.tr + TextKey.success.tr);
    if (isBack) {
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

  /// 分享笔记：截图滚动全部内容
  Future<void> clickShare() async {
    if (isClosed) return;
    var subject = titleController.text.trim();
    if (subject.isEmpty) {
      final plainText = quillController.document.toPlainText().trim();
      if (plainText.isNotEmpty) {
        subject = plainText.length > 18 ? plainText.substring(0, 18) : plainText;
      }
    }
    if (subject.isEmpty) {
      subject = TextKey.biji.tr;
    }
    if (isClosed) return;
    final prefix = 'note_share_${localData.value?.id ?? DateTime.now().millisecondsSinceEpoch}';
    await ShareImageUtil.share(
      key: contentKey,
      subject: subject,
      filePrefix: prefix,
    );
  }

  Color _fromHex(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex'; // 添加不透明度
    }
    return Color(int.parse(hex, radix: 16));
  }
}

// import 'package:flutter/material.dart';

class ColorSelectorRow extends StatefulWidget {
  final Function(Color color) onColorSelected;
  final Color? initialColor;

  const ColorSelectorRow({
    super.key,
    required this.onColorSelected,
    this.initialColor,
  });

  @override
  State<ColorSelectorRow> createState() => _ColorSelectorRowState();
}

class _ColorSelectorRowState extends State<ColorSelectorRow> {
  final List<Color> _colors = [
    Colors.red,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Get.theme.colorScheme.onSurface,
    // Colors.grey,
  ];

  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor ?? _colors.last;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surface,
        // borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _colors.map((color) {
          final isSelected = color.value32bit == _selectedColor.value32bit;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedColor = color);
              widget.onColorSelected(color);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        weight: 800,
                        size: 22,
                      ),
                    )
                  : null,
            ),
          );
        }).toList(),
      ),
    );
  }
}
