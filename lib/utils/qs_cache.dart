import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

///缓存管理类 存sp,要getInstance(). 存内存直接静态方法
class QsCache {
  static Box? _box;
  SharedPreferences? prefs;
  //仅app内存
  static Map<String, dynamic> memoryCache = {};

  QsCache._() {
    init();
  }

  static QsCache? _instance;

  QsCache._pre(SharedPreferences prefs) {
    this.prefs = prefs;
  }

  ///预初始化，防止在使用get时，prefs还未完成初始化
  static Future<QsCache> preInit() async {
    if (_instance == null) {
      if (!kIsWeb) {
        final dir = await getApplicationDocumentsDirectory();
        Hive.init(dir.path);
      }
      _box = await Hive.openBox('qs_cache');
      var prefs = await SharedPreferences.getInstance();
      _instance = QsCache._pre(prefs);
    }
    return _instance!;
  }

  static QsCache getInstance() {
    if (_instance == null) {
      _instance = QsCache._();
    }
    return _instance!;
  }

  void init() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    if (_box == null) {
      if (!kIsWeb) {
        final dir = await getApplicationDocumentsDirectory();
        Hive.init(dir.path);
      }
      _box = await Hive.openBox('qs_cache');
    }
  }

  ///warn:不支持model,model存进去从本地内存取出是map，所以不要用model
  static set(String key, dynamic value) {
    _box?.put(key, value);
  }

  ///warn:不支持model,model存进去从本地内存取出是map，所以不要用model
  static T? get<T>(String key) {
    final value = _box?.get(key);
    return _normalizeValue(value) as T?;
  }

  static dynamic _normalizeValue(dynamic value) {
    if (value is Map) {
      return value.map<String, dynamic>(
        (k, v) => MapEntry(k.toString(), _normalizeValue(v)),
      );
    }
    if (value is List) {
      return value.map(_normalizeValue).toList();
    }
    return value;
  }

  static remove(String key) {
    _box?.delete(key);
  }

  //mem
  static setMemoryCache(String key, dynamic value) {
    memoryCache[key] = value;
  }

  static T? getMemoryCache<T>(String key) {
    return memoryCache[key] as T?;
  }

  static removeMemoryCache(String key) {
    memoryCache.remove(key);
  }

  // static T? getModel<T extends BaseModel>(String key) {
  //   T.fromJo
  //   return GetStorage().read(key);
  // }

  setSPString(String key, String value) {
    prefs?.setString(key, value);
  }

  setSPDouble(String key, double value) {
    prefs?.setDouble(key, value);
  }

  setSPInt(String key, int value) {
    prefs?.setInt(key, value);
  }

  setSPBool(String key, bool value) {
    prefs?.setBool(key, value);
  }

  setSPStringList(String key, List<String> value) {
    prefs?.setStringList(key, value);
  }

  removeSP(String key) {
    prefs?.remove(key);
  }

  T? getSP<T>(String key) {
    var result = prefs?.get(key);
    if (result != null) {
      return result as T;
    }
    return null;
  }
}
