import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockSearchField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onClear;
  final VoidCallback onSubmit;
  final String hintText;
  final RxString stockValue;

  const StockSearchField({
    super.key,
    required this.controller,
    required this.onClear,
    required this.onSubmit,
    required this.hintText,
    required this.stockValue,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (stockValue.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClear,
                ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8, right: 12, bottom: 8, top: 8),
                child: FilledButton(
                  onPressed: onSubmit,
                  child: const Text("Sure"),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
