import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

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
  // static ThemeData light =
  //     FlexThemeData.light(scheme: FlexScheme.redWine); //夜间红白，red是红黑
  static ThemeData light = ThemeData(
    colorScheme: FlexThemeData.light(scheme: FlexScheme.redWine).colorScheme,
    appBarTheme: AppBarTheme(
      // backgroundColor: FlexThemeData.light(scheme: FlexScheme.redWine)
      //     .colorScheme
      //     .onPrimaryContainer,
      // foregroundColor: Color.fromARGB(200, 0, 0, 0),
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: FlexThemeData.light(scheme: FlexScheme.redWine)
            .colorScheme
            .onPrimaryContainer,
      ),
    ),
    // textTheme: _textTheme,
    // colorScheme: MaterialTheme.lightScheme(),
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

    // cardColor: Colors.white,
    // cardTheme: const CardTheme(
    //   color: Colors.white,
    // ),
  );

  /// 暗色主题样式
  // static ThemeData dark = FlexThemeData.dark(scheme: FlexScheme.redWine);

  static ThemeData dark = ThemeData(
    colorScheme: FlexThemeData.dark(scheme: FlexScheme.redWine).colorScheme,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
//   colorScheme: MaterialTheme.darkScheme(),
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

// static final TextTheme _textTheme = TextTheme(
//   titleLarge: GoogleFonts.montserrat(fontWeight: _bold, fontSize: 16.0),
//   titleMedium: GoogleFonts.montserrat(fontWeight: _medium, fontSize: 16.0),
//   headlineMedium: GoogleFonts.montserrat(fontWeight: _bold, fontSize: 20.0),
//   bodySmall: GoogleFonts.oswald(fontWeight: _semiBold, fontSize: 16.0),
//   headlineSmall: GoogleFonts.oswald(fontWeight: _medium, fontSize: 16.0),
//   labelSmall: GoogleFonts.montserrat(fontWeight: _medium, fontSize: 12.0),
//   bodyLarge: GoogleFonts.montserrat(fontWeight: _regular, fontSize: 14.0),
//   titleSmall: GoogleFonts.montserrat(fontWeight: _medium, fontSize: 14.0),
//   bodyMedium: GoogleFonts.montserrat(fontWeight: _regular, fontSize: 16.0),
//   labelLarge: GoogleFonts.montserrat(fontWeight: _semiBold, fontSize: 14.0),
// );
