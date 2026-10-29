import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

import '../../../../common/database/DatabaseManager.dart';
import '../../../../common/langs/text_key.dart';
import '../../../../common/web/webview_page.dart';
import '../../../routes/app_pages.dart';
import '../controllers/ballot_controller.dart';

class BallotView extends GetView<BallotController> {
  const BallotView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TextKey.xuanpiao.tr),
        centerTitle: true,
      ),
      body: Obx(() {
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: controller.items.length,
          separatorBuilder: (_, __) => Divider(
            height: 1,
            thickness: 0.5,
            indent: 16,
            endIndent: 16,
            color: Get.theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
          itemBuilder: (context, index) {
            final item = controller.items[index];
            return ListTile(
              leading: Icon(
                Remix.checkbox_multiple_line,
                color: Get.theme.colorScheme.primary,
              ),
              title: Text(
                item.title,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: Get.theme.colorScheme.onSurfaceVariant,
              ),
              onTap: () => _openWeb(item),
            );
          },
        );
      }),
    );
  }

  /// 应用内 WebView 打开。注入 `StockNotesBridge.openStock(json)` 桥，
  /// 并拦截 `stocknotes://stock?code=...` scheme 作为兜底，
  /// 页面里点股票卡片 → 把 {"code","name","market","lbts"} 交给原生打开详情页
  void _openWeb(BallotItem item) {
    Get.to(() => WebViewPage(
          loadResource: item.url,
          title: item.title,
          userScripts: [
            UserScript(
              injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
              source: '''
                (function () {
                  if (window.StockNotesBridge) return;
                  // zikzak_inappwebview 把 flutter_inappwebview 改名成了 zikzak_inappwebview
                  var bridge = window.zikzak_inappwebview;
                  if (!bridge) {
                    // 桥还没注入时先排队
                    var pending = [];
                    window.StockNotesBridge = {
                      openStock: function (json) {
                        pending.push(String(json));
                        flush();
                      }
                    };
                    function flush() {
                      if (window.zikzak_inappwebview &&
                          window.zikzak_inappwebview.callHandler) {
                        pending.splice(0).forEach(function (j) {
                          window.zikzak_inappwebview.callHandler('openStock', j);
                        });
                      }
                    }
                    var t = setInterval(flush, 200);
                    setTimeout(function () { clearInterval(t); }, 5000);
                  } else {
                    window.StockNotesBridge = {
                      openStock: function (json) {
                        window.zikzak_inappwebview.callHandler('openStock', String(json));
                      }
                    };
                  }
                })();
              ''',
            ),
          ],
          onWebViewCreated: (webController) {
            webController.addJavaScriptHandler(
              handlerName: 'openStock',
              callback: (args) {
                if (args.isNotEmpty && args.first != null) {
                  _openStockDetail(args.first.toString());
                }
              },
            );
          },
          onLoadStop: (webController, url) {
            // 页面 CSS 给沉浸式浏览器留了状态栏安全距离，
            // 在 App WebView 里会和导航栏叠加 → 这里覆盖掉（仅本页生效）
            webController.evaluateJavascript(source: '''
              (function () {
                var style = document.createElement('style');
                style.textContent =
                  '.hd{padding-top:10px!important;}' +
                  'body{padding-top:0!important;}';
                document.head.appendChild(style);
              })();
            ''');
          },
          shouldOverrideUrlLoading: (webController, url) {
            // 兜底：页面通过 location.href = 'stocknotes://stock?...' 抛出的意图
            if (url.scheme == 'stocknotes') {
              _openStockDetail(jsonEncode({
                'code': url.queryParameters['code'] ?? '',
                'name': url.queryParameters['name'] ?? '',
                'market': url.queryParameters['market'] ?? 0,
              }));
              return false; // 阻止 WebView 加载未知 scheme
            }
            return true;
          },
        ));
  }

  /// 网页回传的 {"code": "002708", "name": "光洋股份", ...} → 打开自家股票页
  void _openStockDetail(String jsonStr) {
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      final code = map['code']?.toString() ?? '';
      if (code.isEmpty) return;
      final db = Get.find<DatabaseManager>().db;
      db.getStockItem(code).then((stock) {
        if (stock != null) {
          // 本地已有这只股票：直接进详情
          Get.toNamed(Routes.STOCKEDIT, arguments: stock);
        } else {
          // 本地没有：带代码进编辑页预填
          Get.toNamed(Routes.STOCKEDIT, arguments: code);
        }
      });
    } catch (_) {}
  }
}
