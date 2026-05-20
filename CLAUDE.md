# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

股票笔记 (Stock Notes) is a privacy-first, offline Flutter application for stock investors to record and review trading strategies. It supports Android, iOS, Windows, and macOS. All data is stored locally in SQLite; no backend user data service is active.

## Common Commands

```bash
# Run the app
flutter run

# Build for platforms
flutter build apk
flutter build ios
flutter build macos
flutter build windows

# Lint
flutter analyze

# Run tests
flutter test

# Install dependencies
flutter pub get

# Regenerate Drift database code after schema changes
dart run build_runner build

# Regenerate app icons / splash screen / package name
dart run flutter_launcher_icons
dart run flutter_native_splash:create
dart run package_rename
```

## Architecture

### State Management & Routing
- Uses **GetX** for state management, routing, and dependency injection.
- Routes are defined centrally in `lib/app/routes/app_pages.dart` (pages) and `app_routes.dart` (paths).
- Initial route is `Routes.TABS`.
- Controllers extend `BaseController` (`lib/app/modules/base/base_Controller.dart`), which adds `onResume`/`onPause` visibility hooks.
- Access the global service via `GlobalService.to`.

### Module Structure
- Each feature lives under `lib/app/modules/<name>/` with subfolders:
  - `bindings/` — wires controller to view
  - `controllers/` — business logic
  - `views/` — UI
- Examples: `homestock`, `homenote`, `stockedit`, `noteedit`, `tabs`, `datesource`, `setting`, `famous`, `tagsedit`.

### Database
- Uses **Drift** (SQLite) with file-based databases.
- Schema and DAO-like queries are in `lib/common/database/database.dart`.
- Generated code is in `database.g.dart`; regenerate with `build_runner` after any schema change.
- `DatabaseManager` (`lib/common/database/DatabaseManager.dart`) is a GetX controller that manages the database path and supports switching databases for multi-account data.
- Access the DB in controllers: `Get.find<DatabaseManager>().db`.
- Tables: `StockItems`, `NoteItems`, `StockItemTags`, `StockTags`.
- Default tags are seeded on first create: 短期, 中期, 长期, 买, 卖.

### Data Import / Export & Multi-Account
- The app supports switching between local database files (multi-account).
- Database file names must contain `stocknotes_` to be accepted for import.
- Deep links (`app_links`) are used to handle shared `.db` files; `AppPages.handleDeepLink` routes them to the data source page.
- `DatabaseManager.switchDatabase(path)` swaps the active database at runtime.

### Stock Data Fetching
- Real-time stock data is fetched from **Tencent API** (`https://qt.gtimg.cn/q=...`).
- Supports A-shares (SH/SZ), Hong Kong stocks (HK), US stocks (US), and ETFs/funds.
- URL building and parsing logic is in `lib/common/https/qs_api.dart` (`buildStockUrl`, `parseTencentStockData`).
- The response is GBK-encoded; decoded with `fl_charset`.

### Internationalization
- Uses GetX `Translations` (not `intl` for dynamic switching).
- Translation keys are centralized in `lib/common/langs/text_key.dart`.
- Access in UI: `TextKey.someKey.tr`.
- Supported locales: zh_CN (fallback), en_US.
- `TranslationLibrary` wires delegates including `FlutterQuillLocalizations.delegate`.

### Theming
- Themes are in `lib/common/styles/theme_data.dart` (`AppTheme.light` / `AppTheme.dark`).
- `flex_color_scheme` is used for theme generation.
- `GlobalService` persists and switches theme mode and language.

### Notes / Rich Text
- Notes use `flutter_quill` with `flutter_quill_extensions` for embedded images.
- Images are stored locally; migrating data will lose images.

### Extensions
- Custom Dart extensions live in `lib/common/extension/`:
  - `String++`, `Color++`, `DateTime++`, `Num++`, `Widget++`, `Image++`, `ScrollController++`
- Utility classes live in `lib/utils/` (e.g., `qs_cache`, `qs_hud`, `qs_date`, `encrypt_util`).

### Networking Layer
- `lib/common/https/qs_request.dart` and `qs_api.dart` contain legacy network wrapper code around Dio.
- Most API methods are commented out; the only active network path is the Tencent stock quote fetch.

## Important Implementation Details

- **ConditionStatus** (`lib/common/database/database.dart`) uses bitmasks to represent buy/sell/near conditions for price, market cap, and PE ratio:
  - `nearBuy = 1 << 0`, `nearSell = 1 << 1`, `targetBuy = 1 << 2`, `targetSell = 1 << 3`
  - `StockItemExt` adds runtime-only `StockItemExtraState` (including `tagList`) via a static map keyed by `id`.
- **Sorting on home lists**: results are ordered by `opTop` DESC, then by a time column (`updateAt`, `cMeetUpdateAt`, or `cNearUpdateAt`) depending on filter mode.
- **Slidable cells**: stock list items use `flutter_slidable` for left-swipe actions (hold/top/tag/favorite/delete).
- **Screen util**: `flutter_screenutil` is initialized with design size `375x812` in `main.dart`.
- **Dialog/Toast**: uses `flutter_smart_dialog` (observer registered in `GetMaterialApp`).
