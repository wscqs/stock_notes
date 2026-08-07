# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

股票笔记 (Stock Notes) is a privacy-first, offline Flutter app for stock investors to record and review trading strategies. Platforms: Android, iOS, Windows, macOS. All data lives in local SQLite; there is no backend user data service.

## Common Commands

```bash
flutter run                  # run the app
flutter analyze              # lint
flutter test                 # run tests
flutter pub get              # install dependencies

flutter build apk|ios|macos|windows

# Regenerate Drift code after ANY schema change
dart run build_runner build

# Asset/config regeneration (configs live in pubspec.yaml)
dart run flutter_launcher_icons
dart run flutter_native_splash:create
dart run package_rename
```

## Release Workflow

Releases are cut from `main` and built by GitHub Actions.

1. Bump `version` in `pubspec.yaml` (e.g. `3.1.0+37` → `3.1.1+38` — bump both parts).
2. Commit: `git commit -m "release: v3.1.1" -m "<变更说明>"`
3. Tag: `git tag -a v3.1.1 -m "<变更说明>"`
4. Push: `git push origin main && git push origin v3.1.1`
5. Create the GitHub Release (`gh release create v3.1.1`). This triggers `.github/workflows/flutter_build.yml`, which builds and uploads:
   - Android APK (`app-release.apk`)
   - macOS zip (`macos-stocknote.zip`)
   - Windows zip (`windows-stocknote.zip`)

> iOS is supported by the codebase but is **not** in the automated release builds.

## Architecture

### State Management & Routing
- **GetX** for state, routing, and DI.
- Routes are centralized in `lib/app/routes/app_pages.dart` (pages) and `app_routes.dart` (paths). Initial route: `Routes.TABS` (`AppPages.INITIAL`).
- Controllers extend `BaseController` (`lib/app/modules/base/base_Controller.dart`), which adds `onResume`/`onPause` visibility hooks.
- Global service: `GlobalService.to` (`lib/common/globle_service.dart`) — also persists theme mode and language.

### Module Structure
Each feature lives under `lib/app/modules/<name>/` with `bindings/`, `controllers/`, `views/`. Main modules:

- `tabs` — root tab shell
- `homestock`, `stockdetail`, `stockedit`, `tradelist`, `tagsedit` — stock tracking, detail, editing, trades, tags
- `homenote`, `notedetail`, `noteedit`, `notetagsedit`, `stocknote` — notes
- `datesource`, `setting`, `about`, `famous`, `use`, `splash` — data import, settings, misc
- `base`, `commonwidget`, `somewidget`, `simplesel` — shared base/widgets

### Database (Drift / SQLite)
- **Table definitions**: `lib/common/database/tables.dart`
- **Queries + migrations + `AppDatabase`**: `lib/common/database/database.dart` (generated: `database.g.dart`)
- Tables (7): `StockItems`, `NoteItems`, `StockItemTags`, `StockTags`, `StockTrades`, `NoteItemTags`, `NoteTags`. `schemaVersion` is currently 8 — bump it and add a migration branch when changing the schema.
- Default tags seeded on first create: 短期, 中期, 长期, 买, 卖.
- `DatabaseManager` (`lib/common/database/DatabaseManager.dart`) is a GetX controller managing the db path and runtime switching (multi-account). Access: `Get.find<DatabaseManager>().db`.

### Multi-Account / Data Import
- Users can switch between local db files. Importable file names must contain `stocknotes_`.
- Deep links (`app_links`) receive shared `.db` files; `AppPages.handleDeepLink` routes them to the data source page.
- `DatabaseManager.switchDatabase(path)` swaps the active db at runtime.

### Stock Quotes (only live network path)
- Real-time data from Tencent API (`https://qt.gtimg.cn/q=...`), GBK-encoded — decode with `fl_charset`.
- URL building/parsing: `lib/common/https/qs_api.dart` (`buildStockUrl`, `parseTencentStockData`). Supports A-shares (SH/SZ), HK, US, ETFs/funds.
- `qs_request.dart` / rest of `qs_api.dart` is legacy Dio wrapper code — mostly commented out, do not extend it.

### Internationalization
- GetX `Translations` (no `intl`). Keys centralized in `lib/common/langs/text_key.dart`; use `TextKey.someKey.tr`.
- Locales: zh_CN (fallback), en_US. `TranslationLibrary` wires delegates including `FlutterQuillLocalizations.delegate`.

### Theming
- `lib/common/styles/theme_data.dart` (`AppTheme.light` / `AppTheme.dark`), generated with `flex_color_scheme`.

### Notes / Rich Text
- `flutter_quill` + `flutter_quill_extensions` for embedded images.
- Images are stored locally and are **not** portable — migrating data between devices loses them.

### Extensions & Utils
- Dart extensions in `lib/common/extension/`: `String++`, `Color++`, `DateTime++`, `Num++`, `Widget++`, `Image++`, `ScrollController++`
- Utils in `lib/utils/`: `qs_cache`, `qs_hud`, `qs_date`, `encrypt_util`, etc.

## Important Implementation Details

- **ConditionStatus** (`database.dart`) is a bitmask for near/target buy/sell conditions: `nearBuy = 1<<0`, `nearSell = 1<<1`, `targetBuy = 1<<2`, `targetSell = 1<<3`. Use the `ConditionStatusExt` getters (`hasNearBuy`, …) instead of raw bit math.
- **StockItemExt** adds runtime-only state (`StockItemExtraState`, including `tagList`) via a static map keyed by `id` — it is not persisted.
- **Home list sorting**: `opTop` DESC, then a time column (`updateAt` / `cMeetUpdateAt` / `cNearUpdateAt`) depending on filter mode.
- **Slidable cells**: stock list items use `flutter_slidable` for swipe actions (hold/top/tag/favorite/delete).
- **Screen util**: `flutter_screenutil`, design size `375x812`, initialized in `main.dart`.
- **Dialogs/Toasts**: `flutter_smart_dialog` (observer registered in `GetMaterialApp`).

## Testing

`flutter test`. `test/widget_test.dart` is a placeholder smoke test — replace with real widget tests as features grow.
