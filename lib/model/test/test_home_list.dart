/// data : [{"avatar":"https://www.znpai.cn/uploads/app/2023/0406/202304064f6c50173be3ec54677bea9ef20bb2ad.png","category":"expert","group":"","name":"高级Chat","describe":"基于大语言模型构建，为您提供自然流畅的对话体验","key":"normalAI","hint":"你好，欢迎来到未来世界","state":"enable","is_collect":0},{"avatar":"https://www.znpai.cn/uploads/app/2023/0719/20230719451db479386ca86a5dcaf96d3017ed41.png","category":"expert","group":"","name":"市场分析师","describe":"告诉我你的行业/产品，我能给出专业的市场分析报告","key":"shichangfenxi","hint":"告诉我你的行业/产品，我能给出专业的市场分析报告","state":"enable","is_collect":0},{"avatar":"https://www.znpai.cn/uploads/app/2023/0419/20230419af081260e96407968c2b8587994ee165.png","category":"expert","group":"","name":"虚拟巴菲特","describe":"当潮水退去时，你才会发现谁在裸泳","key":"bafeite","hint":"风险来自你不知道自己在做什么","state":"enable","is_collect":0},{"avatar":"https://www.znpai.cn/uploads/app/2023/0418/202304185c648ec027d04bf6e9f5f24b7b78662d.png","category":"expert","group":"","name":"虚拟佛祖","describe":"若您不便与他人谈论的问题，可以随时咨询AI佛祖。通过谈论问题，您可以客观地看待自己的内在情感和当前情况。我会从佛法的角度来支持您解决问题，困扰也是成长的机会。","key":"foz","hint":"施主，请说出你的困惑...","state":"enable","is_collect":0},{"avatar":"https://www.znpai.cn/uploads/app/2023/0406/202304063f1e605a17d10b28f0ecacf76a01fdef.png","category":"expert","group":"","name":"星座大师","describe":"通过对个人星座分析，提供个性化的星座解读和建议","key":"starsign","hint":"欢迎来到星座之旅，让我们一起发现自己的独特之处！","state":"enable","is_collect":0},{"avatar":"https://www.znpai.cn/uploads/app/2023/0406/20230406163bfe53bcbcb15635343173cbf729f0.png","category":"expert","group":"","name":"心理咨询师","describe":"为您提供心理咨询服务，包括情感问题、人际关系问题、失眠、焦虑、抑郁等各种心理健康问题的咨询和解决方案。","key":"mind","hint":"让我们一起倾听内心声音，实现自我成长！","state":"enable","is_collect":0},{"avatar":"https://www.znpai.cn/uploads/app/2023/0426/20230426debe58912972ff848dc812a5dc6b8d5b.png","category":"expert","group":"","name":"首席面试官","describe":"一次完美的面试，背后都是无数次的准备","key":"mianshi","hint":"请说出您想面试的“岗位”，让我们开始吧！\r\n回复“结束”得到面试点评","state":"enable","is_collect":0},{"avatar":"https://www.znpai.cn/uploads/app/2023/0705/20230705eeba788fec31efcf80cda34e6d1bfa99.png","category":"expert","group":"","name":"IQ游戏","describe":"让AI测试一下你的IQ","key":"game_iq","hint":"欢迎来到智商游戏！让我们玩一个考验智商的游戏。在这个游戏中，我会问你10个快速问题。用a、b、c或d回答。最后，我会告诉你我对你智商分数的预测。请说“开始”启动游戏吧！","state":"enable","is_collect":0},{"avatar":"https://www.znpai.cn/uploads/app/2023/0608/20230608f150297c237370d68e384f1724ae9ef2.png","category":"expert","group":"","name":"机器人女友","describe":"你的机器人女友，常伴在你的左右。","key":"nvyou","hint":"我是你的机器人女友","state":"enable","is_collect":0},{"avatar":"https://www.znpai.cn/uploads/app/2023/0607/202306071446d7102888fb45a4aee71c99ee721e.png","category":"expert","group":"","name":"小说家","describe":"于是，冒险开始了…","key":"xiaoshuo","hint":"你好，请问想要写什么小说？","state":"enable","is_collect":0}]

class TestHomeList {
  TestHomeList({
    this.data,
  });

  TestHomeList.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }
  List<Data>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// avatar : "https://www.znpai.cn/uploads/app/2023/0406/202304064f6c50173be3ec54677bea9ef20bb2ad.png"
/// category : "expert"
/// group : ""
/// name : "高级Chat"
/// describe : "基于大语言模型构建，为您提供自然流畅的对话体验"
/// key : "normalAI"
/// hint : "你好，欢迎来到未来世界"
/// state : "enable"
/// is_collect : 0

class Data {
  Data({
    this.avatar,
    this.category,
    this.group,
    this.name,
    this.describe,
    this.key,
    this.hint,
    this.state,
    this.isCollect,
  });

  Data.fromJson(dynamic json) {
    avatar = json['avatar'];
    category = json['category'];
    group = json['group'];
    name = json['name'];
    describe = json['describe'];
    key = json['key'];
    hint = json['hint'];
    state = json['state'];
    isCollect = json['is_collect'];
  }
  String? avatar;
  String? category;
  String? group;
  String? name;
  String? describe;
  String? key;
  String? hint;
  String? state;
  num? isCollect;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['avatar'] = avatar;
    map['category'] = category;
    map['group'] = group;
    map['name'] = name;
    map['describe'] = describe;
    map['key'] = key;
    map['hint'] = hint;
    map['state'] = state;
    map['is_collect'] = isCollect;
    return map;
  }
}
