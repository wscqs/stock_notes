# 交易记录“更多”抽屉实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 在股票详情页交易记录区最多显示 3 条交易，超过时显示“更多 (N)”入口，点击后从底部弹出完整交易列表抽屉。

**Architecture:** 主界面和抽屉共用同一个 `StockeditController` 实例与 `stockTrades` 列表，通过 `Obx` 自动同步刷新。抽屉复用现有的 `_buildTradeItem` 卡片 UI，使用 `Get.bottomSheet` 实现（与标签选择页同风格）。

**Tech Stack:** Flutter, GetX, Drift/SQLite, flutter_smart_dialog

## Global Constraints

- 保持现有交易卡片 UI 不变。
- 主界面最多展示 3 条交易记录。
- “更多”行显示剩余数量，格式为 `更多 (N)`。
- 抽屉样式参考 `TagseditView.show`：圆角顶部、背景色 `Get.theme.colorScheme.surface`、占屏高约 70%、`SafeArea` + `Padding(16)`。
- 抽屉内交易项保留删除功能，删除后自动同步主界面。
- 新增多语言 key `gengduo`，中文“更多”，英文“More”。

---

## File Structure

- **Modify:** `lib/common/langs/text_key.dart`
  - 新增 `gengduo` key 及中英文翻译。
- **Modify:** `lib/app/modules/stockedit/views/stockedit_view.dart`
  - 调整 `_buildTradeSection`：截断为最多 3 条并追加“更多 (N)”行。
  - 保持 `_buildTradeItem` 作为卡片构建方法复用。
- **Modify:** `lib/app/modules/stockedit/controllers/stockedit_controller.dart`
  - 新增 `showAllTradesSheet()` 方法，弹出完整交易列表抽屉。

---

### Task 1: 添加“更多”多语言 key

**Files:**
- Modify: `lib/common/langs/text_key.dart`

**Interfaces:**
- Produces: `TextKey.gengduo` available for use in `stockedit_view.dart` and `stockedit_controller.dart`.

- [ ] **Step 1: Add the key constant**

在 `TextKey` 类中新增一行（放在其他简短 key 附近即可）：

```dart
static const gengduo = 'gengduo'; // 更多
```

- [ ] **Step 2: Add Chinese translation**

在 `zh_CN` map 中新增条目（建议放在 `TextKey.jiaoyijilu` 附近）：

```dart
TextKey.gengduo: '更多',
```

- [ ] **Step 3: Add English translation**

在 `en` map 中新增对应条目：

```dart
TextKey.gengduo: 'More',
```

- [ ] **Step 4: Verify the key exists in both maps**

Run:

```bash
grep -n "gengduo" lib/common/langs/text_key.dart
```

Expected output shows the constant definition and both translations.

- [ ] **Step 5: Commit**

```bash
git add lib/common/langs/text_key.dart
git commit -m "feat(i18n): add gengduo (more) text key"
```

---

### Task 2: 主界面交易区截断并显示“更多”入口

**Files:**
- Modify: `lib/app/modules/stockedit/views/stockedit_view.dart`

**Interfaces:**
- Consumes: `TextKey.gengduo` from Task 1.
- Produces: `_buildTradeSection` renders at most 3 trade cards plus a "更多 (N)" tile when applicable.

- [ ] **Step 1: Locate the trade section**

Find `_buildTradeSection` around line 342. Current structure:

```dart
Obx(() {
  if (controller.stockTrades.isEmpty) {
    return Text(
      TextKey.noData.tr,
      style: TextStyle(color: Colors.grey),
    );
  }
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: controller.stockTrades.length,
    itemBuilder: (context, index) {
      final trade = controller.stockTrades[index];
      return _buildTradeItem(trade);
    },
  );
}),
```

- [ ] **Step 2: Replace with truncated list + more tile**

Replace the above `Obx` block with:

```dart
Obx(() {
  if (controller.stockTrades.isEmpty) {
    return Text(
      TextKey.noData.tr,
      style: TextStyle(color: Colors.grey),
    );
  }
  final showMore = controller.stockTrades.length > 3;
  final displayCount = showMore ? 3 : controller.stockTrades.length;
  final moreCount = controller.stockTrades.length - 3;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: displayCount,
        itemBuilder: (context, index) {
          final trade = controller.stockTrades[index];
          return _buildTradeItem(trade);
        },
      ),
      if (showMore)
        InkWell(
          onTap: controller.showAllTradesSheet,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${TextKey.gengduo.tr} ($moreCount)",
                  style: TextStyle(
                    color: Get.theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: Get.theme.colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
    ],
  );
}),
```

- [ ] **Step 3: Verify `_buildTradeItem` is reusable**

Ensure `_buildTradeItem(StockTrade trade)` remains unchanged and accepts a `StockTrade`. It currently starts around line 363.

- [ ] **Step 4: Manual verification**

Run:

```bash
flutter run
```

Navigate to a stock detail page with more than 3 trades.

Expected:
- Only the first 3 trade cards are visible.
- A "更多 (N)" row appears below them, where N = total trades - 3.
- Tapping the row does nothing yet (controller method added in Task 3).

- [ ] **Step 5: Commit**

```bash
git add lib/app/modules/stockedit/views/stockedit_view.dart
git commit -m "feat(stockedit): truncate trade list to 3 with more entry"
```

---

### Task 3: 实现完整交易列表抽屉

**Files:**
- Modify: `lib/app/modules/stockedit/controllers/stockedit_controller.dart`

**Interfaces:**
- Consumes: `_buildTradeItem` from `stockedit_view.dart`.
- Produces: `Widget buildTradeItem(StockTrade trade)` and `void showAllTradesSheet()`.

- [ ] **Step 1: Move trade item builder to controller**

Move `_buildTradeItem(StockTrade trade)` from `stockedit_view.dart` into `StockeditController` as a public method `buildTradeItem(StockTrade trade)`. Remove the private method from the view file.

In `stockedit_controller.dart`, add:

```dart
Widget buildTradeItem(StockTrade trade) {
  final isBuy = trade.tradeType == 0;
  return Card(
    margin: const EdgeInsets.only(bottom: 8),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isBuy
                      ? Colors.red.withValues(alpha: 0.1)
                      : Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isBuy ? TextKey.buy.tr : TextKey.sale.tr,
                  style: TextStyle(
                    color: isBuy ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                (trade.tradeDate ?? trade.createdAt).toDateString(),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => deleteTrade(trade),
                child: Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                "${TextKey.jiage.tr}: ${trade.price ?? '-'}",
                style: TextStyle(fontSize: 14),
              ),
              if (trade.shares != null && trade.shares!.isNotEmpty) ...[
                const SizedBox(width: 16),
                Text(
                  "${TextKey.gushu.tr}: ${trade.shares}",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ],
          ),
          if (trade.remark != null && trade.remark!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              "${TextKey.beizui.tr}: ${trade.remark}",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ],
      ),
    ),
  );
}
```

**Caveat:** `toDateString()` is an extension method on `DateTime`. Ensure the controller file has access to it via existing imports or project-level extensions. If `qs_date.dart` is not imported, add:

```dart
import 'package:stock_notes/utils/qs_date.dart';
```

In `stockedit_view.dart`, replace all `_buildTradeItem(trade)` calls with `controller.buildTradeItem(trade)`.

- [ ] **Step 2: Add the bottom sheet method**

Insert the following method in `StockeditController`, near other trade-related methods (after `deleteTrade` is fine):

```dart
void showAllTradesSheet() {
  Get.bottomSheet(
    GetBuilder<StockeditController>(
      init: this,
      builder: (_) {
        return Container(
          height: Get.height * 0.7,
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        TextKey.jiaoyijilu.tr,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Obx(() {
                      if (stockTrades.isEmpty) {
                        return Center(
                          child: Text(
                            TextKey.noData.tr,
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }
                      return SingleChildScrollView(
                        child: Column(
                          children: stockTrades
                              .map((trade) => buildTradeItem(trade))
                              .toList(),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
    isScrollControlled: true,
    backgroundColor: Get.theme.colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
  );
}
```

- [ ] **Step 3: Manual verification**

Run:

```bash
flutter run
```

Navigate to a stock with more than 3 trades. Tap "更多 (N)".

Expected:
- A bottom sheet slides up from the bottom.
- Title is "交易记录" with a close button on the left.
- All trades are listed in the sheet.
- Deleting a trade from the sheet updates both the sheet and the main view.
- Closing the sheet via the close button or swipe returns to the main view.

- [ ] **Step 4: Commit**

```bash
git add lib/app/modules/stockedit/views/stockedit_view.dart lib/app/modules/stockedit/controllers/stockedit_controller.dart
git commit -m "feat(stockedit): add all-trades bottom sheet"
```

---

### Task 4: 静态分析与回归测试

**Files:**
- All files modified above.

- [ ] **Step 1: Run static analysis**

```bash
flutter analyze
```

Expected: No new errors in the modified files. Pre-existing warnings in other files are acceptable.

- [ ] **Step 2: Run tests**

```bash
flutter test
```

Expected: Test suite runs. The 2 pre-existing failures in `test/stock_ext_links_test.dart` may still fail; no new failures should appear.

- [ ] **Step 3: Commit if clean**

If analyze passes and tests are no worse than before:

```bash
git add -A
git commit -m "chore: verify trade list more feature"
```

---

## Self-Review

### Spec coverage

- ✅ 主界面最多 3 条：Task 2。
- ✅ “更多 (N)”入口：Task 2。
- ✅ 底部抽屉样式同标签页：Task 3。
- ✅ 抽屉内支持删除且同步刷新：Task 3（复用 `deleteTrade` 与 `stockTrades`）。
- ✅ 新增多语言 key：Task 1。

### Placeholder scan

- No TBD/TODO.
- No vague "handle edge cases" steps.
- Code snippets include concrete widget/class names and exact paths.

### Type consistency

- `showAllTradesSheet()` is `void`, matches `onTap` callback in Task 2.
- `buildTradeItem(StockTrade trade)` is `Widget`, consistent across view and controller.
- `stockTrades` is `RxList<StockTrade>`, used in `Obx` and `.map()`.

### Notes

- Task 3 Step 1 moves `buildTradeItem` to the controller as a public method so it can be reused by both the main view and the bottom sheet. Task 3 Step 2 then implements the bottom sheet using this public method.
- If `toDateString()` is not available in the controller after the move, add the necessary import before committing Task 3.
