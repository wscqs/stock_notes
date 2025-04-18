import 'dart:ui';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:stock_notes/common/langs/text_key.dart';

//国际化学习，这边用的是getx （getx动态切换语言,intl不支持动态）
//https://blog.csdn.net/ZCC361571217/article/details/140390890
//https://www.jianshu.com/p/7512bd4d8d37
class TranslationLibrary extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'zh': zh,
        'en': en,
      };

  // 默认语言 Locale(语言代码, 国家代码)
  static const fallbackLocale = Locale('zh', 'CN');

  static const supportedLocales = [
    Locale('zh', 'CN'),
    Locale('en', 'US'),
  ];

  static const localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    FlutterQuillLocalizations.delegate,
  ];
}
