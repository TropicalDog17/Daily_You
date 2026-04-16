import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:daily_you/time_manager.dart';
import 'package:daily_you/widgets/mood_icon.dart';
import 'package:daily_you/widgets/stat_chart_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MoodByMonthChart extends StatefulWidget {
  const MoodByMonthChart({super.key});

  @override
  State<MoodByMonthChart> createState() => _MoodByMonthChartState();
}

class _MoodByMonthChartState extends State<MoodByMonthChart> {
  Map<String, double?> averageMood = {};
  late List<String> sortedKeys;
  int currentPage = 0;
  int monthsPerPage = 12;
  bool notEnoughData = true;

  @override
  Widget build(BuildContext context) {
    final entriesProvider = Provider.of<EntriesProvider>(context);
    final entries = entriesProvider.entries;
    final moodsByMonth = <String, List<double>>{};

    for (final entry in entries) {
      if (entry.mood == null) continue;
      final monthKey =
          '${entry.timeCreate.year}-${entry.timeCreate.month.toString().padLeft(2, '0')}';
      if (moodsByMonth[monthKey] != null) {
        moodsByMonth[monthKey]!.add(entry.mood!.toDouble());
      } else {
        moodsByMonth[monthKey] = List.empty(growable: true);
        moodsByMonth[monthKey]!.add(entry.mood!.toDouble());
      }
    }

    averageMood.clear();
    for (final month in moodsByMonth.keys) {
      averageMood[month] = moodsByMonth[month]!.reduce((a, b) => a + b) /
          moodsByMonth[month]!.length;
    }

    notEnoughData = averageMood.length < 2;

    sortedKeys = averageMood.keys.toList()..sort();
    final allMonths = _generateCompleteMonthRange(sortedKeys, monthsPerPage);
    sortedKeys = allMonths.toList()..sort();

    int endIndex = (sortedKeys.length - (currentPage * monthsPerPage))
        .clamp(0, sortedKeys.length);
    int startIndex = (endIndex - monthsPerPage).clamp(0, endIndex);
    final currentPageSize = endIndex - startIndex;
    if (currentPageSize < monthsPerPage) {
      endIndex = (endIndex + (monthsPerPage - currentPageSize))
          .clamp(0, sortedKeys.length);
    }

    final currentPageKeys = sortedKeys.sublist(startIndex, endIndex);
    final currentData = {
      for (final key in currentPageKeys) key: averageMood[key]
    };

    return StatChartCard(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      child: notEnoughData
          ? AspectRatio(
              aspectRatio: 1.9,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.chart_bar,
                      size: 54,
                      color: Theme.of(context).disabledColor,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.statisticsNotEnoughData,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                _buildPaginationControls(currentPageKeys, context),
                const SizedBox(height: 8),
                AspectRatio(
                  aspectRatio: 1.9,
                  child: LineChart(
                    _buildLineChartData(
                      Theme.of(context).colorScheme.primary,
                      currentData,
                      currentPageKeys,
                      context,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildPaginationControls(List<String> keys, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_totalPages() > 1)
          IconButton(
            onPressed: currentPage < _totalPages() - 1 ? _goToNextPage : null,
            icon: Icon(
              Theme.of(context).platform == TargetPlatform.iOS
                  ? CupertinoIcons.chevron_left
                  : Icons.arrow_back_ios_new_rounded,
            ),
          ),
        Text(
          '${_formatMonthYear(keys.first, context)} - ${_formatMonthYear(keys.last, context)}',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        if (_totalPages() > 1)
          IconButton(
            onPressed: currentPage > 0 ? _goToPreviousPage : null,
            icon: Icon(
              Theme.of(context).platform == TargetPlatform.iOS
                  ? CupertinoIcons.chevron_right
                  : Icons.arrow_forward_ios_rounded,
            ),
          ),
      ],
    );
  }

  int _totalPages() {
    return (sortedKeys.length / monthsPerPage).ceil();
  }

  void _goToPreviousPage() {
    setState(() {
      currentPage--;
    });
  }

  void _goToNextPage() {
    setState(() {
      currentPage++;
    });
  }

  LineChartData _buildLineChartData(
    Color color,
    Map<String, double?> data,
    List<String> keys,
    BuildContext context,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final spots = keys.asMap().entries.map((entry) {
      final index = entry.key;
      final key = entry.value;
      final mood = data[key];

      return mood != null ? FlSpot(index.toDouble(), mood) : null;
    }).toList();

    return LineChartData(
      minX: 0,
      maxX: keys.length - 1.toDouble(),
      minY: -2,
      maxY: 2,
      clipData: const FlClipData.all(),
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        getTouchedSpotIndicator: (barData, spotIndexes) {
          return spotIndexes.map((index) {
            return TouchedSpotIndicatorData(
              FlLine(
                color: colorScheme.primary.withValues(alpha: 0.18),
                strokeWidth: 1,
              ),
              FlDotData(
                getDotPainter: (spot, percent, bar, i) => FlDotCirclePainter(
                  radius: 5,
                  color: colorScheme.surface,
                  strokeWidth: 2.5,
                  strokeColor: color,
                ),
              ),
            );
          }).toList();
        },
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: colorScheme.surface,
          tooltipPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          getTooltipItems: (spots) {
            return spots.map((spot) {
              return LineTooltipItem(
                _formatMonthYear(keys[spot.x.toInt()], context),
                TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                children: [
                  TextSpan(
                    text: '\n${spot.y.toStringAsFixed(1)}',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              );
            }).toList();
          },
        ),
      ),
      lineBarsData: [
        if (spots.whereType<FlSpot>().toList().isNotEmpty)
          LineChartBarData(
            spots: spots.whereType<FlSpot>().toList(),
            isCurved: true,
            color: color,
            gradient: LinearGradient(
              colors: [
                colorScheme.primary,
                colorScheme.secondary,
              ],
            ),
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (p0, p1, p2, p3) {
                return FlDotCirclePainter(
                  color: color,
                  radius: 4.2,
                  strokeColor: colorScheme.surface,
                  strokeWidth: 2,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.primary.withValues(alpha: 0.22),
                  colorScheme.secondary.withValues(alpha: 0.04),
                ],
              ),
            ),
          ),
      ],
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, _) => SizedBox(
              height: 20,
              width: 26,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Text(
                    _formatMonth(
                      value >= 0 && value < keys.length
                          ? keys[value.toInt()]
                          : '',
                      context,
                    ),
                  ),
                ),
              ),
            ),
            interval: 1,
            reservedSize: 28,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 32,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: MoodIcon(moodValue: index),
              );
            },
          ),
        ),
        topTitles: const AxisTitles(),
        rightTitles: const AxisTitles(),
      ),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        horizontalInterval: 1,
        drawVerticalLine: false,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) => FlLine(
          color: colorScheme.onSurface.withValues(alpha: 0.1),
          strokeWidth: value == 0 ? 1.4 : 1,
        ),
      ),
      borderData: FlBorderData(show: false),
    );
  }

  String _formatMonth(String dateKey, BuildContext context) {
    final date = DateFormat('yyyy-MM').parse(dateKey);
    return DateFormat('MMM', TimeManager.currentLocale(context)).format(date);
  }

  String _formatMonthYear(String dateKey, BuildContext context) {
    final date = DateFormat('yyyy-MM').parse(dateKey);
    return DateFormat('MMM yyyy', TimeManager.currentLocale(context))
        .format(date);
  }

  List<String> _generateCompleteMonthRange(
      Iterable<String> keys, int monthsPerPage) {
    if (keys.isEmpty) {
      return List.empty();
    }

    final parsedDates =
        keys.map((key) => DateFormat('yyyy-MM').parse(key)).toList()..sort();

    final startDate = parsedDates.first;
    var endDate = parsedDates.last;

    final minEndDate = DateTime(
        startDate.year, startDate.month + (monthsPerPage - 1), startDate.day);
    if (endDate.isBefore(minEndDate)) {
      endDate = minEndDate;
    }

    final allMonths = <String>[];
    var current = startDate;

    while (!current.isAfter(endDate)) {
      final monthKey =
          '${current.year}-${current.month.toString().padLeft(2, '0')}';
      allMonths.add(monthKey);
      current = DateTime(current.year, current.month + 1);
    }

    return allMonths;
  }
}
