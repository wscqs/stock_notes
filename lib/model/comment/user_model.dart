import '../../common/https/base_net_model.dart';

/// id : "371"
/// email : "11111@qq.com"
/// nickname : "11111"
/// headimage : "https://top.wlspapp.com/a.jpg"
/// birth_time : "1990-01-01 00:00:00"
/// vip_expiry : "2026-01-10"
/// is_vip : "1"

class UserModel extends BaseNetModel {
  @override
  fromJson(Map<String, dynamic> json) {
    return UserModel.fromJson(json);
  }

  UserModel({
    this.id,
    this.email,
    this.nickname,
    this.headimage,
    this.birthTime,
    this.vipExpiry,
    this.isVip,
  });

  UserModel.fromJson(dynamic json) {
    id = json['id'];
    email = json['email'];
    nickname = json['nickname'];
    headimage = json['headimage'];
    birthTime = json['birth_time'];
    vipExpiry = json['vip_expiry'];
    isVip = json['is_vip'];
  }
  String? id;
  String? email;
  String? nickname;
  String? headimage;
  String? birthTime;
  String? vipExpiry;
  String? isVip;

  // String getShowBirthTime() {
  //   if (birthTime == null || birthTime == "") {
  //     return "";
  //   } else {
  //     return QsDate.formatDateStr(birthTime!, format: DateFormats.y_m_d);
  //   }
  // }

  // UserModel copyWith({
  //   String? email,
  //   String? nickname,
  //   String? is_vip,
  // }) =>
  //     UserModel(
  //       email: email ?? this.email,
  //       nickname: nickname ?? this.nickname,
  //       is_vip: is_vip ?? this.is_vip,
  //     );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['email'] = email;
    map['nickname'] = nickname;
    map['headimage'] = headimage;
    map['birth_time'] = birthTime;
    map['vip_expiry'] = vipExpiry;
    map['is_vip'] = isVip;
    return map;
  }
}
