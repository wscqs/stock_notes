# LOF套利 入口设计

日期：2026-08-07

## 需求

- 设置页新增一行「LOF套利」，右侧为开关（Switch），默认关闭，状态持久化。
- 开关打开后，首页侧边抽屉在「设置」与「使用」之间新增一行「LOF套利」。
- 点击该行在应用内 WebView 打开 https://www.talicai.com/talicai/lof/index.html 。

## 设计

### 1. 全局状态（`lib/common/globle_service.dart`）

- 新增 `RxBool rxLofEnabled = false.obs`。
- SharedPreferences key：`lofEnabled`（bool），默认 `false`。
- `init()` 中调用 `_initLofEnabled()` 读取持久化值。
- 新增 `Future<void> changeLofEnabled(bool value)`：更新 rx 值并写入 SharedPreferences。
- 模式完全复用现有 `rxNearBSPoint` / `changeNearBSPoint`。

### 2. 国际化（`lib/common/langs/text_key.dart`）

- 新增 `static const lofTaoli = 'lofTaoli';`
- zh_CN：`'LOF套利'`；en_US：`'LOF Arbitrage'`。

### 3. 设置页（`lib/app/modules/setting/views/setting_view.dart`）

- 在「全股票代码刷新」`SimpleCell` 之后新增：
  - `SimpleCell(title: TextKey.lofTaoli.tr, isShowRightArrow: false, ...)`
  - `rightWidget`：`Obx(() => Switch(value: GlobalService.to.rxLofEnabled.value, onChanged: (v) => GlobalService.to.changeLofEnabled(v)))`
  - 行的 `onPressed` 也切换开关（取反），保证整行可点。

### 4. 抽屉（`lib/app/modules/somewidget/homedrawer_page/view.dart`）

- 抽屉列表改为 `Obx` 监听 `GlobalService.to.rxLofEnabled`（已 Get.put 过，直接 `GlobalService.to` 读取）。
- 开关为 true 时，在「设置」ListTile 之后、「使用」之前插入：
  - `ListTile(title: Text(TextKey.lofTaoli.tr), trailing: Icon(Icons.arrow_forward_ios, size: 18), tileColor` 与相邻行一致。
  - `onTap`：`parentVC.closeDrawer()`，然后 `Get.to(() => WebViewPage(loadResource: kLofArbitrageUrl, webViewType: WebViewType.URL, title: TextKey.lofTaoli.tr))`。
- URL 常量：`const String kLofArbitrageUrl = 'https://www.talicai.com/talicai/lof/index.html';` 定义在抽屉 view 文件内（就近使用，暂无需全局常量文件）。

## 影响面

- 改动 4 个文件：`globle_service.dart`、`text_key.dart`、`setting_view.dart`、`homedrawer_page/view.dart`。
- 无数据库 schema 变更，无需 build_runner。
- 默认关闭，对现有用户无感知变化。

## 测试

- `flutter analyze` 通过。
- 手动验证：设置开关 → 抽屉出现/消失「LOF套利」行 → 点击打开网页；杀掉 App 重启后开关状态保持。
