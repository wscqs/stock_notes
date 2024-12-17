import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  /// 格式化日期和时间字符串
  String format(String pattern) {
    final formatter = DateFormat(pattern);
    return formatter.format(this);
  }

  // 格式化DateTime
  String dateFormat(String pattern) {
    return DateFormat(pattern).format(this);
  }

  // 获取日期字符串
  String toDateString() {
    return dateFormat(DateFormats.y_mo_d);
  }

  // 获取日期时间字符串
  String toDateTimeString() {
    return dateFormat(DateFormats.full);
  }

  // 获取时间字符串
  String toTimeString() {
    return dateFormat(DateFormats.h_m_s);
  }
}

class DateFormats {
  static String full = 'yyyy-MM-dd HH:mm:ss';
  static String y_mo_d_h_m = 'yyyy-MM-dd HH:mm';
  static String y_mo_d = 'yyyy-MM-dd';
  static String y_mo = 'yyyy-MM';
  static String mo_d = 'MM-dd';
  static String mo_d_h_m = 'MM-dd HH:mm';
  static String h_m_s = 'HH:mm:ss';
  static String h_m = 'HH:mm';

  static String zh_full = 'yyyy年MM月dd日 HH时mm分ss秒';
  static String zh_y_mo_d_h_m = 'yyyy年MM月dd日 HH时mm分';
  static String zh_y_mo_d = 'yyyy年MM月dd日';
  static String zh_y_mo = 'yyyy年MM月';
  static String zh_mo_d = 'MM月dd日';
  static String zh_mo_d_h_m = 'MM月dd日 HH时mm分';
  static String zh_h_m_s = 'HH时mm分ss秒';
  static String zh_h_m = 'HH时mm分';
}
