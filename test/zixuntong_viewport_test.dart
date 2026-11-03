import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('资讯阅读弹窗为动态视口高度提供 WebView 兼容回退', () {
    final html = File('assets/html/zixuntong.html').readAsStringSync();

    // 不支持或错误解析 dvh 的 Android WebView 必须先使用 vh。
    expect(
      RegExp(r'\.app\{[^}]*min-height:100vh;[^}]*min-height:100dvh;')
          .hasMatch(html),
      isTrue,
    );
    expect(
      RegExp(r'\.spanel\{[^}]*max-height:88vh;[^}]*max-height:88dvh;')
          .hasMatch(html),
      isTrue,
    );
    expect(
      RegExp(r'\.sheet\{[^}]*height:88vh;[^}]*height:88dvh;').hasMatch(html),
      isTrue,
    );
  });
}
