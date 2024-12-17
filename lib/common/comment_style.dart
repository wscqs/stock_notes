import 'package:flutter/material.dart';

Color kColorGg = Color.fromRGBO(205, 166, 119, 1);
Color kColorContentBg = Color.fromRGBO(255, 243, 212, 1);

Widget kSpaceW(double space) => SizedBox(width: space);
Widget kSpaceH(double space) => SizedBox(height: space);
Widget kSpaceMax() => Expanded(child: SizedBox());

// 16进制颜色转换工具类
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor; // 如果没有透明度值，添加FF作为透明度（不透明）
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
