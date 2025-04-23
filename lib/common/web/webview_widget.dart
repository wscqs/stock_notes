import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../utils/qs_hud.dart';

///需要加载的内容类型
enum WebViewType {
  // html文本
  HTMLTEXT,
  // 链接
  URL
}

///定义js通信回调方法
typedef JsChannelCallback = dynamic Function(List<dynamic> arguments);

///封装的WebView组件
class WebViewWidget extends StatefulWidget {
  const WebViewWidget(
      {super.key,
      required this.webViewType,
      required this.loadResource,
      this.jsChannelMap,
      this.onWebViewCreated,
      this.clearCache});

  // 需要加载的内容类型
  final WebViewType webViewType;

  // 给webview加载的数据，可以是url，也可以是html文本
  final String loadResource;

  // 是否清除缓存后再加载
  final bool? clearCache;

  // 与js通信的channel集合
  final Map<String, JsChannelCallback>? jsChannelMap;

  // WebView创建时的回调
  final Function(InAppWebViewController controller)? onWebViewCreated;

  @override
  State<StatefulWidget> createState() {
    return _WebViewWidgetState();
  }
}

class _WebViewWidgetState extends State<WebViewWidget> {
  late InAppWebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    if (widget.clearCache == true) {
      InAppWebViewController.clearAllCache();
    }
  }

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrlRequest: widget.webViewType == WebViewType.HTMLTEXT
          ? URLRequest(
              url: WebUri(Uri.dataFromString(
              widget.loadResource,
              mimeType: 'text/html',
              encoding: Encoding.getByName('utf-8'),
            ).toString()))
          : URLRequest(url: WebUri(widget.loadResource)),
      onWebViewCreated: (InAppWebViewController controller) {
        _webViewController = controller;
        // 调用创建回调
        if (widget.onWebViewCreated != null) {
          widget.onWebViewCreated!(controller);
        }

        // 设置 JS 通信
        if (widget.jsChannelMap != null) {
          widget.jsChannelMap!.forEach((channel, callback) {
            _webViewController.addJavaScriptHandler(
                handlerName: channel, callback: callback);
          });
        }
      },
      onLoadStart: (InAppWebViewController controller, Uri? url) {
        setState(() {
          QsHud.showLoading(duration: const Duration(seconds: 45));
        });
      },
      onLoadStop: (InAppWebViewController controller, Uri? url) {
        setState(() {
          QsHud.dismiss(); // 页面停止加载，更新状态为 false
        });
      },
      onProgressChanged: (InAppWebViewController controller, int progress) {
        // 可以根据 progress 更新加载进度条
      },
      onConsoleMessage:
          (InAppWebViewController controller, ConsoleMessage message) {
        print(message.message); // 输出控制台信息
      },
    );
  }

  @override
  void dispose() {
    // 清理 WebView
    _webViewController.dispose();
    super.dispose();
  }
}
