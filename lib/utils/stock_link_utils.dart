/// 工具类：在笔记内容中自动识别股票代码，并包装为可点击的链接
class StockLinkUtils {
  // 匹配带市场前缀的股票代码：SH600519, sz000001, HK00700 等
  static final RegExp _prefixedCodeRegex = RegExp(
    r'\b([SHSZHK]{2})(\d{5,6})\b',
    caseSensitive: false,
  );

  // 匹配独立的6位数字（前后不是数字），用于推断市场
  static final RegExp _numericCodeRegex = RegExp(
    r'(?<!\d)(\d{6})(?!\d)',
  );

  /// 从纯文本中提取所有股票代码（去重）
  static List<String> extractStockCodes(String plainText) {
    final codes = <String>{};

    // 匹配带前缀的，如 SH600519
    for (final match in _prefixedCodeRegex.allMatches(plainText)) {
      final prefix = match.group(1)!.toUpperCase();
      final number = match.group(2)!;
      codes.add('$prefix$number');
    }

    // 匹配纯数字的，如 600519
    for (final match in _numericCodeRegex.allMatches(plainText)) {
      final number = match.group(1)!;
      final prefix = _inferMarketPrefix(number);
      if (prefix != null) {
        codes.add('$prefix$number');
      }
    }

    return codes.toList();
  }

  /// 从 Quill Delta JSON 中提取所有股票代码
  static List<String> extractStockCodesFromDelta(List<dynamic> delta) {
    final plainText = _deltaToPlainText(delta);
    return extractStockCodes(plainText);
  }

  /// 将 Quill Delta 中的股票代码文本包装为 link 属性
  /// 保存前先清除所有旧的 stocknotes link，再根据当前文本重新包装
  static List<dynamic> wrapStockCodesInDelta(List<dynamic> delta) {
    // 先清除旧的 stocknotes link，避免用户修改文本后残留无效 link
    final cleanedDelta = _clearStockCodeLinks(delta);
    final result = <dynamic>[];

    for (final op in cleanedDelta) {
      if (op is! Map<String, dynamic>) {
        result.add(op);
        continue;
      }

      final insert = op['insert'];
      final attributes = op['attributes'] as Map<String, dynamic>?;

      // 跳过非文本内容（embed、图片等）
      if (insert is! String) {
        result.add(op);
        continue;
      }

      // 将文本按股票代码分割，并给股票代码加上 link 属性
      final segments = _splitTextWithStockCodes(insert);
      if (segments.length == 1 && !segments.first.isStockCode) {
        // 没有股票代码，保持原样
        result.add(op);
        continue;
      }

      for (final seg in segments) {
        if (seg.isStockCode && seg.stockCode != null) {
          result.add({
            'insert': seg.text,
            'attributes': {
              'link': 'stocknotes://stock/${seg.stockCode}',
            },
          });
        } else {
          if (attributes != null && attributes.isNotEmpty) {
            result.add({
              'insert': seg.text,
              'attributes': Map<String, dynamic>.from(attributes),
            });
          } else {
            result.add({'insert': seg.text});
          }
        }
      }
    }

    return result;
  }

  /// 清除 Delta 中所有 stocknotes:// 开头的 link 属性
  static List<dynamic> _clearStockCodeLinks(List<dynamic> delta) {
    final result = <dynamic>[];
    for (final op in delta) {
      if (op is! Map<String, dynamic>) {
        result.add(op);
        continue;
      }

      final attributes = op['attributes'] as Map<String, dynamic>?;
      if (attributes != null && attributes.containsKey('link')) {
        final link = attributes['link'] as String?;
        if (link != null && link.startsWith('stocknotes://stock/')) {
          // 移除 stocknotes link，保留其他属性（如 bold、color 等）
          final newAttributes = Map<String, dynamic>.from(attributes);
          newAttributes.remove('link');
          if (newAttributes.isEmpty) {
            result.add({'insert': op['insert']});
          } else {
            result.add({
              'insert': op['insert'],
              'attributes': newAttributes,
            });
          }
          continue;
        }
      }
      result.add(op);
    }
    return result;
  }

  /// 检查 Delta 中是否已包含股票代码 link
  static bool hasStockCodeLinks(List<dynamic> delta) {
    for (final op in delta) {
      if (op is Map<String, dynamic>) {
        final attrs = op['attributes'] as Map<String, dynamic>?;
        final link = attrs?['link'] as String?;
        if (link != null && link.startsWith('stocknotes://stock/')) {
          return true;
        }
      }
    }
    return false;
  }

  /// 从 link URL 中解析股票代码
  /// stocknotes://stock/SH600519 -> SH600519
  static String? parseStockCodeFromLink(String link) {
    final prefix = 'stocknotes://stock/';
    if (link.startsWith(prefix)) {
      return link.substring(prefix.length);
    }
    return null;
  }

  /// 将纯数字转换为带前缀的股票代码
  static String? normalizeStockCode(String code) {
    code = code.trim().toUpperCase();
    // 如果已经有前缀，直接返回
    if (_prefixedCodeRegex.hasMatch(code)) {
      return code;
    }
    // 纯数字，尝试推断市场
    if (RegExp(r'^\d{6}$').hasMatch(code)) {
      final prefix = _inferMarketPrefix(code);
      if (prefix != null) {
        return '$prefix$code';
      }
    }
    return null;
  }

  /// 根据6位数字推断市场前缀
  static String? _inferMarketPrefix(String number) {
    if (number.length != 6) return null;
    final first = number[0];
    // 上海：6/9（股票、科创板）、5/1（基金、ETF）
    if (['6', '9', '5', '1'].contains(first)) {
      return 'SH';
    }
    // 深圳：0/2（主板、中小板）、3（创业板）
    if (['0', '2', '3'].contains(first)) {
      return 'SZ';
    }
    return null;
  }

  static String _deltaToPlainText(List<dynamic> delta) {
    final buffer = StringBuffer();
    for (final op in delta) {
      if (op is Map<String, dynamic>) {
        final insert = op['insert'];
        if (insert is String) {
          buffer.write(insert);
        }
      }
    }
    return buffer.toString();
  }

  static List<_TextSegment> _splitTextWithStockCodes(String text) {
    final segments = <_TextSegment>[];
    int lastEnd = 0;

    // 先匹配带前缀的股票代码
    for (final match in _prefixedCodeRegex.allMatches(text)) {
      if (match.start > lastEnd) {
        segments.add(_TextSegment(
          text: text.substring(lastEnd, match.start),
          isStockCode: false,
        ));
      }
      final prefix = match.group(1)!.toUpperCase();
      final number = match.group(2)!;
      segments.add(_TextSegment(
        text: match.group(0)!,
        isStockCode: true,
        stockCode: '$prefix$number',
      ));
      lastEnd = match.end;
    }

    // 处理剩余文本中的纯数字股票代码
    if (lastEnd < text.length) {
      final remaining = text.substring(lastEnd);
      int numLastEnd = 0;

      for (final match in _numericCodeRegex.allMatches(remaining)) {
        if (match.start > numLastEnd) {
          segments.add(_TextSegment(
            text: remaining.substring(numLastEnd, match.start),
            isStockCode: false,
          ));
        }
        final number = match.group(1)!;
        final prefix = _inferMarketPrefix(number);
        if (prefix != null) {
          segments.add(_TextSegment(
            text: match.group(0)!,
            isStockCode: true,
            stockCode: '$prefix$number',
          ));
        } else {
          segments.add(_TextSegment(
            text: match.group(0)!,
            isStockCode: false,
          ));
        }
        numLastEnd = match.end;
      }

      if (numLastEnd < remaining.length) {
        segments.add(_TextSegment(
          text: remaining.substring(numLastEnd),
          isStockCode: false,
        ));
      }
    }

    if (segments.isEmpty) {
      segments.add(_TextSegment(text: text, isStockCode: false));
    }

    return segments;
  }
}

class _TextSegment {
  final String text;
  final bool isStockCode;
  final String? stockCode;

  _TextSegment({
    required this.text,
    this.isStockCode = false,
    this.stockCode,
  });
}
