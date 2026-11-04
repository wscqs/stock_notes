import 'dart:math' as math;

import 'package:drift/drift.dart' hide Column;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:intl/intl.dart';
import 'package:stock_notes/common/comment_style.dart';
import 'package:stock_notes/common/database/database.dart';
import 'package:stock_notes/common/extension/StockTrade++.dart';
import 'package:stock_notes/common/https/qs_api.dart';
import 'package:stock_notes/common/https/stock_kline_service.dart';
import 'package:stock_notes/common/langs/text_key.dart';
import 'package:stock_notes/common/model/trade_profit_calculator.dart';

class TradeProfitChartSheet {
  static Future<void> show({
    required StockItem stock,
    required StockTrade trade,
    required Future<void> Function(DateTime closeDate) onCloseDateSaved,
    String? currentPrice,
    StockKlineService? service,
  }) {
    return Get.bottomSheet(
      SizedBox(
        height: math.min(Get.height * .78, 660),
        child: TradeProfitChartContent(
            stock: stock,
            trade: trade,
            currentPrice: currentPrice,
            service: service ?? StockKlineService(),
            onCloseDateSaved: onCloseDateSaved),
      ),
      isScrollControlled: true,
      backgroundColor: Get.theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    );
  }
}

class TradeProfitChartContent extends StatefulWidget {
  final StockItem stock;
  final StockTrade trade;
  final StockKlineService service;
  final String? currentPrice;
  final Future<void> Function(DateTime closeDate) onCloseDateSaved;
  const TradeProfitChartContent(
      {super.key,
      required this.stock,
      required this.trade,
      this.currentPrice,
      required this.service,
      required this.onCloseDateSaved});

  @override
  State<TradeProfitChartContent> createState() =>
      _TradeProfitChartContentState();
}

class _TradeProfitChartContentState extends State<TradeProfitChartContent> {
  TradeProfitSeries? _series;
  Object? _error;
  bool _loading = true;
  bool _rateMode = false;
  int? _selectedIndex;
  late StockTrade _trade;

  bool get _adjusted {
    final code = QsApi.formatStockCode(widget.stock.code);
    return code.startsWith('sh') || code.startsWith('sz');
  }

  @override
  void initState() {
    super.initState();
    _trade = widget.trade;
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
      _selectedIndex = null;
    });
    try {
      final end = _trade.closeDate;
      final hasCloseDate = end != null;
      final rows = await widget.service.fetchDaily(
          stock: widget.stock,
          start: _trade.tradeDate ?? _trade.createdAt,
          end: end);
      if (!mounted) return;
      setState(() {
        _series = TradeProfitCalculator.calculate(
            openPrice: _trade.openPrice,
            openShares: _trade.openShares,
            tradeType: _trade.tradeType,
            dailyCloses: rows,
            actualClosePrice: _trade.isCompleted ? _trade.closePrice : null,
            latestPrice: hasCloseDate ? null : widget.currentPrice,
            latestDate: hasCloseDate ? end : DateTime.now());
        _loading = false;
      });
    } catch (error) {
      if (mounted)
        setState(() {
          _error = error;
          _loading = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Text('${widget.stock.name} ',
                style: theme.textTheme.titleLarge,
                overflow: TextOverflow.ellipsis),
            Text(
              TextKey.lishiyingkui.tr,
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
            kSpaceMax(),
            _buildModeSwitch(theme),
            const SizedBox(width: 4),
            IconButton(onPressed: Get.back, icon: const Icon(Icons.close)),
          ]),
          const SizedBox(height: 12),
          Expanded(child: _buildBody(theme)),
        ]),
      ),
    );
  }

  Widget _buildModeSwitch(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: .45),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        _modeOption(TextKey.shouyie.tr, false, theme),
        _modeOption(TextKey.shouyilv.tr, true, theme),
      ]),
    );
  }

  Widget _modeOption(String label, bool rate, ThemeData theme) {
    final selected = _rateMode == rate;
    return InkWell(
      borderRadius: BorderRadius.circular(7),
      onTap: () => setState(() {
        _rateMode = rate;
        _selectedIndex = null;
      }),
      child: Container(
        constraints: const BoxConstraints(minWidth: 48, minHeight: 34),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? theme.colorScheme.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
          border: selected
              ? Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: .25))
              : null,
        ),
        child: Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                color: selected
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurfaceVariant)),
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(
            _error is UnsupportedStockMarketException
                ? TextKey.zanbuzhichihangqing.tr
                : TextKey.hangqingjiazai.tr,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge),
        if (_error is! UnsupportedStockMarketException)
          TextButton(onPressed: _load, child: Text(TextKey.chongshi.tr)),
      ]));
    }
    final series = _series;
    final openDay = _trade.tradeDate ?? _trade.createdAt;
    final startMissing = series == null ||
        series.points.isEmpty ||
        series.points.first.date.difference(openDay).inDays > 7;
    if (startMissing) {
      return Center(child: Text(TextKey.zanwulishihangqing.tr));
    }
    final selected = _selectedIndex == null
        ? series.points.last
        : series.points[_selectedIndex!];
    final headerDate = _selectedIndex == null && _trade.closeDate == null
        ? DateTime.now()
        : selected.date;
    final dateText = DateFormat('yyyy-MM-dd').format(headerDate);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(dateText,
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      const SizedBox(height: 8),
      Row(children: [
        Expanded(
            child: _metric(TextKey.dangqianyingkui.tr, _value(selected),
                _color(selected.profit))),
        Expanded(
            child: _metric(TextKey.zuidahuiche.tr, _number(series.maxDrawdown),
                theme.colorScheme.onSurface,
                alignEnd: true)),
      ]),
      const SizedBox(height: 20),
      Expanded(child: _buildChart(series, theme)),
      const SizedBox(height: 6),
      Text(_adjusted ? TextKey.qianfuquangusuan.tr : TextKey.bufuquangusuan.tr,
          style: theme.textTheme.bodySmall
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      if (_trade.isCompleted && _trade.closeDate == null)
        TextButton(
            onPressed: _pickCloseDate,
            child: Text(TextKey.weishezhipingcangriqi.tr)),
    ]);
  }

  Widget _metric(String label, String value, Color color,
      {bool alignEnd = false}) {
    return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: alignEnd ? WrapAlignment.end : WrapAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 15)),
          const SizedBox(width: 8),
          Text(value,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600, color: color)),
        ]);
  }

  String _value(TradeProfitPoint point) => _rateMode
      ? '${(point.yieldRate * 100).toStringAsFixed(2)}%'
      : point.profit.toStringAsFixed(2);
  String _number(double amount) => _rateMode
      ? '${(amount / (double.parse(_trade.openShares!) * double.parse(_trade.openPrice!)) * 100).toStringAsFixed(2)}%'
      : amount.toStringAsFixed(2);
  Color _color(double value) => value > 0
      ? Colors.red
      : value < 0
          ? Colors.green
          : Colors.grey;

  Future<void> _pickCloseDate() async {
    final start = _trade.tradeDate ?? _trade.createdAt;
    final picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: start,
        lastDate: DateTime.now());
    if (picked == null) return;
    await widget.onCloseDateSaved(picked);
    if (!mounted) return;
    setState(() => _trade = _trade.copyWith(closeDate: Value(picked)));
    _load();
  }

  Widget _buildChart(TradeProfitSeries series, ThemeData theme) {
    final values = series.points
        .map((p) => _rateMode ? p.yieldRate * 100 : p.profit)
        .toList();
    var minValue = values.reduce(math.min);
    var maxValue = values.reduce(math.max);
    final padding =
        math.max((maxValue - minValue) * .12, _rateMode ? 1.0 : 1.0);
    minValue -= padding;
    maxValue += padding;
    final spots = [
      for (var i = 0; i < values.length; i++) FlSpot(i.toDouble(), values[i])
    ];
    return LineChart(LineChartData(
      minX: 0,
      maxX: math.max(1, values.length - 1).toDouble(),
      minY: minValue,
      maxY: maxValue,
      gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => FlLine(
              color: theme.dividerColor.withValues(alpha: .45),
              strokeWidth: .6)),
      borderData: FlBorderData(show: false),
      extraLinesData: ExtraLinesData(horizontalLines: [
        HorizontalLine(
            y: 0,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .5),
            strokeWidth: .8),
      ]),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(),
        rightTitles: const AxisTitles(),
        leftTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
                interval: (maxValue - minValue) / 4,
                getTitlesWidget: (value, _) => Text(_axisValue(value),
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant)))),
        bottomTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, _) {
                  if (value == 0) {
                    return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                            DateFormat('yyyy-MM-dd')
                                .format(series.points.first.date),
                            style: theme.textTheme.bodySmall));
                  }
                  if (value == values.length - 1) {
                    return Transform.translate(
                        offset: const Offset(-32, 8),
                        child: Text(
                            DateFormat('yyyy-MM-dd')
                                .format(series.points.last.date),
                            style: theme.textTheme.bodySmall));
                  }
                  return const SizedBox.shrink();
                })),
      ),
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        touchCallback: (event, response) {
          if (event is FlPointerExitEvent ||
              event is FlPanEndEvent ||
              event is FlLongPressEnd ||
              event is FlTapUpEvent) return;
          final spot = response?.lineBarSpots?.firstOrNull;
          if (spot != null)
            setState(() =>
                _selectedIndex = spot.x.round().clamp(0, values.length - 1));
        },
        getTouchedSpotIndicator: (_, indexes) => indexes
            .map((_) => TouchedSpotIndicatorData(
                FlLine(
                    color: theme.colorScheme.onSurfaceVariant, strokeWidth: .7),
                FlDotData(
                    show: true,
                    getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                        radius: 4,
                        color: theme.colorScheme.surface,
                        strokeWidth: 2,
                        strokeColor: Colors.red))))
            .toList(),
        touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (spots) => spots
                .map((spot) => LineTooltipItem(_axisValue(spot.y),
                    TextStyle(color: theme.colorScheme.onInverseSurface)))
                .toList()),
      ),
      lineBarsData: [
        LineChartBarData(
            spots: spots,
            isCurved: false,
            barWidth: 2,
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: const [
                  Colors.green,
                  Colors.green,
                  Colors.red,
                  Colors.red
                ],
                stops: [
                  0,
                  ((0 - minValue) / (maxValue - minValue)).clamp(0.0, 1.0),
                  ((0 - minValue) / (maxValue - minValue)).clamp(0.0, 1.0),
                  1,
                ]),
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
                show: true,
                cutOffY: 0,
                applyCutOffY: true,
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.red.withValues(alpha: .18),
                      Colors.red.withValues(alpha: .01)
                    ])),
            aboveBarData: BarAreaData(
                show: true,
                cutOffY: 0,
                applyCutOffY: true,
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.green.withValues(alpha: .18),
                      Colors.green.withValues(alpha: .01)
                    ])))
      ],
    ));
  }

  String _axisValue(double value) => _rateMode
      ? '${value.toStringAsFixed(1)}%'
      : value.toStringAsFixed(value.abs() < 10 ? 1 : 0);
}
