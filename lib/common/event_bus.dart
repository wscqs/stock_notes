// //监听登录事件
// eventBus.on("login", (arg) {
// // do something
// });
//登录成功后触发登录事件，页面A中订阅者会被调用
// eventBus.emit("login", userInfo);

//定义一个top-level（全局）变量，页面引入该文件后可以直接使用bus
var eventBus = EventBus();

//订阅者回调签名
typedef void EventCallback(arg);

class EventBus {
  //私有构造函数
  EventBus._internal();

  //保存单例
  static EventBus _singleton = EventBus._internal();

  //工厂构造函数
  factory EventBus() => _singleton;

  //保存事件订阅者队列，key:事件名(id)，value: 对应事件的订阅者队列
  final _emap = Map<Object, List<EventCallback>?>();

  //添加订阅者
  void on(eventName, EventCallback f) {
    _emap[eventName] ??= <EventCallback>[];
    _emap[eventName]!.add(f);
  }

  //移除订阅者
  void off(eventName, [EventCallback? f]) {
    var list = _emap[eventName];
    if (eventName == null || list == null) return;
    if (f == null) {
      _emap[eventName] = null;
    } else {
      list.remove(f);
    }
  }

  //触发事件，事件触发后该事件所有订阅者会被调用
  void emit(eventName, [arg]) {
    var list = _emap[eventName];
    if (list == null) return;
    int len = list.length - 1;
    //反向遍历，防止订阅者在回调中移除自身带来的下标错位
    for (var i = len; i > -1; --i) {
      list[i](arg);
    }
  }
}

// import 'package:get/get.dart';
// void main() {
//   // 注册 EventBusService
//   Get.put(EventBusService());
//
//   runApp(MyApp());
// }
// 发送 EventBusService
// void sendSampleEvent() {
//   EventBusService eventBus = Get.find<EventBusService>();
//   eventBus.sendEvent('sampleEvent', 'Hello, this is a test event!');
// }

// 接收 EventBusService
// void listenToSampleEvent() {
//   EventBusService eventBus = Get.find<EventBusService>();
//   eventBus.listenToEvent('sampleEvent', (data) {
//     print('Received event data: $data');
//   });
// }

// /// GetX 实现类似于 EventBus 的事件发送和监听机制
// class EventBusService extends GetxService {
//   // 定义一个 RxMap 来存储事件和其监听者
//   final _events = <String, Rx<dynamic>>{}.obs;
//
//   // 发送事件
//   void sendEvent(String eventName, dynamic data) {
//     // 检查事件是否存在，不存在则创建一个新的 Rx 对象
//     if (!_events.containsKey(eventName)) {
//       _events[eventName] = Rx<dynamic>(data);
//     } else {
//       _events[eventName]?.value = data;
//     }
//   }
//
//   // 监听事件
//   void listenToEvent(String eventName, Function(dynamic) callback) {
//     if (!_events.containsKey(eventName)) {
//       _events[eventName] = Rx<dynamic>(null);
//     }
//
//     // 监听事件值的变化
//     _events[eventName]?.listen((data) {
//       callback(data);
//     });
//   }
// }
