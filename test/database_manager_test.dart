import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:stock_notes/common/database/DatabaseManager.dart';
import 'package:stock_notes/common/database/database.dart';

void main() {
  test('switchDatabase 关闭旧库并切换到新库，旧引用不可再用', () async {
    final dir = await Directory.systemTemp.createTemp('dbm_test');
    addTearDown(() => dir.delete(recursive: true));

    final manager = DatabaseManager();
    await manager.init(path: '${dir.path}/a.db');
    final AppDatabase oldDb = manager.db;
    await oldDb.customSelect('SELECT 1').get(); // 确保旧库已真正打开

    await manager.switchDatabase('${dir.path}/b.db');

    // 管理器已持有新库
    expect(manager.db, isNot(same(oldDb)));
    expect(manager.currentPath, endsWith('b.db'));

    // 旧库已关闭：仍缓存旧引用的调用方（修复前的 final db 写法）会抛异常
    expect(oldDb.customSelect('SELECT 1').get(), throwsA(anything));

    // 新库可正常读写
    await manager.db.customSelect('SELECT 1').get();
    expect(File('${dir.path}/b.db').existsSync(), isTrue);

    await manager.close();
  });
}
