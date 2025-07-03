import 'package:get/get.dart';
import 'package:stock_notes/utils/qs_hud.dart';

import '../../../../common/event_bus.dart';
import '../../../../common/langs/text_key.dart';
import '../../commonwidget/bottom_input_dialog.dart';
import 'famous_data_help.dart';

class FamousController extends GetxController {
  final datas = <Map<String, dynamic>>[].obs;
  final selKey = ''.obs;

  final defaultFamous = {
    "key": TextKey.zhufuhuayu.tr,
    "value": TextKey.zhufuhuayu.tr,
  };

  @override
  Future<void> onInit() async {
    super.onInit();
    datas.value = FamousDataHelp().list;
    selKey.value = FamousDataHelp().getSelectedKey();
  }

  Future<void> add(String value) async {
    await FamousDataHelp().addFamous(value);
    datas.value = List<Map<String, dynamic>>.from(FamousDataHelp().list);
  }

  Future<void> delete(String key) async {
    //当前选中无法删除
    if (selKey.value == key) {
      QsHud.showToast(TextKey.xuanzhongdejingjuwufashancu.tr);
      return;
    }
    await FamousDataHelp().deleteFamous(key);
    datas.value = List<Map<String, dynamic>>.from(FamousDataHelp().list);
  }

  Future<void> updateList(String oldKey, String newValue) async {
    await FamousDataHelp().updateFamous(oldKey, newValue);
    datas.value = List<Map<String, dynamic>>.from(FamousDataHelp().list);
    selKey.value = FamousDataHelp().getSelectedKey();
  }

  Future<void> select(String key) async {
    await FamousDataHelp().setSelected(key);
    datas.value = List<Map<String, dynamic>>.from(FamousDataHelp().list);
    selKey.value = key;

    eventBus.emit("eventBusFamous", "");
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex -= 1;
    final item = datas.removeAt(oldIndex);
    datas.insert(newIndex, item);
    await FamousDataHelp().updateList(datas);
  }

  void selDefaultFamous() {
    select(defaultFamous["key"]!);
  }

  void addFamous() {
    showBottomInputDialog(
        hintText: TextKey.mingyanjinju.tr,
        onSendPressed: (value) {
          if (value == null || value.isEmpty) {
            QsHud.showToast(TextKey.shuruneirongtishi.tr);
            return;
          }
          QsHud.dismiss();
          add(value!);
        });
  }

  void clickEdit(int? index) {
    if (TextKey.zhufuhuayu == datas[index!]["key"]) {
      QsHud.showToast(TextKey.morenmingyangwufabianji.tr);
      return;
    }
    showBottomInputDialog(
        hintText: TextKey.mingyanjinju.tr,
        onSendPressed: (value) {
          if (value == null || value.isEmpty) {
            QsHud.showToast(TextKey.shuruneirongtishi.tr);
            return;
          }
          QsHud.dismiss();
          updateList(datas[index!]["key"], value!);
          eventBus.emit("eventBusFamous", "");
        },
        text: datas[index!]["value"]);
  }

  void clickDelete(int? index) {
    delete(datas[index!]["key"]);
  }
}
