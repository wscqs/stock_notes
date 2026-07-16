import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/langs/text_key.dart';

import '../../noteedit/views/noteedit_view.dart' show TimeStampEmbedBuilder;
import '../controllers/stocknote_controller.dart';

/// 股票笔记页：参考笔记编辑页，导航标题为股票名，右侧保存，
/// 内容区无标题，全部为富文本编辑区
class StocknoteView extends GetView<StocknoteController> {
  const StocknoteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return PopScope(
        canPop: controller.canPop, // 动态控制返回手势是否生效
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return; // 已处理弹出则直接返回
          final allowed = await controller.handlePop();
          if (allowed) {
            //不保存也后退
            Get.back(); // 手动触发返回
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Column(
              children: [
                Text(controller.stockData.value?.name ?? TextKey.biji.tr),
                if ((controller.stockData.value?.currentPrice ?? "")
                    .isNotEmpty)
                  Text(
                    controller.stockData.value!.currentPrice!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Get.theme.colorScheme.onSurface,
                    ),
                  ),
              ],
            ),
            centerTitle: true,
            actions: [
              ElevatedButton(
                  onPressed: controller.save, child: Text(TextKey.baocun.tr))
            ],
          ),
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: controller.editorScrollController,
                  child: Container(
                    color: Get.theme.scaffoldBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildQuillEditor(),
                          const SizedBox(height: 52),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: buildQuillSimpleToolbar()),
              ],
            ),
          ),
        ),
      );
    });
  }

  QuillEditor buildQuillEditor() {
    return QuillEditor(
      focusNode: controller.editorFocusNode,
      scrollController: controller.quillScrollController,
      controller: controller.quillController,
      config: QuillEditorConfig(
        scrollable: false,
        placeholder: '',
        scrollBottomInset: 40,
        onLaunchUrl: (link) {
          controller.handleLinkTap(link);
        },
        customLinkPrefixes: const ['stocknotes://'],
        embedBuilders: [
          ...FlutterQuillEmbeds.editorBuilders(
            imageEmbedConfig: QuillEditorImageEmbedConfig(
              imageProviderBuilder: (context, imageUrl) {
                // https://pub.dev/packages/flutter_quill_extensions#-image-assets
                if (imageUrl.startsWith('assets/')) {
                  return AssetImage(imageUrl);
                }
                return null;
              },
            ),
          ),
          TimeStampEmbedBuilder(),
        ],
      ),
    );
  }

  Widget buildQuillSimpleToolbar() {
    return Container(
      width: double.infinity,
      color: Get.theme.colorScheme.surface,
      child: QuillSimpleToolbar(
        controller: controller.quillController,
        config: QuillSimpleToolbarConfig(
          embedButtons: FlutterQuillEmbeds.toolbarButtons(
              videoButtonOptions: null), //启用图片插入功能
          showFontFamily: false,
          showFontSize: false,
          showSmallButton: false,
          showUnderLineButton: false,
          showStrikeThrough: false,
          showInlineCode: false,
          showColorButton: false,
          showBackgroundColorButton: false,
          showCodeBlock: false,
          showListNumbers: false,
          showListBullets: false,
          showIndent: false,
          showSubscript: false,
          showSuperscript: false,
          showQuote: false,
          showSearchButton: false,
          showHeaderStyle: false,
          showLineHeightButton: false,
          showListCheck: false,
          showDividers: false,
          showLink: false,
          customButtons: [
            //颜色选择
            QuillToolbarCustomButtonOptions(
                icon: Icon(
                  Icons.color_lens_rounded,
                  color: controller.currentTextColor.value,
                ),
                onPressed: () {
                  controller.showColorPicker();
                }),
          ],
          buttonOptions: QuillSimpleToolbarButtonOptions(
            base: QuillToolbarBaseButtonOptions(
              afterButtonPressed: () {
                final isDesktop = {
                  TargetPlatform.linux,
                  TargetPlatform.windows,
                  TargetPlatform.macOS
                }.contains(defaultTargetPlatform);
                if (isDesktop) {
                  controller.editorFocusNode.requestFocus();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
