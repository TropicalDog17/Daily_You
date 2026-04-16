import 'package:daily_you/config_provider.dart';
import 'package:daily_you/time_manager.dart';
import 'package:daily_you/widgets/mood_icon.dart';
import 'package:daily_you/widgets/stat_chart_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoodByDayChart extends StatelessWidget {
  final Map<String, double> averageMood;

  const MoodByDayChart({super.key, required this.averageMood});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return StatChartCard(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 10),
      child: AspectRatio(
        aspectRatio: 1.9,
        child: BarChart(
          BarChartData(
            groupsSpace: 12,
            alignment: BarChartAlignment.spaceAround,
            maxY: 2,
            minY: -2,
            baselineY: 0,
            barGroups: _getBarGroups(context),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  interval: 1,
                  showTitles: true,
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
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 36,
                  getTitlesWidget: (double value, _) {
                    return SizedBox(
                      width: 36,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(_getDayLabel(context, value.toInt())),
                        ),
                      ),
                    );
                  },
                ),
              ),
              rightTitles: const AxisTitles(),
              topTitles: const AxisTitles(),
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              horizontalInterval: 1,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) => FlLine(
                color: colorScheme.onSurface.withValues(alpha: 0.1),
                strokeWidth: value == 0 ? 1.4 : 1,
              ),
            ),
            barTouchData: BarTouchData(enabled: false),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final orderedDays = _getOrderedDays(context);

    return orderedDays.asMap().entries.map((entry) {
      final index = entry.key;
      final mood = entry.value.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                colorScheme.primary.withValues(alpha: 0.72),
                colorScheme.secondary,
              ],
            ),
            width: 18,
            fromY: -2,
            toY: mood,
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(8),
              bottom: mood < 0 ? const Radius.circular(8) : Radius.zero,
            ),
          ),
        ],
      );
    }).toList();
  }

  List<MapEntry<String, double>> _getOrderedDays(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context);
    List<MapEntry<String, double>> days = averageMood.entries.toList();
    final startingDayIndex = configProvider.getFirstDayOfWeekIndex(context);
    days = days.sublist(startingDayIndex)
      ..addAll(days.sublist(0, startingDayIndex));
    return days;
  }

  String _getDayLabel(BuildContext context, int index) {
    var days = TimeManager.daysOfWeekLabels(context);

    final startingDayIndex =
        ConfigProvider.instance.getFirstDayOfWeekIndex(context);
    days = days.sublist(startingDayIndex)
      ..addAll(days.sublist(0, startingDayIndex));

    return days[index];
  }
}
