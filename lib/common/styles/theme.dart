import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff6d5e0f),
      surfaceTint: Color(0xff6d5e0f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xfff8e287),
      onPrimaryContainer: Color(0xff221b00),
      secondary: Color(0xff665e40),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffeee2bc),
      onSecondaryContainer: Color(0xff211b04),
      tertiary: Color(0xff43664e),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffc5ecce),
      onTertiaryContainer: Color(0xff00210f),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfffff9ee),
      onSurface: Color(0xff1e1b13),
      onSurfaceVariant: Color(0xff4b4739),
      outline: Color(0xff7c7767),
      outlineVariant: Color(0xffcdc6b4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff333027),
      inversePrimary: Color(0xffdbc66e),
      primaryFixed: Color(0xfff8e287),
      onPrimaryFixed: Color(0xff221b00),
      primaryFixedDim: Color(0xffdbc66e),
      onPrimaryFixedVariant: Color(0xff534600),
      secondaryFixed: Color(0xffeee2bc),
      onSecondaryFixed: Color(0xff211b04),
      secondaryFixedDim: Color(0xffd1c6a1),
      onSecondaryFixedVariant: Color(0xff4e472a),
      tertiaryFixed: Color(0xffc5ecce),
      onTertiaryFixed: Color(0xff00210f),
      tertiaryFixedDim: Color(0xffa9d0b3),
      onTertiaryFixedVariant: Color(0xff2c4e38),
      surfaceDim: Color(0xffe0d9cc),
      surfaceBright: Color(0xfffff9ee),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffaf3e5),
      surfaceContainer: Color(0xfff4eddf),
      surfaceContainerHigh: Color(0xffeee8da),
      surfaceContainerHighest: Color(0xffe8e2d4),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff4f4200),
      surfaceTint: Color(0xff6d5e0f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff857425),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff4a4327),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff7d7455),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff284a34),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff597d64),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff9ee),
      onSurface: Color(0xff1e1b13),
      onSurfaceVariant: Color(0xff474335),
      outline: Color(0xff645f50),
      outlineVariant: Color(0xff807a6b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff333027),
      inversePrimary: Color(0xffdbc66e),
      primaryFixed: Color(0xff857425),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff6b5b0c),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff7d7455),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff645c3e),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff597d64),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff41644c),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe0d9cc),
      surfaceBright: Color(0xfffff9ee),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffaf3e5),
      surfaceContainer: Color(0xfff4eddf),
      surfaceContainerHigh: Color(0xffeee8da),
      surfaceContainerHighest: Color(0xffe8e2d4),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff292200),
      surfaceTint: Color(0xff6d5e0f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff4f4200),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff282209),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff4a4327),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff042815),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff284a34),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff9ee),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff272418),
      outline: Color(0xff474335),
      outlineVariant: Color(0xff474335),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff333027),
      inversePrimary: Color(0xffffeca2),
      primaryFixed: Color(0xff4f4200),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff352c00),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff4a4327),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff332d13),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff284a34),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff10331f),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe0d9cc),
      surfaceBright: Color(0xfffff9ee),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffaf3e5),
      surfaceContainer: Color(0xfff4eddf),
      surfaceContainerHigh: Color(0xffeee8da),
      surfaceContainerHighest: Color(0xffe8e2d4),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffdbc66e),
      surfaceTint: Color(0xffdbc66e),
      onPrimary: Color(0xff3a3000),
      primaryContainer: Color(0xff534600),
      onPrimaryContainer: Color(0xfff8e287),
      secondary: Color(0xffd1c6a1),
      onSecondary: Color(0xff363016),
      secondaryContainer: Color(0xff4e472a),
      onSecondaryContainer: Color(0xffeee2bc),
      tertiary: Color(0xffa9d0b3),
      onTertiary: Color(0xff143723),
      tertiaryContainer: Color(0xff2c4e38),
      onTertiaryContainer: Color(0xffc5ecce),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff15130b),
      onSurface: Color(0xffe8e2d4),
      onSurfaceVariant: Color(0xffcdc6b4),
      outline: Color(0xff969080),
      outlineVariant: Color(0xff4b4739),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe8e2d4),
      inversePrimary: Color(0xff6d5e0f),
      primaryFixed: Color(0xfff8e287),
      onPrimaryFixed: Color(0xff221b00),
      primaryFixedDim: Color(0xffdbc66e),
      onPrimaryFixedVariant: Color(0xff534600),
      secondaryFixed: Color(0xffeee2bc),
      onSecondaryFixed: Color(0xff211b04),
      secondaryFixedDim: Color(0xffd1c6a1),
      onSecondaryFixedVariant: Color(0xff4e472a),
      tertiaryFixed: Color(0xffc5ecce),
      onTertiaryFixed: Color(0xff00210f),
      tertiaryFixedDim: Color(0xffa9d0b3),
      onTertiaryFixedVariant: Color(0xff2c4e38),
      surfaceDim: Color(0xff15130b),
      surfaceBright: Color(0xff3c3930),
      surfaceContainerLowest: Color(0xff100e07),
      surfaceContainerLow: Color(0xff1e1b13),
      surfaceContainer: Color(0xff222017),
      surfaceContainerHigh: Color(0xff2d2a21),
      surfaceContainerHighest: Color(0xff38352b),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffe0ca72),
      surfaceTint: Color(0xffdbc66e),
      onPrimary: Color(0xff1c1600),
      primaryContainer: Color(0xffa3903f),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffd6caa5),
      onSecondary: Color(0xff1b1602),
      secondaryContainer: Color(0xff9a916f),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffadd4b7),
      onTertiary: Color(0xff001b0c),
      tertiaryContainer: Color(0xff75997f),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff15130b),
      onSurface: Color(0xfffffaf5),
      onSurfaceVariant: Color(0xffd1cab8),
      outline: Color(0xffa9a292),
      outlineVariant: Color(0xff888373),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe8e2d4),
      inversePrimary: Color(0xff554700),
      primaryFixed: Color(0xfff8e287),
      onPrimaryFixed: Color(0xff161100),
      primaryFixedDim: Color(0xffdbc66e),
      onPrimaryFixedVariant: Color(0xff403600),
      secondaryFixed: Color(0xffeee2bc),
      onSecondaryFixed: Color(0xff161100),
      secondaryFixedDim: Color(0xffd1c6a1),
      onSecondaryFixedVariant: Color(0xff3c361b),
      tertiaryFixed: Color(0xffc5ecce),
      onTertiaryFixed: Color(0xff001508),
      tertiaryFixedDim: Color(0xffa9d0b3),
      onTertiaryFixedVariant: Color(0xff1b3d28),
      surfaceDim: Color(0xff15130b),
      surfaceBright: Color(0xff3c3930),
      surfaceContainerLowest: Color(0xff100e07),
      surfaceContainerLow: Color(0xff1e1b13),
      surfaceContainer: Color(0xff222017),
      surfaceContainerHigh: Color(0xff2d2a21),
      surfaceContainerHighest: Color(0xff38352b),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffffaf5),
      surfaceTint: Color(0xffdbc66e),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffe0ca72),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffffaf5),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffd6caa5),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffeffff0),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffadd4b7),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff15130b),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfffffaf5),
      outline: Color(0xffd1cab8),
      outlineVariant: Color(0xffd1cab8),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe8e2d4),
      inversePrimary: Color(0xff322a00),
      primaryFixed: Color(0xfffde78b),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffe0ca72),
      onPrimaryFixedVariant: Color(0xff1c1600),
      secondaryFixed: Color(0xfff2e7c0),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffd6caa5),
      onSecondaryFixedVariant: Color(0xff1b1602),
      tertiaryFixed: Color(0xffc9f0d2),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffadd4b7),
      onTertiaryFixedVariant: Color(0xff001b0c),
      surfaceDim: Color(0xff15130b),
      surfaceBright: Color(0xff3c3930),
      surfaceContainerLowest: Color(0xff100e07),
      surfaceContainerLow: Color(0xff1e1b13),
      surfaceContainer: Color(0xff222017),
      surfaceContainerHigh: Color(0xff2d2a21),
      surfaceContainerHighest: Color(0xff38352b),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.surface,
     canvasColor: colorScheme.surface,
  );

  /// Custom Color 1
  static const customColor1 = ExtendedColor(
    seed: Color(0xffa9a369),
    value: Color(0xffa9a369),
    light: ColorFamily(
      color: Color(0xff666014),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffeee58c),
      onColorContainer: Color(0xff1f1c00),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff666014),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffeee58c),
      onColorContainer: Color(0xff1f1c00),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff666014),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffeee58c),
      onColorContainer: Color(0xff1f1c00),
    ),
    dark: ColorFamily(
      color: Color(0xffd1c973),
      onColor: Color(0xff353100),
      colorContainer: Color(0xff4d4800),
      onColorContainer: Color(0xffeee58c),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffd1c973),
      onColor: Color(0xff353100),
      colorContainer: Color(0xff4d4800),
      onColorContainer: Color(0xffeee58c),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffd1c973),
      onColor: Color(0xff353100),
      colorContainer: Color(0xff4d4800),
      onColorContainer: Color(0xffeee58c),
    ),
  );

  /// Custom Color 2
  static const customColor2 = ExtendedColor(
    seed: Color(0xfff272f9),
    value: Color(0xfff272f9),
    light: ColorFamily(
      color: Color(0xff7d4e7d),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffd6fa),
      onColorContainer: Color(0xff320935),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff7d4e7d),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffd6fa),
      onColorContainer: Color(0xff320935),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff7d4e7d),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffd6fa),
      onColorContainer: Color(0xff320935),
    ),
    dark: ColorFamily(
      color: Color(0xffeeb4ea),
      onColor: Color(0xff4a204c),
      colorContainer: Color(0xff633664),
      onColorContainer: Color(0xffffd6fa),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffeeb4ea),
      onColor: Color(0xff4a204c),
      colorContainer: Color(0xff633664),
      onColorContainer: Color(0xffffd6fa),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffeeb4ea),
      onColor: Color(0xff4a204c),
      colorContainer: Color(0xff633664),
      onColorContainer: Color(0xffffd6fa),
    ),
  );


  List<ExtendedColor> get extendedColors => [
    customColor1,
    customColor2,
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
