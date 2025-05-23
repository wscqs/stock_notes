// import 'package:get/get.dart';
//
// import 'database.dart';
//
// //无用！
// //main 设置 Get.put(DatabaseManager());
// //页面获取 final db = Get.find<DatabaseManager>().db;
// //需要导入导出才用这
// class DatabaseManager extends GetxController {
//   final _db = Rx<AppDatabase>(AppDatabase());
//
//   AppDatabase get db => _db.value;
//
//   Future<void> resetDb() async {
//     await _db.value.close(); // close old
//     _db.value = AppDatabase(); // assign new
//     update();
//     refresh();
//   }
// }
