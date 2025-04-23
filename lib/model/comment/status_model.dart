/// state : "success"
library;

class StatusModel {
  StatusModel({
    this.state,
  });

  StatusModel.fromJson(dynamic json) {
    state = json['state'];
  }
  String? state;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['state'] = state;
    return map;
  }
}
