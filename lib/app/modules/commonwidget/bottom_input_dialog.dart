import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/langs/text_key.dart';

import '../../../common/comment_style.dart';

typedef onSendCallback = void Function(String? value);

class BottomInputDialog extends StatefulWidget {
  final String? hintText;
  final onSendCallback? onSendPressed;
  final String? text;

  const BottomInputDialog(
      {super.key, this.hintText, this.onSendPressed, this.text});

  @override
  State<BottomInputDialog> createState() => _BottomInputDialogState();
}

class _BottomInputDialogState extends State<BottomInputDialog> {
  final TextEditingController controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _focusNode.requestFocus();
      controller.text = widget.text ?? "";
    });
    super.initState();
  }

  //【Flutter】应用中弹窗与软键盘互动/交互的几种方式
  //https://juejin.cn/post/7278239421705519140
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: 156, // 控件高度
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          // color: kColorGg,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 10.0),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 124,
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: widget.hintText ?? "Please enter content",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      ),
                      keyboardType: TextInputType.text,
                      focusNode: _focusNode,
                      maxLines: null, // Allow multi-line input
                      expands: true,
                      textAlign: TextAlign.left, // 水平对齐：左对齐
                      textAlignVertical: TextAlignVertical.top,
                      maxLength: 60,
                    ),
                  ),
                ),
                kSpaceW(12),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ElevatedButton(
                    child: Text(TextKey.baocun.tr),
                    onPressed: () {
                      // 确定操作
                      String text = controller.text;
                      widget.onSendPressed?.call(text);
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 显示底部输入控件的方法
void showBottomInputDialog(
    {String? hintText, String? text, onSendCallback? onSendPressed}) {
  SmartDialog.show(
    builder: (context) {
      return BottomInputDialog(
        hintText: hintText,
        text: text,
        onSendPressed: onSendPressed,
      );
    },
    alignment: Alignment.bottomCenter,
  );
}
