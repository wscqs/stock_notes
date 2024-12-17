import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ElevatedButtonCarrot extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;

  const ElevatedButtonCarrot({
    super.key,
    this.text = "",
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.orange),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        minimumSize: WidgetStateProperty.all(Size(double.infinity, 45.h)),
      ),
      child: Text(
        text!,
        style: TextStyle(color: Colors.white, fontSize: 16.sp),
      ),
    );
  }
}
