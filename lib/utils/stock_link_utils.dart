import 'package:stock_notes/common/database/database.dart';

/// 工具类：在笔记内容中根据数据库已记录的股票自动识别并包装为可点击链接
class StockLinkUtils {
  /// 将 Quill Delta 中的股票代码/名称包装为 link 属性
  /// 保存前先清除所有旧的 stocknotes link，再根据数据库中的股票列表重新匹配包装
  static List<dynamic> wrapStockCodesInDelta(
    List<dynamic> delta,
    List<StockItem> stocks,
  ) {
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

      // 将文本按股票名称/代码分割，并给匹配项加上 link 属性
      final segments = _splitTextWithStocks(insert, stocks);
      if (segments.length == 1 && !segments.first.isStockCode) {
        // 没有匹配到股票，保持原样
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
  /// stocknotes://stock/sh600519 -> sh600519
  static String? parseStockCodeFromLink(String link) {
    final prefix = 'stocknotes://stock/';
    if (link.startsWith(prefix)) {
      return link.substring(prefix.length);
    }
    return null;
  }

  /// 根据数据库中的股票列表，分割文本为普通文本和股票匹配项
  static List<_TextSegment> _splitTextWithStocks(
    String text,
    List<StockItem> stocks,
  ) {
    if (stocks.isEmpty) {
      return [_TextSegment(text: text, isStockCode: false)];
    }

    // 按 code 去重
    final codeSet = <String>{};
    final uniqueStocks = <StockItem>[];
    for (final s in stocks) {
      final c = s.code.toLowerCase();
      if (!codeSet.contains(c)) {
        codeSet.add(c);
        uniqueStocks.add(s);
      }
    }

    // 按名称长度降序排序，优先匹配长名称（如"腾讯控股"优先于"腾讯"）
    final sortedByName = uniqueStocks.toList()
      ..sort((a, b) => b.name.length.compareTo(a.name.length));

    final lowerText = text.toLowerCase();
    final matches = <_StockMatch>[];

    // 1. 按名称匹配
    for (final stock in sortedByName) {
      if (stock.name.isEmpty) continue;
      final lowerName = stock.name.toLowerCase();
      int start = 0;
      while (true) {
        final idx = lowerText.indexOf(lowerName, start);
        if (idx == -1) break;
        matches.add(_StockMatch(
          start: idx,
          end: idx + stock.name.length,
          stock: stock,
        ));
        start = idx + stock.name.length;
      }
    }

    // 2. 按带前缀的代码匹配（如 SH600519 / sh600519）
    final upperText = text.toUpperCase();
    for (final stock in uniqueStocks) {
      final upperCode = stock.code.toUpperCase();
      int start = 0;
      while (true) {
        final idx = upperText.indexOf(upperCode, start);
        if (idx == -1) break;
        final overlaps = matches.any(
          (m) => m.start < idx + upperCode.length && m.end > idx,
        );
        if (!overlaps) {
          matches.add(_StockMatch(
            start: idx,
            end: idx + upperCode.length,
            stock: stock,
          ));
        }
        start = idx + upperCode.length;
      }

      // 3. 按纯数字代码匹配（如 600519）
      final numCode = upperCode.replaceFirst(RegExp(r'^[A-Z]{2}'), '');
      if (numCode.length >= 5) {
        int nStart = 0;
        while (true) {
          final idx = text.indexOf(numCode, nStart);
          if (idx == -1) break;
          // 确保前后不是数字，避免部分匹配（如 6005198 中的 600519）
          final prevChar = idx > 0 ? text[idx - 1] : null;
          final nextChar =
              idx + numCode.length < text.length ? text[idx + numCode.length] : null;
          final prevIsDigit = prevChar != null && RegExp(r'\d').hasMatch(prevChar);
          final nextIsDigit = nextChar != null && RegExp(r'\d').hasMatch(nextChar);
          if (!prevIsDigit && !nextIsDigit) {
            final overlaps = matches.any(
              (m) => m.start < idx + numCode.length && m.end > idx,
            );
            if (!overlaps) {
              matches.add(_StockMatch(
                start: idx,
                end: idx + numCode.length,
                stock: stock,
              ));
            }
          }
          nStart = idx + numCode.length;
        }
      }
    }

    // 按起始位置排序，去除重叠（保留先出现的）
    matches.sort((a, b) => a.start.compareTo(b.start));
    final nonOverlapping = <_StockMatch>[];
    for (final match in matches) {
      if (nonOverlapping.isEmpty || nonOverlapping.last.end <= match.start) {
        nonOverlapping.add(match);
      }
    }

    // 分割文本
    final segments = <_TextSegment>[];
    int lastEnd = 0;
    for (final match in nonOverlapping) {
      if (match.start > lastEnd) {
        segments.add(_TextSegment(
          text: text.substring(lastEnd, match.start),
          isStockCode: false,
        ));
      }
      segments.add(_TextSegment(
        text: text.substring(match.start, match.end),
        isStockCode: true,
        stockCode: match.stock.code,
      ));
      lastEnd = match.end;
    }
    if (lastEnd < text.length) {
      segments.add(_TextSegment(
        text: text.substring(lastEnd),
        isStockCode: false,
      ));
    }

    if (segments.isEmpty) {
      segments.add(_TextSegment(text: text, isStockCode: false));
    }

    return segments;
  }
}

class _StockMatch {
  final int start;
  final int end;
  final StockItem stock;

  _StockMatch({
    required this.start,
    required this.end,
    required this.stock,
  });
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
