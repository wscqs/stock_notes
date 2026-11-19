# Announcement Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a reusable maintenance announcement page, drawer entry, and permanent once-only startup dialog.

**Architecture:** A small announcement module owns localized presentation and the existing QR-code behavior; TabsController coordinates the one-time startup dialog. SharedPreferences stores the seen flag without a database change.

**Tech Stack:** Flutter, GetX, flutter_smart_dialog, shared_preferences, flutter_test

**Spec:** `docs/superpowers/specs/2026-11-19-announcement-design.md`

## Global Constraints
- Keep all announcement content offline and reuse `assets/images/zst.jpg`.
- Preserve existing coffee entry and long-press save behavior.
- Never auto-show the announcement after a successful first presentation; manual entry remains available.
- Add both zh_CN and en_US translations; do not change schemaVersion.

## Review Focus
- Narrow/short screens: announcement scrolls and QR code remains bounded (Task 1 widget test).
- Repeated startup: no second dialog after `announcementShownV1` is true (Task 2 tests).
- Startup persistence failure: UI still opens and app continues (Task 2 controller test).
- Drawer navigation: entry appears below Share and opens Routes.ANNOUNCEMENT (Task 3 widget/controller test).

---

### Task 1: Reusable Announcement Content and Page

**Files:**
- Create: `lib/app/modules/announcement/views/announcement_content.dart`
- Create: `lib/app/modules/announcement/views/announcement_view.dart`
- Create: `lib/app/modules/announcement/bindings/announcement_binding.dart`
- Create: `lib/app/modules/announcement/controllers/announcement_controller.dart`
- Modify: `lib/common/langs/text_key.dart`
- Modify: `lib/app/routes/app_pages.dart`, `lib/app/routes/app_routes.dart`
- Test: `test/announcement_view_test.dart`

**Interfaces:**
- Produces: `AnnouncementView`, `AnnouncementContent({bool compact = false})`, `Routes.ANNOUNCEMENT`.
- Reuses: existing `HomedrawerVC.saveZstImage()` behavior via a shared QR/save component if extraction avoids duplicate platform logic.

- [ ] Write widget tests asserting both Chinese paragraphs, QR asset, save hint, close-independent page layout, and bounded rendering at a small viewport.
- [ ] Run `flutter test test/announcement_view_test.dart` and verify it fails because the module is absent.
- [ ] Add TextKey constants and zh/en strings for announcement title, both paragraphs, and acknowledgement; register the route and standard GetX binding/controller.
- [ ] Implement a scrollable, theme-aware content widget with centered bounded QR image, long-press save, and the two descriptions; use it in both full page and compact dialog layouts.
- [ ] Re-run the test and `dart format` touched Dart files; expect PASS and no formatting diff.

### Task 2: Once-Only Startup Presentation

**Files:**
- Modify: `lib/common/globle_service.dart`
- Modify: `lib/app/modules/tabs/controllers/tabs_controller.dart`
- Test: `test/announcement_startup_test.dart`

**Interfaces:**
- Consumes: `AnnouncementContent(compact: true)` from Task 1.
- Produces: `GlobalService.to.hasShownAnnouncement`, `markAnnouncementShown()`, and `TabsController.maybeShowAnnouncement()` (idempotent within one controller lifecycle).

- [ ] Write controller tests using `SharedPreferences.setMockInitialValues` for unseen, seen, in-progress/reentrant, and failed-persistence cases; assert dialog/show count and persistence calls.
- [ ] Run the focused test and verify failure because the seen-state API is absent.
- [ ] Add key `announcementShownV1`, default false, initialization, and awaited setter. In `onReady`, invoke the coordinator after deep-link handling; show a closeable SmartDialog with close and “知道了”, then mark it shown when presentation is initiated.
- [ ] Re-run focused tests; expect all cases PASS and no duplicate dialogs on repeat invocation.

### Task 3: Drawer Entry and Final Verification

**Files:**
- Modify: `lib/app/modules/somewidget/homedrawer_page/view.dart`
- Test: `test/announcement_view_test.dart`

**Interfaces:**
- Consumes: `Routes.ANNOUNCEMENT`, `TextKey.gonggao`.

- [ ] Add a navigation/widget test for an Announcement ListTile immediately below Share and its route callback.
- [ ] Implement the themed ListTile with announcement icon, title, and forward chevron; close the drawer before navigation consistently with adjacent entries.
- [ ] Run `flutter test test/announcement_view_test.dart test/announcement_startup_test.dart` and `flutter analyze`; expect all focused tests and analysis to pass. Exclude known broken `tradelist_view_test` and `database_migration_test` if running a broader suite.
