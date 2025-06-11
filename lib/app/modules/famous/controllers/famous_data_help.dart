import 'package:get/get.dart';
import 'package:stock_notes/utils/qs_cache.dart';

import '../../../../common/langs/text_key.dart';

class FamousDataHelp {
  static final FamousDataHelp _singleton = FamousDataHelp._internal();
  factory FamousDataHelp() => _singleton;
  FamousDataHelp._internal();

  List<Map<String, dynamic>> _list = [];

  List<Map<String, dynamic>> get list => _list;

  Future<void> loadFamous() async {
    List<dynamic>? storedList = await QsCache.get("FamousDataKey");
    if (storedList != null) {
      _list = List<Map<String, dynamic>>.from(storedList);
    } else {
      _list = [
        {
          "key": TextKey.zhufuhuayu,
          "value": TextKey.zhufuhuayu,
          "isSel": true,
        }
      ];
      await _saveFamousToCache();
    }
  }

  Future<void> updateList(List<Map<String, dynamic>> newList) async {
    _list = newList;
    await _saveFamousToCache();
  }

  Future<void> addFamous(String value) async {
    _list.add({
      "key": value,
      "value": value,
      "isSel": false,
    });
    await _saveFamousToCache();
  }

  Future<void> deleteFamous(String key) async {
    _list.removeWhere((element) => element["key"] == key);
    await _saveFamousToCache();
  }

  Future<void> updateFamous(String oldKey, String newValue) async {
    for (int i = 0; i < _list.length; i++) {
      if (_list[i]["key"] == oldKey) {
        _list[i]["key"] = newValue;
        _list[i]["value"] = newValue;
        break;
      }
    }
    await _saveFamousToCache();
  }

  Future<void> setSelected(String key) async {
    for (final item in _list) {
      item["isSel"] = item["key"] == key;
    }
    await _saveFamousToCache();
  }

  String getSelectedValue() {
    final sel = _list.firstWhere((e) => e["isSel"] == true, orElse: () => {});
    String value =
        sel["key"] == TextKey.zhufuhuayu ? TextKey.zhufuhuayu.tr : sel["value"];
    return value;
  }

  String getSelectedKey() {
    final sel = _list.firstWhere((e) => e["isSel"] == true, orElse: () => {});
    return sel["key"];
  }

  Future<void> _saveFamousToCache() async {
    await QsCache.set("FamousDataKey", _list);
  }
}
