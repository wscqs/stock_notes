# Trade Profit Chart Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add close dates and an interactive, adjusted-price historical profit and drawdown chart to every stock trade.

**Architecture:** Keep quote retrieval, pure profit calculation, and Flutter rendering separate. A nullable Drift close date fixes completed-trade ranges; a Tencent K-line repository supplies ordered daily closes; a reusable bottom sheet owns loading, tabs, selection, and retry.

**Tech Stack:** Flutter, GetX, Drift/SQLite, Dio, fl_chart 1.3.0, flutter_test.

**Spec:** `docs/superpowers/specs/2026-11-04-trade-profit-chart-design.md`

## Global Constraints
- Preserve all existing trade behavior and unrelated workspace changes.
- Use unadjusted HK prices and A-share forward-adjusted prices; never subtract adjusted closes from the raw open price.
- Maximum drawdown is `max(profits, 0) - latestProfit`, never peak-to-trough.
- Add zh_CN and en_US strings; use fl_chart 1.3.0 and support light/dark themes.

## Review Focus
- Corporate actions: compare open-day adjusted close, not raw open price (Task 2 test).
- Completed trades: final point must use actual close price (Task 2 test).
- Pagination: responses longer than 640 rows must not lose open-day data (Task 1 test).
- Old records: null close dates must remain usable and visibly disclosed (Tasks 3–4 tests).
- Invalid inputs and unsupported markets must show a controlled state, never fabricated points (Tasks 1–4 tests).

### Task 1: Close Date and Historical Quotes
**Files:** `lib/common/database/tables.dart`, `lib/common/database/database.dart`, `lib/common/database/database.g.dart`, `lib/common/widget/stock_trade_dialog.dart`, `lib/common/https/qs_api.dart`, new `lib/common/https/stock_kline_service.dart`, new model, related tests.
**Interfaces:** `StockTrade.closeDate: DateTime?`; `StockKlineService.fetchDaily({required StockItem stock, required DateTime start, DateTime? end}) -> Future<List<StockDailyClose>>`; `StockDailyClose(date, close)`.
- [ ] Add failing dialog, migration, parser and pagination tests, including qfqday/day and 640-row windows.
- [ ] Run the tests and confirm failures name the missing field/service.
- [ ] Add nullable closeDate, schema 14 migration, regenerate Drift, and implement validated close-date UI.
- [ ] Reuse code normalization, add bounded date-window requests, decoding, sorting, deduplication and memory cache.
- [ ] Run Task 1 tests and confirm PASS.

### Task 2: Pure Profit Series
**Files:** new `lib/common/model/trade_profit_calculator.dart`, `test/trade_profit_calculator_test.dart`.
**Interfaces:** input trade-like values plus ordered daily closes; output points(date, profit, yieldRate), latestProfit and maxDrawdown; optional completed final price override.
- [ ] Write failing long/short, all-loss, peak-to-latest, zero input and adjusted-baseline tests.
- [ ] Verify failure, implement pure calculation, and verify PASS.

### Task 3: Reusable Chart Bottom Sheet
**Files:** new chart controller/model and `lib/common/widget/trade_profit_chart_sheet.dart`, TextKey translations, chart widget tests.
**Interfaces:** `TradeProfitChartSheet.show({required StockItem stock, required StockTrade trade, required Future<void> Function(DateTime closeDate) onCloseDateSaved, StockKlineService? service})`.
- [ ] Write failing loading/error/retry, tabs, values, touch and unsupported-market tests using fake service data.
- [ ] Implement the sheet, two tabs, responsive chart, zero baseline, touch selection, drawdown and adjustment disclosure.
- [ ] Implement close-date repair for legacy completed records and save/reload through the callback.
- [ ] Verify tests PASS and inspect a rendered light/dark screenshot if an emulator is available.

### Task 4: Integrate and Verify
**Files:** `lib/common/widget/stock_trade_item.dart`, stockedit and tradelist controllers/views, relevant tests.
**Interfaces:** optional `onShowProfitChart`; wire stock lookup and close-date persistence in both modules.
- [ ] Add failing entry visibility/click tests and invalid-input test.
- [ ] Wire the entry and save callback without changing existing card/edit/delete actions.
- [ ] Run formatting, all targeted tests, `flutter analyze`, and the test suite excluding documented known-broken files.
- [ ] Inspect final diff, report exact verification and any remaining API limitations.
