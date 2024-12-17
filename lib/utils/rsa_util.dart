import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart';

/// RSA工具类
class RSAUtil {
  static RSAUtil? _instance;
  dynamic k;

  RSAUtil._();

  /// 工厂方法
  static RSAUtil getInstance() {
    _instance ??= RSAUtil._();
    return _instance!;
  }

  /// 初始化
  Future init(String key) async {
    final keyFile = await rootBundle.loadString(key);
    k = RSAKeyParser().parse(keyFile);
  }

  /// 加密
  String encode(String content) {
    final encrypter = Encrypter(RSA(publicKey: k));
    return encrypter.encrypt(content).base64;
  }

  /// 解密
  String decode(String content) {
    final encrypter = Encrypter(RSA(privateKey: k));
    return encrypter.decrypt(Encrypted.fromBase64(content));
  }

  /// 签名
  String sign(String content) {
    List<int> bytes = utf8.encode(content);
    Uint8List uint8List = Uint8List.fromList(bytes);
    return RSASigner(RSASignDigest.SHA256, privateKey: k)
        .sign(uint8List)
        .base64;
  }

  /// 验签
  bool verify(String content, String signature) {
    List<int> bytes = utf8.encode(content);
    Uint8List uint8List = Uint8List.fromList(bytes);
    return RSASigner(RSASignDigest.SHA256, publicKey: k)
        .verify(uint8List, Encrypted.fromBase64(signature));
  }
}
