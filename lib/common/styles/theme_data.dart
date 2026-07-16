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
  static ThemeData light = () {
    // FlexThemeData 构建较耗时，复用一次构建结果
    final flexTheme = FlexThemeData.light(scheme: FlexScheme.redWine);
    return ThemeData(
      colorScheme: flexTheme.colorScheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: flexTheme.colorScheme.onPrimaryContainer,
        ),
      ),
      // textTheme: _textTheme,
      // fontFamily: Font_Montserrat,
    );
  }();

  /// 暗色主题样式
  // static ThemeData dark = FlexThemeData.dark(scheme: FlexScheme.redWine);
  static ThemeData dark = () {
    final flexTheme = FlexThemeData.dark(scheme: FlexScheme.redWine);
    return ThemeData(
      colorScheme: flexTheme.colorScheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      // fontFamily: Font_Montserrat,
    );
  }();
}

// static final TextTheme _textTheme = TextTheme(
//   titleLarge: GoogleFonts.montserrat(fontWeight: _bold, fontSize: 16.0),
//   titleMedium: GoogleFonts.montserrat(fontWeight: _medium, fontSize: 16.0),
//   headlineMedium: GoogleFonts.montserrat(fontWeight: _bold, fontSize: 20.0),
//   bodySmall: GoogleFonts.oswald(fontWeight: _semiBold, fontSize: 16.0),
//   headlineSmall: GoogleFonts.montserrat(fontWeight: _medium, fontSize: 18.0),
//   labelSmall: GoogleFonts.montserrat(fontWeight: _medium, fontSize: 12.0),
//   bodyLarge: GoogleFonts.oswald(fontWeight: _regular, fontSize: 14.0),
//   titleSmall: GoogleFonts.montserrat(fontWeight: _medium, fontSize: 14.0),
//   bodyMedium: GoogleFonts.montserrat(fontWeight: _regular, fontSize: 16.0),
//   labelLarge: GoogleFonts.montserrat(fontWeight: _semiBold, fontSize: 16.0),
// );
