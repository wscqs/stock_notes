import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../utils/qs_cache.dart';
import 'database.dart';

// //main 设置   final dbManager = DatabaseManager();
//   await dbManager.init(); // or provide path
//   Get.put(dbManager);
// //页面获取 final db = Get.find<DatabaseManager>().db;
// //需要导入导出才用这

class DatabaseManager extends GetxController {
  AppDatabase? _db;
  String? _currentPath;

  AppDatabase get db {
    if (_db == null) throw Exception("Database not initialized");
    return _db!;
  }

  Future<void> init({String? path}) async {
    final dbPath = path ?? await _defaultDbPath();
    _currentPath = dbPath;
    _db = AppDatabase(dbPath);
  }

  Future<void> switchDatabase(String path) async {
    await _db?.close();
    _db = AppDatabase(path);
    _currentPath = path;
    update(); // notify GetBuilder if needed
  }

  String? get currentPath => _currentPath;

  Future<void> close() async {
    await _db?.close();
    _db = null;
    _currentPath = null;
  }

  Future<String> _defaultDbPath() async {
    if (loadLocalDbPath().isNotEmpty) {
      return loadLocalDbPath();
    }
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, 'stock_database.sqlite');
  }

  String loadLocalDbPath() {
    var selectedDateSourceKey =
        QsCache.get<String>("selectedDateSourceKey") ?? "";
    if (selectedDateSourceKey.isNotEmpty) {
      // 读取数据，返回 List<dynamic>
      List<dynamic>? storedList = QsCache.get("dateSourceListKey");
      if (storedList != null) {
        // 将 List<dynamic> 转换为 List<Map<String, dynamic>>
        List<Map<String, dynamic>> tempDateSourceList =
            List<Map<String, dynamic>>.from(storedList);
        final matched = tempDateSourceList.firstWhere(
          (element) => element["name"] == selectedDateSourceKey,
        );
        final path = matched?["path"];
        return path ?? "";
      }
    }
    return "";
  }
}
