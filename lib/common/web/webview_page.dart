import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stock_notes/common/web/webview_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/qs_hud.dart';

///显示网页资源的页面
class WebViewPage extends StatefulWidget {
  const WebViewPage({
    super.key,
    required this.loadResource,
    this.webViewType = WebViewType.URL,
    this.showTitle = true,
    this.title,
    this.jsChannelMap,
  });

  //是否显示标题
  final bool? showTitle;

  //标题内容
  final String? title;

  //需要加载的内容类型
  final WebViewType webViewType;

  //给webview加载的数据,可以是url，也可以是html文本
  final String loadResource;

  //与js通信的channel集合
  final Map<String, JsChannelCallback>? jsChannelMap;

  @override
  State<StatefulWidget> createState() {
    return _WebViewPageState();
  }
}

class _WebViewPageState extends State<WebViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (widget.showTitle ?? false)
          ? AppBar(
              title: _buildAppBarTitle(widget.showTitle, widget.title),
              centerTitle: true,
              // leading: Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     IconButton(
              //       icon: Icon(Icons.arrow_back_ios_new),
              //       onPressed: () {
              //         if (_webViewController.canGoBack()) {
              //           _webViewController.goBack();
              //         } else {
              //           Navigator.pop(context);
              //         }
              //       },
              //     ),
              //     IconButton(
              //       icon: Icon(
              //         Icons.home_outlined,
              //         size: 30,
              //       ),
              //       onPressed: () {
              //         Navigator.pop(context);
              //       },
              //     ),
              //   ],
              // ),
              // leadingWidth: 100,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: _copyUrlToClipboard,
                ),
                IconButton(
                  icon: const Icon(Icons.open_in_browser),
                  onPressed: _openBrowser,
                ),
              ],
            )
          : null,
      body: SafeArea(
        child: WebViewWidget(
          webViewType: widget.webViewType,
          loadResource: widget.loadResource,
          jsChannelMap: widget.jsChannelMap,
        ),
      ),
    );
  }

  void _copyUrlToClipboard() {
    // 设置数据到剪切板
    Clipboard.setData(ClipboardData(text: widget.loadResource));
    QsHud.showToast("Copy successful");
  }

  void _openBrowser() async {
    Uri uri = Uri.parse(widget.loadResource);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  Widget _buildAppBarTitle(bool? showTitle, String? title) {
    var show = showTitle ?? false;
    return show
        ? Text(
            title ?? "",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          )
        : const SizedBox.shrink();
  }

  String limitsStr(String? content, {int limit = 15}) {
    if (content == null || content.isEmpty == true) {
      return "";
    }
    if (content.length > 15) {
      return content.substring(0, 15);
    } else {
      return content;
    }
  }
}
