# 股票详情页外链功能按钮 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 股票详情页「股票」行的外链按钮可配置化：多选弹窗勾选 6 个预定义外链（含 2 个本地 html），勾选项以文字小按钮显示在原按钮位置，支持预览，全局持久化。

**Architecture:** 新增 `StockExtLinks` 静态工具类承载链接定义/勾选存取/目标构建；`stockedit_controller` 增加弹窗与跳转方法；`stockedit_view` 重构 `_gupiaoinfo` 行；两个本地 html 增加 `window.APP_STOCK_CODE` 优先读取，Flutter 端加载 asset 字符串后前置注入股票代码。

**Tech Stack:** Flutter, GetX, QsCache(Hive), flutter_smart_dialog, zikzak_inappwebview, flutter_test

**Spec:** `docs/superpowers/specs/2026-07-16-stock-ext-links-design.md`

## Global Constraints

- 勾选全局存储：`QsCache`，key = `stock_ext_link_selection`，值为 `List<String>`（链接 id）。
- 默认勾选：`['kline_baidu', 'saolei_ths']`（与现状一致）。
- 6 位数字代码 = 去掉 `sh`/`sz` 前缀；`大事东` 用市场大写前缀+6 位数字（如 `SZ300848`）。
- 非 A 股（非 sh/sz 开头，或 sh5xxxxx/sz1xxxxx 基金）不显示外链按钮；`buildLoadResource` 返回 null。
- 链接标题（k线百等）固定中文，不走 i18n；弹窗标题与提示走 `TextKey`。
- 不修改 `pubspec.yaml`（assets/html/ 已声明）与数据库 schema。

---

### Task 1: StockExtLinks 工具类 + 单元测试

**Files:**
- Create: `lib/common/web/stock_ext_links.dart`
- Test: `test/stock_ext_links_test.dart`

**Interfaces:**
- Consumes: `QsCache.get/set`（`lib/utils/qs_cache.dart`，静态方法，`_box` 为 null 时 get 返回 null、set 为空操作）
- Produces:
  - `class StockExtLink { String id; String title; bool isLocalAsset; bool useMarketPrefix; String urlTemplate; }`（全字段 final，const 构造）
  - `StockExtLinks.all`（`List<StockExtLink>`，6 项）
  - `StockExtLinks.defaultSelectedIds`（`List<String>`）
  - `StockExtLinks.selectedIds()` → `List<String>`
  - `StockExtLinks.saveSelectedIds(List<String>)` → void
  - `StockExtLinks.isAStock(String code)` → `bool`
  - `StockExtLinks.buildLoadResource(StockExtLink link, String stockCode)` → `Future<String?>`

- [ ] **Step 1: Write the failing test**

创建 `test/stock_ext_links_test.dart`：

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:stock_notes/common/web/stock_ext_links.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('isAStock', () {
    test('A股返回true', () {
      expect(StockExtLinks.isAStock('sz300848'), isTrue);
      expect(StockExtLinks.isAStock('sh600519'), isTrue);
    });
    test('基金/港股/美股/空串返回false', () {
      expect(StockExtLinks.isAStock('sh510300'), isFalse);
      expect(StockExtLinks.isAStock('sz159915'), isFalse);
      expect(StockExtLinks.isAStock('hk00700'), isFalse);
      expect(StockExtLinks.isAStock('usAAPL'), isFalse);
      expect(StockExtLinks.isAStock(''), isFalse);
    });
  });

  group('buildLoadResource', () {
    test('URL类型替换6位数字代码', () async {
      final kline = StockExtLinks.all.firstWhere((l) => l.id == 'kline_baidu');
      final url = await StockExtLinks.buildLoadResource(kline, 'sz300848');
      expect(url,
          'https://pqa9p2.smartapps.baidu.com/pages/quote/quote?market=ab&type=stock&code=300848');
    });

    test('大事东使用市场大写前缀+代码', () async {
      final dashi = StockExtLinks.all.firstWhere((l) => l.id == 'dashi_em');
      expect(await StockExtLinks.buildLoadResource(dashi, 'sz300848'),
          contains('fc=SZ300848'));
      expect(await StockExtLinks.buildLoadResource(dashi, 'sh600519'),
          contains('fc=SH600519'));
    });

    test('扫雷安替换StockCode参数', () async {
      final link = StockExtLinks.all.firstWhere((l) => l.id == 'saolei_essence');
      final url = await StockExtLinks.buildLoadResource(link, 'sz300848');
      expect(url, contains('StockCode=300848'));
    });

    test('非A股返回null', () async {
      final kline = StockExtLinks.all.firstWhere((l) => l.id == 'kline_baidu');
      expect(await StockExtLinks.buildLoadResource(kline, 'hk00700'), isNull);
    });

    test('本地asset注入APP_STOCK_CODE', () async {
      final link = StockExtLinks.all.firstWhere((l) => l.id == 'gainian_ths');
      final html = await StockExtLinks.buildLoadResource(link, 'sz300848');
      expect(html, isNotNull);
      expect(html, contains('window.APP_STOCK_CODE="300848"'));
      expect(html, contains('fetchStockConcepts'));
    });
  });

  group('selectedIds', () {
    test('无缓存时返回默认勾选', () {
      // 测试环境 Hive box 未初始化，QsCache.get 返回 null → 默认值
      expect(StockExtLinks.selectedIds(), ['kline_baidu', 'saolei_ths']);
    });
    test('默认值按 all 顺序', () {
      final defaults = StockExtLinks.selectedIds();
      final order = StockExtLinks.all.map((l) => l.id).toList();
      expect(defaults, orderedEquals(order.where(defaults.contains)));
    });
  });

  group('all', () {
    test('包含6个链接且id唯一', () {
      expect(StockExtLinks.all.length, 6);
      final ids = StockExtLinks.all.map((l) => l.id).toSet();
      expect(ids.length, 6);
    });
    test('顺序为k线百/扫雷同/扫雷安/大事东/概念同/简况', () {
      expect(
          StockExtLinks.all.map((l) => l.id).toList(),
          [
            'kline_baidu',
            'saolei_ths',
            'saolei_essence',
            'dashi_em',
            'gainian_ths',
            'jiankuan',
          ]);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/stock_ext_links_test.dart`
Expected: 编译失败 — `Target of URI doesn't exist: 'package:stock_notes/common/web/stock_ext_links.dart'`

- [ ] **Step 3: Write minimal implementation**

创建 `lib/common/web/stock_ext_links.dart`：

```dart
import 'package:flutter/services.dart' show rootBundle;
import 'package:stock_notes/utils/qs_cache.dart';

/// 股票详情页可配置外链定义
class StockExtLink {
  const StockExtLink({
    required this.id,
    required this.title,
    required this.urlTemplate,
    this.isLocalAsset = false,
    this.useMarketPrefix = false,
  });

  /// 唯一标识，用于勾选存储
  final String id;

  /// 固定中文标题（如 k线百），不走 i18n
  final String title;

  /// URL 模板（含 xxxxxx 占位符）或本地 asset 路径
  final String urlTemplate;

  /// 是否本地 html asset（assets/html/ 下）
  final bool isLocalAsset;

  /// true 时 xxxxxx 替换为「市场大写前缀+6位数字」（如 SZ300848），否则替换为 6 位数字
  final bool useMarketPrefix;
}

class StockExtLinks {
  StockExtLinks._();

  static const _cacheKey = 'stock_ext_link_selection';
  static const _placeholder = 'xxxxxx';

  static const List<StockExtLink> all = [
    StockExtLink(
      id: 'kline_baidu',
      title: 'k线百',
      urlTemplate:
          'https://pqa9p2.smartapps.baidu.com/pages/quote/quote?market=ab&type=stock&code=xxxxxx',
    ),
    StockExtLink(
      id: 'saolei_ths',
      title: '扫雷同',
      urlTemplate:
          'https://bowerbird.10jqka.com.cn/thslc/editor/view/433f6d9Ac0?code=xxxxxx',
    ),
    StockExtLink(
      id: 'saolei_essence',
      title: '扫雷安',
      urlTemplate:
          'https://static.essence.com.cn/zixun/sweep-car/index.html#/pages/sweepDetails/index?StockCode=xxxxxx',
    ),
    StockExtLink(
      id: 'dashi_em',
      title: '大事东',
      urlTemplate: 'https://emh5.eastmoney.com/html/detail.html?fc=xxxxxx#/gsds',
      useMarketPrefix: true,
    ),
    StockExtLink(
      id: 'gainian_ths',
      title: '概念同',
      urlTemplate: 'assets/html/gainiantong.html',
      isLocalAsset: true,
    ),
    StockExtLink(
      id: 'jiankuan',
      title: '简况',
      urlTemplate: 'assets/html/jiankuan.html',
      isLocalAsset: true,
    ),
  ];

  static const List<String> defaultSelectedIds = ['kline_baidu', 'saolei_ths'];

  /// 读取勾选的链接 id；无缓存或缓存损坏时返回默认勾选。
  /// 返回值按 [all] 定义顺序排列。
  static List<String> selectedIds() {
    final cached = QsCache.get(_cacheKey);
    if (cached is! List) return List.of(defaultSelectedIds);
    final ids = cached.map((e) => e.toString()).toSet();
    return all.map((l) => l.id).where(ids.contains).toList();
  }

  static void saveSelectedIds(List<String> ids) {
    QsCache.set(_cacheKey, ids);
  }

  /// A 股判断：sh/sz 开头且非 sh5xxxxx、sz1xxxxx（基金）
  static bool isAStock(String code) {
    return (code.startsWith('sh') || code.startsWith('sz')) &&
        !code.startsWith('sh5') &&
        !code.startsWith('sz1');
  }

  /// 构建跳转目标：URL 类型返回替换后的 url；本地 asset 返回注入股票代码后的 html 字符串。
  /// 非 A 股返回 null。
  static Future<String?> buildLoadResource(
      StockExtLink link, String stockCode) async {
    if (!isAStock(stockCode)) return null;
    final number = stockCode.substring(2);
    if (link.isLocalAsset) {
      final html = await rootBundle.loadString(link.urlTemplate);
      return _injectStockCode(html, number);
    }
    final replacement = link.useMarketPrefix
        ? '${stockCode.substring(0, 2).toUpperCase()}$number'
        : number;
    return link.urlTemplate.replaceAll(_placeholder, replacement);
  }

  /// 在 <head> 后注入 window.APP_STOCK_CODE；无 <head> 时前置到文档开头
  static String _injectStockCode(String html, String number) {
    final injected = '<script>window.APP_STOCK_CODE="$number";</script>';
    if (html.contains('<head>')) {
      return html.replaceFirst('<head>', '<head>\n$injected');
    }
    return '$injected\n$html';
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/stock_ext_links_test.dart`
Expected: PASS（`All tests passed!`）

- [ ] **Step 5: Commit**

```bash
git add lib/common/web/stock_ext_links.dart test/stock_ext_links_test.dart
git commit -m "feat: 新增股票外链定义与勾选存储工具类 StockExtLinks"
```

---

### Task 2: 本地 html 支持 APP_STOCK_CODE + 修复明文 HTTP

**Files:**
- Modify: `assets/html/gainiantong.html`（`handleHashChange`，约 251-260 行）
- Modify: `assets/html/jiankuan.html`（`getStockCode` 约 381-384 行；`f10Data` 约 145 行）

**Interfaces:**
- Consumes: Task 1 的 `_injectStockCode` 注入的 `window.APP_STOCK_CODE`（6 位数字字符串）
- Produces: 两个 html 在 app 内（data: URI，无 hash）也能显示正确股票

- [ ] **Step 1: 修改 gainiantong.html 的 handleHashChange**

原代码：

```js
        function handleHashChange() {
            var stockCode = window.location.hash.substring(1).trim() || DEFAULT_STOCK_CODE;
```

改为：

```js
        function handleHashChange() {
            var appCode = (typeof window.APP_STOCK_CODE === 'string') ? window.APP_STOCK_CODE.trim() : '';
            var stockCode = /^\d{6}$/.test(appCode) ? appCode
                : (window.location.hash.substring(1).trim() || DEFAULT_STOCK_CODE);
```

（函数其余部分不变。）

- [ ] **Step 2: 修改 jiankuan.html 的 getStockCode**

原代码：

```js
    getStockCode(){
        const h=location.hash.replace('#','');
        return /^\d{6}$/.test(h)?h:'600000';
    }
```

改为：

```js
    getStockCode(){
        const a=(typeof window.APP_STOCK_CODE==='string'?window.APP_STOCK_CODE.trim():'');
        if(/^\d{6}$/.test(a)) return a;
        const h=location.hash.replace('#','');
        return /^\d{6}$/.test(h)?h:'600000';
    }
```

- [ ] **Step 3: jiankuan.html 明文 HTTP 改 HTTPS**

原代码（API 对象内）：

```js
    f10Data: code => `http://basic.10jqka.com.cn/api/stockph/simple/f10/${code}`,
```

改为：

```js
    f10Data: code => `https://basic.10jqka.com.cn/api/stockph/simple/f10/${code}`,
```

- [ ] **Step 4: 验证改动**

Run: `grep -n "APP_STOCK_CODE" assets/html/gainiantong.html assets/html/jiankuan.html && grep -n "http://basic" assets/html/jiankuan.html; true`
Expected: 两个文件各有 APP_STOCK_CODE 匹配；`http://basic` 无输出

- [ ] **Step 5: Commit**

```bash
git add assets/html/gainiantong.html assets/html/jiankuan.html
git commit -m "feat: 本地html支持window.APP_STOCK_CODE传股票代码，f10接口改https"
```

---

### Task 3: 新增 i18n 文案

**Files:**
- Modify: `lib/common/langs/text_key.dart`

**Interfaces:**
- Produces: `TextKey.xuanzeguanlianlianjie`、`TextKey.zanshibuzhichi`（Task 4 使用 `.tr`）

- [ ] **Step 1: 添加 key 常量**

`text_key.dart` 中 `static const quanlianggupiaoshuaxinshibai = 'quanlianggupiaoshuaxinshibai';` 之后（class 结束前）添加：

```dart
  static const xuanzeguanlianlianjie = 'xuanzeguanlianlianjie';
  static const zanshibuzhichi = 'zanshibuzhichi';
```

- [ ] **Step 2: zh map 添加翻译**

zh map 中 `TextKey.quanlianggupiaoshuaxinshibai: '刷新失败',` 之后添加：

```dart
  TextKey.xuanzeguanlianlianjie: '选择关联链接',
  TextKey.zanshibuzhichi: '暂不支持该股票',
```

- [ ] **Step 3: en map 添加翻译**

en map 中 `TextKey.quanlianggupiaoshuaxinshibai: 'Refresh failed',` 之后添加：

```dart
  TextKey.xuanzeguanlianlianjie: 'Select related links',
  TextKey.zanshibuzhichi: 'Not supported for this stock',
```

- [ ] **Step 4: 验证**

Run: `flutter analyze lib/common/langs/text_key.dart`
Expected: `No issues found!`

- [ ] **Step 5: Commit**

```bash
git add lib/common/langs/text_key.dart
git commit -m "feat: 新增外链选择弹窗相关i18n文案"
```

---

### Task 4: 控制器 — 弹窗、跳转、移除旧方法 + WebViewPage 动作按钮防护

**Files:**
- Modify: `lib/app/modules/stockedit/controllers/stockedit_controller.dart`（imports 1-21；字段区 ~46-50；onInit ~86-122；删除 clickLookStock 634-652 与 clickLookMinesweeper 654-664）
- Modify: `lib/common/web/webview_page.dart:73-82`

**Interfaces:**
- Consumes: `StockExtLinks`/`StockExtLink`（Task 1）、`TextKey.xuanzeguanlianlianjie`/`zanshibuzhichi`（Task 3）、`QsHud.showDialog/dismiss/showToast`、`WebViewPage(loadResource:, webViewType:, title:)`
- Produces:
  - `StockeditController.extLinkIds`（`RxList<String>`，Task 5 监听）
  - `StockeditController.showExtLinkPicker()`、`openExtLink(StockExtLink)`、`previewExtLink(StockExtLink)`

- [ ] **Step 1: 添加 import 与字段**

import 区添加：

```dart
import 'package:stock_notes/common/web/stock_ext_links.dart';
import 'package:stock_notes/common/web/webview_widget.dart';
```

（`WebViewPage` 已在第 17 行 import；`WebViewType` 定义在 `webview_widget.dart`，需显式 import。）

字段区（`final hasNote = false.obs;` 之后）添加：

```dart
  //外链功能按钮勾选（全局配置）
  final extLinkIds = <String>[].obs;
```

`onInit` 中 `stockNumController.addListener(_updateStockNum);` 之前添加：

```dart
    extLinkIds.value = StockExtLinks.selectedIds();
```

- [ ] **Step 2: 替换 clickLookStock / clickLookMinesweeper 为新方法**

删除 `clickLookStock()`（634-652 行）与 `clickLookMinesweeper()`（654-664 行，含上方 `//扫雷宝` 注释），替换为：

```dart
  /// 打开外链（功能按钮或弹窗预览共用）
  Future<void> openExtLink(StockExtLink link) async {
    final code = serStockData.value.code ?? '';
    if (code.isEmpty) {
      QsHud.showToast(TextKey.shurugupiaotishi.tr);
      return;
    }
    final resource = await StockExtLinks.buildLoadResource(link, code);
    if (resource == null) {
      QsHud.showToast(TextKey.zanshibuzhichi.tr);
      return;
    }
    Get.to(() => WebViewPage(
          loadResource: resource,
          webViewType:
              link.isLocalAsset ? WebViewType.HTMLTEXT : WebViewType.URL,
          title: link.title,
        ));
  }

  /// 弹窗内预览：不关闭弹窗，返回后勾选状态保留
  void previewExtLink(StockExtLink link) {
    openExtLink(link);
  }

  /// 选择关联链接弹窗：多选 + 预览，确定后写全局缓存并刷新按钮
  void showExtLinkPicker() {
    final tempSelected = extLinkIds.toSet();
    QsHud.showDialog(StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Text(TextKey.xuanzeguanlianlianjie.tr,
              style: const TextStyle(fontSize: 20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: StockExtLinks.all.map((link) {
              final checked = tempSelected.contains(link.id);
              return Row(
                children: [
                  Checkbox(
                    value: checked,
                    onChanged: (v) {
                      setState(() {
                        if (v == true) {
                          tempSelected.add(link.id);
                        } else {
                          tempSelected.remove(link.id);
                        }
                      });
                    },
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          if (checked) {
                            tempSelected.remove(link.id);
                          } else {
                            tempSelected.add(link.id);
                          }
                        });
                      },
                      child: Text(link.title),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.visibility_outlined),
                    tooltip: link.title,
                    onPressed: () => previewExtLink(link),
                  ),
                ],
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => QsHud.dismiss(),
              child: Text(TextKey.quxiao.tr),
            ),
            TextButton(
              onPressed: () {
                final ordered = StockExtLinks.all
                    .where((l) => tempSelected.contains(l.id))
                    .map((l) => l.id)
                    .toList();
                StockExtLinks.saveSelectedIds(ordered);
                extLinkIds.value = ordered;
                QsHud.dismiss();
              },
              child: Text(TextKey.queding.tr),
            ),
          ],
        );
      },
    ));
  }
```

- [ ] **Step 3: WebViewPage 动作按钮防护（本地 html 不显示复制/浏览器打开）**

`lib/common/web/webview_page.dart` 的 actions（73-82 行）：

```dart
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
```

改为：

```dart
              actions: <Widget>[
                if (widget.webViewType == WebViewType.URL) ...[
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: _copyUrlToClipboard,
                  ),
                  IconButton(
                    icon: const Icon(Icons.open_in_browser),
                    onPressed: _openBrowser,
                  ),
                ],
              ],
```

- [ ] **Step 4: 静态检查**

Run: `flutter analyze lib/app/modules/stockedit lib/common/web`
Expected: view 中 `controller.clickLookStock()` / `clickLookMinesweeper()` 报 undefined_method 属预期（Task 5 修复）；其他错误需修复

- [ ] **Step 5: Commit**

```bash
git add lib/app/modules/stockedit/controllers/stockedit_controller.dart lib/common/web/webview_page.dart
git commit -m "feat: 股票详情控制器新增外链选择弹窗与跳转，移除旧硬编码按钮方法"
```

---

### Task 5: 视图 — `_gupiaoinfo` 行重构

**Files:**
- Modify: `lib/app/modules/stockedit/views/stockedit_view.dart`（`_gupiaoinfo` 632-699；`buildMinesweeperButton` 701-721）

**Interfaces:**
- Consumes: `controller.extLinkIds`、`controller.showExtLinkPicker()`、`controller.openExtLink(link)`（Task 4）、`StockExtLinks.all/isAStock`（Task 1）

- [ ] **Step 1: 替换 `_gupiaoinfo` 中的按钮区**

`_gupiaoinfo()` 的 Row（637-669 行）原代码：

```dart
        Row(
          children: [
            Text(TextKey.gupiao.tr, style: Get.textTheme.titleLarge),
            if (controller.serStockData.value.code != null ||
                controller.isLocalData.value) ...[
              InkWell(
                  onTap: () {
                    controller.search();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 12, right: 8, top: 12, bottom: 12),
                    child: Icon(
                      Icons.refresh,
                      size: 20,
                    ),
                  )),
              InkWell(
                onTap: () {
                  controller.clickLookStock();
                },
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 8, right: 12, top: 12, bottom: 12),
                  child: Icon(
                    Icons.web,
                    size: 20,
                  ),
                ),
              ),
              buildMinesweeperButton(),
            ],
          ],
        ),
```

替换为：

```dart
        Row(
          children: [
            Text(TextKey.gupiao.tr, style: Get.textTheme.titleLarge),
            if (controller.serStockData.value.code != null ||
                controller.isLocalData.value) ...[
              InkWell(
                  onTap: () {
                    controller.search();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 12, right: 8, top: 12, bottom: 12),
                    child: Icon(
                      Icons.refresh,
                      size: 20,
                    ),
                  )),
              Expanded(child: _buildExtLinkButtons()),
            ] else
              const Spacer(),
            InkWell(
              onTap: () {
                controller.showExtLinkPicker();
              },
              child: const Padding(
                padding:
                    EdgeInsets.only(left: 8, right: 4, top: 12, bottom: 12),
                child: Icon(
                  RemixIcons.link,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
```

- [ ] **Step 2: 新增 `_buildExtLinkButtons()`，删除 `buildMinesweeperButton()`**

删除整个 `buildMinesweeperButton()` 方法（701-721 行），在原位置添加：

```dart
  // 已勾选的外链文字按钮：横向滚动，A股才显示
  Widget _buildExtLinkButtons() {
    final code = controller.serStockData.value.code ??
        controller.localStockData.value?.code ??
        '';
    if (!StockExtLinks.isAStock(code)) {
      return const SizedBox.shrink();
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: StockExtLinks.all
            .where((link) => controller.extLinkIds.contains(link.id))
            .map((link) => InkWell(
                  onTap: () => controller.openExtLink(link),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 12),
                    child: Text(
                      link.title,
                      style: TextStyle(
                        fontSize: 13,
                        color: Get.theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
```

并在文件 import 区添加：

```dart
import 'package:stock_notes/common/web/stock_ext_links.dart';
```

注意：`_gupiaoinfo()` 整体已在 body 的 `Obx` 内，`controller.extLinkIds`/`serStockData` 变化会触发重建，`_buildExtLinkButtons` 内无需再嵌套 Obx。

- [ ] **Step 3: 静态检查 + 跑测试**

Run: `flutter analyze && flutter test`
Expected: analyze `No issues found!`；test `All tests passed!`

- [ ] **Step 4: Commit**

```bash
git add lib/app/modules/stockedit/views/stockedit_view.dart
git commit -m "feat: 股票详情行重构为可配置外链文字按钮+选择入口"
```

---

### Task 6: 全量验证（analyze + 单测 + 模拟器手动验证）

**Files:**
- 无改动（验证任务；发现问题回到对应 Task 修复）

**Interfaces:**
- Consumes: 全部前置 Task

- [ ] **Step 1: 全量静态检查与单测**

Run: `flutter analyze && flutter test`
Expected: `No issues found!` + `All tests passed!`

- [ ] **Step 2: 启动模拟器运行**

Run: `flutter run`（连接已有 Pixel 8 API 35 模拟器）

- [ ] **Step 3: 手动验证清单**

逐项验证（发现问题记录并修复）：

1. 打开一只 A 股（如 sz300848）详情：标题行显示刷新图标 + `k线百` `扫雷同` 两个文字按钮 + 最右链接图标。
2. 点 `k线百`：WebView 打开百度行情页且代码为 300848。返回。
3. 点 `扫雷同`：打开同花顺扫雷页 code=300848。返回。
4. 点链接图标：弹窗 6 行，k线百/扫雷同已勾选；每行右侧有预览眼睛图标。
5. 预览 `扫雷安`：不关闭弹窗直接打开页面（StockCode=300848）；返回后弹窗仍在、勾选不变。
6. 预览 `大事东`：页面能打开（fc=SZ300848；若 404/空白，改回纯 6 位数字——将 `stock_ext_links.dart` 中 dashi_em 的 `useMarketPrefix` 改为 false，并把 Task 1 单测期望改为 `fc=300848`）。
7. 预览 `概念同`、`简况`：本地页面显示 300848 的数据（非默认 002131/600000）。
8. 勾选全部 6 项 → 确定：按钮列表变为 6 个文字按钮，可横向滚动，不溢出。
9. 杀掉 app 重进：仍是 6 个按钮（勾选已持久化）。
10. 港股/美股/基金（hk00700、usAAPL、sh510300）：不显示文字按钮；链接图标仍在；弹窗内预览 toast「暂不支持该股票」。
11. 新页面（未搜索股票）点链接图标可弹窗；点预览 toast「请输入股票代码」。
12. 弹窗取消按钮：不改勾选。

- [ ] **Step 4: 提交修复（如有）**

```bash
git add -A
git commit -m "fix: 外链功能手动验证问题修复"
```

---

## Self-Review 结论

- **Spec 覆盖**：链接清单（Task 1）、html 改动（Task 2）、i18n（Task 3）、控制器+弹窗+WebViewPage 防护（Task 4）、视图行重构（Task 5）、错误处理与风险验证（Task 1 单测 + Task 6 手动清单第 6/10/11 项）。全部覆盖。
- **占位符扫描**：无 TBD/TODO；所有代码步骤含完整代码。
- **类型一致性**：`buildLoadResource` 返回 `Future<String?>`，Task 4 `await` 使用一致；`extLinkIds` 为 `RxList<String>`，Task 5 `contains` 使用一致；`StockExtLink` 字段名（id/title/urlTemplate/isLocalAsset/useMarketPrefix）在 Task 1/4/5 一致。
