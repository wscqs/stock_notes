import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/langs/text_key.dart';

class StockSearchField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onClear;
  final VoidCallback onSubmit;
  final String hintText;
  final RxString stockValue;
  final FocusNode? focusNode;

  const StockSearchField({
    super.key,
    required this.controller,
    required this.onClear,
    required this.onSubmit,
    required this.hintText,
    required this.stockValue,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SizedBox(
        height: 44,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
            prefixIconConstraints:
                BoxConstraints(minWidth: 40, minHeight: 40), // 限制Icon尺寸
            prefixIcon: Padding(
              padding:
                  const EdgeInsets.only(left: 12, right: 8), // 控制Icon和文本的距离
              child: Icon(Icons.search, size: 20),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(23.0),
            ),
            // contentPadding: const EdgeInsets.symmetric(
            //   horizontal: 16.0,
            //   vertical: 12.0,
            // ),
            suffixIcon: stockValue.isNotEmpty
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: onClear,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 12, bottom: 8, top: 8),
                        child: FilledButton(
                          onPressed: onSubmit,
                          style: FilledButton.styleFrom(
                            minimumSize: Size(0, 30), // 设高
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 0),
                          ),
                          child: Text(
                            TextKey.search.tr,
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      )
                    ],
                  )
                : null,
          ),
        ),
      );
    });
  }
}
