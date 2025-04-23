// late final EventBusCallback eventBuscallback = (arg) {
//   print(arg);
// };
// eventBus.on("testEvent", eventBuscallback);
// eventBus.off("testEvent", eventBuscallback);
// eventBus.emit("testEvent", "Hello, World!");

//定义一个top-level（全局）变量，页面引入该文件后可以直接使用bus
var eventBus = EventBus();

//订阅者回调签名
typedef void EventBusCallback(arg);

class EventBus {
  //私有构造函数
  EventBus._internal();

  //保存单例
  static final EventBus _singleton = EventBus._internal();

  //工厂构造函数
  factory EventBus() => _singleton;

  //保存事件订阅者队列，key:事件名(id)，value: 对应事件的订阅者队列
  final _emap = <Object, List<EventBusCallback>?>{};

  //添加订阅者
  void on(eventName, EventBusCallback f) {
    _emap[eventName] ??= <EventBusCallback>[];
    _emap[eventName]!.add(f);
  }

  //移除指定订阅者
  void off(eventName, EventBusCallback f) {
    var list = _emap[eventName];
    if (eventName == null || list == null) return;
    list.remove(f);
  }

  //确定移除eventName所有的订阅者（基本不要用这）
  void offAll(eventName) {
    _emap[eventName] = null;
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
