import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'langs/translation_library.dart';

/// 语言改变的回调
typedef LocaleChangeCallback = Function(Locale locale);

/// 全局服务 (主要语言与主题)
class GlobalService extends GetxService {
  static GlobalService get to => Get.find();
  late SharedPreferences sharedPreferences;
  static const String themeCodeKey = 'themeCodeKey';
  static const String languageCodeKey = 'languageCodeKey';

  //主题
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  var rxThemeMode = Rx<ThemeMode>(ThemeMode.system);
  Rx<Locale> rxLocale = Rx<Locale>(PlatformDispatcher.instance.locale);

  //语言
  Locale locale = PlatformDispatcher.instance.locale;
  LocaleChangeCallback? localeChangeCallback;

  Future<GlobalService> init({
    List<Locale>? supportedLocales,
    LocaleChangeCallback? localeChangeCallback,
  }) async {
    // WidgetsBinding.instance.addObserver(this);
    sharedPreferences = await SharedPreferences.getInstance();
    this.localeChangeCallback = localeChangeCallback;
    //初始化本地语言配置
    _initLocale(supportedLocales);
    //初始化主题配置
    _initTheme();
    return this;
  }

  /// 设置语言变更回调
  void setLocaleChangeCallback(LocaleChangeCallback? localeChangeCallback) {
    this.localeChangeCallback = localeChangeCallback;
  }

  /// 系统当前是否是暗黑模式
  bool isDarkModel(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark;
  }

  /// 初始 theme
  void _initTheme() {
    var themeCode = sharedPreferences.getString(themeCodeKey) ?? 'system';
    switch (themeCode) {
      case 'system':
        _themeMode = ThemeMode.system;
        break;
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
    }
    rxThemeMode.value = _themeMode;
  }

  /// 更改主题
  Future<void> changeThemeMode(ThemeMode themeMode) async {
    _themeMode = themeMode;
    rxThemeMode.value = _themeMode;
    Get.changeThemeMode(_themeMode);
    if (_themeMode == ThemeMode.system) {
      await sharedPreferences.setString(themeCodeKey, 'system');
    } else {
      await sharedPreferences.setString(
          themeCodeKey, themeMode == ThemeMode.dark ? 'dark' : 'light');
    }
    // updateNavigationBar();
    refreshAppui();
  }

  // 初始化本地语言配置
  void _initLocale(List<Locale>? supportedLocales) {
    supportedLocales ??= TranslationLibrary.supportedLocales;
    var langCode = sharedPreferences.getString(languageCodeKey) ?? '';
    if (langCode.isEmpty) {
      langCode = "zh";
      // return;
    }
    var index = supportedLocales.indexWhere((element) {
      return element.languageCode == langCode;
    });
    if (index < 0) {
      return;
    }
    locale = supportedLocales[index];
    rxLocale.value = locale;
    localeChangeCallback?.call(locale);
  }

  // 更改语言
  Future<void> changeLocale(Locale value) async {
    locale = value;
    rxLocale.value = locale;
    localeChangeCallback?.call(locale);
    await sharedPreferences.setString(languageCodeKey, value.languageCode);
    Get.updateLocale(value);
    // refreshAppui();
  }

  void refreshAppui() {
    // eventBus.emit("refreshAppui");
  }
}
