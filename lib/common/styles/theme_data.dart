import 'package:flutter/material.dart';
import 'package:stock_notes/common/styles/theme.dart';

//https://juejin.cn/post/7292323968853704714
//https://material-foundation.github.io/material-theme-builder/
class AppTheme {
  // static const String Font_Montserrat = 'Montserrat';

  // static const String Font_Yuang = 'YuYang';

  // static const Color themeColor = Color(0xFFE73B26);
  //
  // static const Color secondaryColor = Colors.orange;
  //
  // static const Color darkThemeColor = Color(0xFF032896);

  /// 亮色主题样式
  static ThemeData light = ThemeData(
    colorScheme: MaterialTheme.lightScheme(),
    // fontFamily: Font_Montserrat,
    // scaffoldBackgroundColor: Color.fromRGBO(249, 249, 249, 1.0),
    // colorScheme: ColorScheme.fromSeed(
    //   seedColor: themeColor,
    //   primary: themeColor,
    //   secondary: secondaryColor,
    //   brightness: Brightness.light,
    //   surface: Colors.white,
    //   surfaceTint: Colors.transparent,
    // ),
    // appBarTheme: const AppBarTheme(
    //   backgroundColor: Colors.white,
    //   foregroundColor: Color.fromARGB(200, 0, 0, 0),
    //   centerTitle: true,
    //   titleTextStyle: TextStyle(
    //     fontSize: 18,
    //     fontWeight: FontWeight.bold,
    //     color: Color.fromARGB(200, 0, 0, 0),
    //   ),
    // ),
    // cardColor: Colors.white,
    // cardTheme: const CardTheme(
    //   color: Colors.white,
    // ),
  );

  /// 暗色主题样式
  static ThemeData dark = ThemeData(
    colorScheme: MaterialTheme.darkScheme(),
    // fontFamily: Font_Montserrat,
    //   scaffoldBackgroundColor: Colors.black.withAlpha(222),
    //   colorScheme: ColorScheme.fromSeed(
    //     seedColor: darkThemeColor,
    //     brightness: Brightness.dark,
    //     surface: const Color.fromARGB(255, 42, 42, 42),
    //     surfaceTint: Colors.transparent,
    //   ),
    //   appBarTheme: const AppBarTheme(
    //     backgroundColor: Color.fromARGB(255, 34, 34, 34),
    //     centerTitle: true,
    //     titleTextStyle: TextStyle(
    //       fontSize: 18,
    //       fontWeight: FontWeight.bold,
    //     ),
    //   ),
    //   bottomAppBarTheme: const BottomAppBarTheme(
    //     color: Color.fromARGB(255, 34, 34, 34),
    //   ),
    //   cardColor: Colors.black,
    //   cardTheme: const CardTheme(
    //       // color: Colors.white,
    //       ),
  );
}
