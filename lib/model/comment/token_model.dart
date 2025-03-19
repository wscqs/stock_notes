import '../../common/https/base_net_model.dart';

/// token : "707137d51ac89217b0e64b43e7f98960"
/// refresh_token : "90f6610b1c3175617e97b1e41f24f9f2"

class TokenModel extends BaseNetModel {
  @override
  fromJson(Map<String, dynamic> json) {
    return TokenModel.fromJson(json);
  }

  TokenModel({
    this.token,
    this.refreshToken,
  });

  TokenModel.fromJson(dynamic json) {
    token = json['token'];
    refreshToken = json['refresh_token'];
  }
  String? token;
  String? refreshToken;
  TokenModel copyWith({
    String? token,
    String? refreshToken,
  }) =>
      TokenModel(
        token: token ?? this.token,
        refreshToken: refreshToken ?? this.refreshToken,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = token;
    map['refresh_token'] = refreshToken;
    return map;
  }
}
