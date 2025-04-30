import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/langs/text_key.dart';

import '../controllers/noteedit_controller.dart';

class NoteeditView extends GetView<NoteeditController> {
  const NoteeditView({super.key});

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
            title: Text(TextKey.biji.tr),
            actions: [
              ElevatedButton(
                  onPressed: controller.save, child: Text(TextKey.baocun.tr))
            ],
          ),
          body: SafeArea(
            child: Stack(
              children: [
                CustomScrollView(
                  controller: controller.editorScrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: buildTitleTextField(),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 4, bottom: 12),
                        child: Divider(
                            thickness: 0.5,
                            color: Colors.grey.withValues(alpha: 0.5)),
                      ),
                    ),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 16),
                          child: buildQuillEditor()),
                    ),
                    if (controller.isEditing.value)
                      SliverToBoxAdapter(
                          child: SizedBox(
                        height: 52,
                      )),
                  ],
                ),
                if (controller.isEditing.value)
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: buildQuillSimpleToolbar()),
              ],
            ),
          ),
          // body: SafeArea(
          //   child: Column(
          //     children: [
          //       buildTitleTextField(),
          //       Expanded(
          //         child: buildQuillEditor(),
          //       ),
          //       if (controller.isEditing.value) buildQuillSimpleToolbar(),
          //     ],
          //   ),
          // ),
        ),
      );
    });
  }

  Padding buildTitleTextField() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
      child: TextField(
        controller: controller.titleController,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          hintText: TextKey.biaoti.tr,
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  QuillEditor buildQuillEditor() {
    return QuillEditor(
      focusNode: controller.editorFocusNode,
      scrollController: controller.editorScrollController,
      controller: controller.quillController,
      config: QuillEditorConfig(
        scrollable: false,
        placeholder: '',
        scrollBottomInset: 40,
        // padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        // embedBuilders: [
        // ...FlutterQuillEmbeds.editorBuilders(
        //   imageEmbedConfig: QuillEditorImageEmbedConfig(
        //     imageProviderBuilder: (context, imageUrl) {
        //       // https://pub.dev/packages/flutter_quill_extensions#-image-assets
        //       if (imageUrl.startsWith('assets/')) {
        //         return AssetImage(imageUrl);
        //       }
        //       return null;
        //     },
        //   ),
        // videoEmbedConfig: QuillEditorVideoEmbedConfig(
        //   customVideoBuilder: (videoUrl, readOnly) {
        //     // To load YouTube videos https://github.com/singerdmx/flutter-quill/releases/tag/v10.8.0
        //     return null;
        //   },
        // ),
        // ),
        // TimeStampEmbedBuilder(),
        // ],
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
          // embedButtons: FlutterQuillEmbeds.toolbarButtons(), //等以后有服务器再添
          // multiRowsDisplay: false,
          showFontFamily: false,
          showFontSize: false,
          // showBoldButton: false,
          showItalicButton: false,
          showSmallButton: false,
          showUnderLineButton: false,
          showStrikeThrough: false,
          showInlineCode: false,
          // showColorButton: false,
          showBackgroundColorButton: false,
          // showClearFormat: false,
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
          // showDividers: false,
          // customButtons: [
          //   QuillToolbarCustomButtonOptions(
          //     icon: const Icon(Icons.add_alarm_rounded),
          //     onPressed: () {
          //       _controller.document.insert(
          //         _controller.selection.extentOffset,
          //         TimeStampEmbed(
          //           DateTime.now().toString(),
          //         ),
          //       );
          //
          //       _controller.updateSelection(
          //         TextSelection.collapsed(
          //           offset: _controller.selection.extentOffset + 1,
          //         ),
          //         ChangeSource.local,
          //       );
          //     },
          //   ),
          // ],
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

class TimeStampEmbed extends Embeddable {
  const TimeStampEmbed(
    String value,
  ) : super(timeStampType, value);

  static const String timeStampType = 'timeStamp';

  static TimeStampEmbed fromDocument(Document document) =>
      TimeStampEmbed(jsonEncode(document.toDelta().toJson()));

  Document get document => Document.fromJson(jsonDecode(data));
}

class TimeStampEmbedBuilder extends EmbedBuilder {
  @override
  String get key => 'timeStamp';

  @override
  String toPlainText(Embed node) {
    return node.value.data;
  }

  @override
  Widget build(
    BuildContext context,
    EmbedContext embedContext,
  ) {
    return Row(
      children: [
        const Icon(Icons.access_time_rounded),
        Text(embedContext.node.value.data as String),
      ],
    );
  }
}
