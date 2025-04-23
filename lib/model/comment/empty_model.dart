import '../../common/https/base_net_model.dart';

class EmptyModel extends BaseNetModel {
  @override
  fromJson(Map<String, dynamic> json) {
    return EmptyModel.fromJson(json);
  }

  EmptyModel();
  EmptyModel.fromJson(dynamic json);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    return map;
  }
}
