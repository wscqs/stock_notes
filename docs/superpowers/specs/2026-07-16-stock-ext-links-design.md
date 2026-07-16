# 股票详情页外链功能按钮 — 设计文档

日期：2026-07-16
状态：已确认（方案 A）

## 背景

股票详情页（`stockedit`）目前在「股票」标题行有两个硬编码的外链按钮（k线百、扫雷同）。用户希望可配置化：通过一个多选弹窗选择要显示的外链，选中的以文字小按钮形式放在原按钮位置，每项支持预览。

## 已确认决策

| 决策点 | 结论 |
|---|---|
| 勾选存储范围 | 全局配置，存 `QsCache`（Hive），不改数据库 |
| 现有两个按钮 | 并入可配置列表，默认勾选 k线百 + 扫雷同 |
| 非 A 股（港股/美股/基金） | 隐藏这些按钮（复用现有 isAStock 判断） |
| 按钮样式 | 文字小按钮（如「k线百」「简况」），横向可滚动 |
| 本地 html 传码方案 | 方案 A：html 优先读 `window.APP_STOCK_CODE`，Flutter 端加载 asset 字符串时前置注入 |

## 链接清单

| id | 标题 | URL 模板 | 类型 | 代码规则 |
|---|---|---|---|---|
| kline_baidu | k线百 | `https://pqa9p2.smartapps.baidu.com/pages/quote/quote?market=ab&type=stock&code=xxxxxx` | URL | 6 位数字 |
| saolei_ths | 扫雷同 | `https://bowerbird.10jqka.com.cn/thslc/editor/view/433f6d9Ac0?code=xxxxxx` | URL | 6 位数字 |
| saolei_essence | 扫雷安 | `https://static.essence.com.cn/zixun/sweep-car/index.html#/pages/sweepDetails/index?StockCode=xxxxxx` | URL | 6 位数字 |
| dashi_em | 大事东 | `https://emh5.eastmoney.com/html/detail.html?fc=xxxxxx#/gsds` | URL | 市场大写前缀+6 位数字（如 SZ300848、SH600519；按东方财富 fc 惯例） |
| gainian_ths | 概念同 | `assets/html/gainiantong.html` | 本地 asset | 6 位数字（注入） |
| jiankuan | 简况 | `assets/html/jiankuan.html` | 本地 asset | 6 位数字（注入） |

- `xxxxxx` 为占位符，运行时按「代码规则」列替换。
- 6 位数字 = 去掉 `sh`/`sz` 前缀后的部分（`sz300848` → `300848`）。

## 组件设计

### 1. `lib/common/web/stock_ext_links.dart`（新增）

单一职责：外链的静态定义 + 勾选状态存取 + 构建跳转。

```dart
class StockExtLink {
  final String id;            // 'kline_baidu' 等
  final String title;         // 'k线百' 等（固定中文，不入 i18n）
  final bool isLocalAsset;    // 是否本地 html
  final String urlTemplate;   // URL 模板或 asset 路径
}

class StockExtLinks {
  static const List<StockExtLink> all = [ ...6 项，顺序即弹窗与按钮顺序... ];
  static const _cacheKey = 'stock_ext_link_selection';

  // 读取勾选 id 列表；无缓存时返回默认 ['kline_baidu', 'saolei_ths']
  static List<String> selectedIds();
  static void saveSelectedIds(List<String> ids);

  // A 股判断（与 stockedit_view 现有逻辑一致）：
  // (sh|sz 开头) 且非 sh5xxxxx、sz1xxxxx（基金）
  static bool isAStock(String code);

  // 生成目标：本地 asset 返回注入后的 html 字符串，URL 类型返回替换后的 url
  // stockCode 形如 sz300848；A 股以外返回 null（调用方隐藏按钮）
  static String? buildLoadResource(StockExtLink link, String stockCode);
}
```

### 2. 两个 html 资产的小改动

- `gainiantong.html`：`handleHashChange()` 首行改为优先取 `window.APP_STOCK_CODE`（需匹配 `^\d{6}$`），取不到再走原有 hash 逻辑。
- `jiankuan.html`：`getStockCode()` 同样优先取 `window.APP_STOCK_CODE`。
- 顺带把 `jiankuan.html` 中唯一的明文 HTTP 请求（`http://basic.10jqka.com.cn/api/stockph/...`）改为 `https`，避免 WebView 明文流量限制。
- 改动最小，不影响 html 脱离 app 独立使用。

### 3. `stockedit_controller.dart` 修改

- 新增 `final extLinkIds = <String>[].obs`，`onInit` 时读 `StockExtLinks.selectedIds()`。
- 新增 `openExtLink(StockExtLink link)`：
  - 取 `serStockData.value.code`，为空则 toast（复用 `TextKey.shurugupiaotishi`）。
  - 调 `StockExtLinks.buildLoadResource`，非 A 股返回 null 则 toast 不支持。
  - 远程：`Get.to(() => WebViewPage(loadResource: url, title: link.title))`
  - 本地：`Get.to(() => WebViewPage(loadResource: htmlString, webViewType: WebViewType.HTMLTEXT, title: link.title))`
- 新增 `previewExtLink(StockExtLink link)`：与 `openExtLink` 相同实现，弹窗不关闭直接 `Get.to`（返回后弹窗仍在，勾选状态保留）。
- 新增 `showExtLinkPicker()`：用 `QsHud.showDialog` 弹多选弹窗（见 UI 设计），确定时写缓存并更新 `extLinkIds`。
- 删除 `clickLookStock()` / `clickLookMinesweeper()`（功能被 k线百/扫雷同两项取代）。

### 4. `stockedit_view.dart` 修改（`_gupiaoinfo` 行）

- 删除 `buildMinesweeperButton()` 与原 `Icons.web` 按钮。
- 行结构：`[股票] [刷新图标] [Expanded: 横向 SingleChildScrollView 文字按钮列表] [设置图标]`
- 文字按钮：`Obx` 监听 `controller.extLinkIds`，按 `StockExtLinks.all` 顺序过滤出已勾选项渲染；仅当 `StockExtLinks.isAStock(当前 code)` 时显示（code 为空时也隐藏）。样式：小号 TextButton/ InkWell + 文字，紧凑 padding。
- 设置图标：`RemixIcons.link`（或 `Icons.link`），点击 `controller.showExtLinkPicker()`，无论是否 A 股都显示（用户可在无股票时先配置）。

### 5. 多选弹窗（`QsHud.showDialog` + StatefulBuilder）

- 标题：「选择关联链接」（新增 TextKey，见 i18n）。
- 内容：`StatefulBuilder` 内 `Column`，每行：`Checkbox` + `标题（Expanded）` + 预览 `IconButton(Icons.visibility_outlined)`。
  - 勾选状态存 `StatefulBuilder` 局部 `Set<String>`（初值 = 当前勾选）。
  - 预览：先 toast 提示无股票/非 A 股的情况；可用时 `controller.previewExtLink(link)`。
- 底部按钮：取消 / 确定（复用已有 TextKey：`quxiao`、`queding`）。
- 确定：按 `StockExtLinks.all` 顺序过滤选中集合 → `saveSelectedIds` + 更新 `extLinkIds` → `QsHud.dismiss()`。允许 0 项勾选（按钮列表留空）。

## i18n（`lib/common/langs/text_key.dart` + zh/en 翻译表）

新增 2 个 key：
- `xuanzeguanlianlianjie`：选择关联链接 / Select related links
- `zanshibuzhichi`（暂不支持该股票）/ Not supported for this stock —— 用于非 A 股点击提示

链接标题（k线百等）为固定中文简称，不走 i18n。

## 数据流

```
用户点设置图标 → showExtLinkPicker()
  → 弹窗勾选/预览（preview 直接 Get.to WebViewPage）
  → 确定 → QsCache.set(_cacheKey, ids) + extLinkIds.value = ids
  → _gupiaoinfo 行 Obx 重建 → 文字按钮列表更新
用户点文字按钮 → openExtLink → buildLoadResource → Get.to WebViewPage
```

## 错误处理

- 未搜索到股票（code 为空）点按钮/预览：toast 提示先输入股票。
- 非 A 股点按钮（理论上按钮已隐藏，防御性）：toast「暂不支持该股票」。
- asset 读取失败（rootBundle 异常）：catch 后 toast 加载失败。
- 缓存损坏（读到非 List）：回退默认勾选。

## 风险与验证点

1. **本地 html 以 data: URI 加载后发起到 10jqka 的跨域 XHR**：HTMLTEXT 模式 origin 为 null，目标 API 是否放行需在真机/模拟器验证；现有 WebViewPage 用 `Uri.dataFromString` 加载。若被拦，备选方案 B（loadFile）。
2. **大事东 fc 参数格式**：按 `SZ300848` 格式实现，实现后人工验证页面能打开；若不行退回纯 6 位数字。
3. **行内容纳**：6 个文字按钮全选时可能超宽，已用横向滚动解决，验证 UI 不溢出。

## 测试

- `flutter analyze` 无告警。
- 手动验证清单：
  1. 默认（清缓存首次）显示 k线百 + 扫雷同两个按钮，与原有两个按钮行为一致。
  2. 弹窗勾选/取消 → 确定 → 按钮列表即时更新；杀掉 app 重进勾选保持。
  3. 6 项预览均能打开对应页面且股票代码正确（本地两项显示对应股票数据）。
  4. 港股/美股/基金（如 hk00700、usAAPL、sh510300）不显示外链按钮，设置图标仍在。
  5. 未搜索股票时点设置图标可弹窗，点预览 toast 提示。
- 单元测试：为 `StockExtLinks.buildLoadResource` / `isAStock` / 缓存回退逻辑补 dart test（`test/` 下新增，不依赖 Flutter binding 的部分）。
