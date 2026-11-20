# Ballot Quant Analysis Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a “量化分析” item at the end of the ballot list that opens the supplied webpage in the existing in-app WebView.

**Architecture:** Add one remote `BallotItem` to the existing observable controller list. `BallotView` already renders every item and opens non-local URLs in `WebViewPage`, so no view or routing changes are needed.

**Tech Stack:** Flutter, GetX, Remix icons, existing zikzak_inappwebview wrapper, flutter_test.

**Spec:** `docs/superpowers/specs/2026-11-20-ballot-quant-analysis-design.md`

## Global Constraints

- Preserve the full URL, including `sharecode=4BXKJH355B`.
- Keep the item last, use the existing WebView path, and add no dependencies or schema changes.
- Do not include the unrelated deleted Kotlin session file in any change.

## Review Focus

- URL loss or accidental local-asset classification: the controller test asserts the exact URL and `isLocalAsset == false`.
- Entry appearing outside the requested final position: the controller test asserts `items.last`.
- Existing item behavior regressions: run the complete ballot controller test file after the change.

---

### Task 1: Add the quant-analysis ballot entry

**Files:**
- Modify: `lib/app/modules/ballot/controllers/ballot_controller.dart`
- Test: `test/ballot_controller_test.dart`

**Interfaces:**
- Consumes: existing `BallotItem({required String title, required String url, required IconData icon, bool isLocalAsset = false})` and `BallotController.items`.
- Produces: final `BallotItem` titled `量化分析`, backed by the supplied HTTPS URL.

- [ ] **Step 1: Write the failing test**

Add a test named `quant analysis is the last ballot item and opens its remote webpage`. Instantiate `BallotController`, select `controller.items.last`, and assert title `量化分析`, exact URL `https://stock-quant-dashboard-45464.app.workbuddy.host/?sharecode=4BXKJH355B`, and `isLocalAsset == false`.

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/ballot_controller_test.dart`
Expected: FAIL because the current final item is `今天炒什么`.

- [ ] **Step 3: Add the minimal entry**

Append a `BallotItem` to `BallotController.items` with title `量化分析`, the exact tested URL, and a suitable Remix chart icon. Leave `isLocalAsset` at its default `false`; do not change `BallotView`.

- [ ] **Step 4: Verify the change**

Run: `flutter test test/ballot_controller_test.dart`
Expected: all tests PASS.
Run: `flutter analyze lib/app/modules/ballot test/ballot_controller_test.dart`
Expected: no issues.

- [ ] **Step 5: Commit only after user authorization**

Stage only the design, plan, controller, and test paths; exclude the pre-existing Kotlin session deletion. Commit message: `feat: add quant analysis to ballot`.
