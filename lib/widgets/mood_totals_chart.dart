import 'package:daily_you/widgets/mood_icon.dart';
import 'package:daily_you/widgets/stat_chart_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MoodTotalsChart extends StatefulWidget {
  final Map<int, int> moodCounts;

  static final moodToIndexMapping = {
    -2: 0,
    -1: 1,
    0: 2,
    1: 3,
    2: 4,
  };

  static final indexToMoodValueMapping = Map.fromEntries(moodToIndexMapping
      .entries
      .map((entry) => MapEntry(entry.value, entry.key)));

  const MoodTotalsChart({super.key, required this.moodCounts});

  @override
  State<MoodTotalsChart> createState() => _MoodTotalsChartState();
}

class _MoodTotalsChartState extends State<MoodTotalsChart> {
  int touchedGroupIndex = -1;

  BarChartGroupData generateBarGroup(
    int x,
    Color color,
    double value,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          color: color,
          width: 18,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
      ],
      showingTooltipIndicators: touchedGroupIndex == x ? [0] : [],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return StatChartCard(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 10),
      child: AspectRatio(
        aspectRatio: 1.9,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              show: true,
              leftTitles: const AxisTitles(
                drawBelowEverything: true,
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 36,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: _MoodLabelIconWidget(
                        isSelected: touchedGroupIndex == index,
                        mood: MoodTotalsChart.indexToMoodValueMapping[index]!,
                      ),
                    );
                  },
                ),
              ),
              rightTitles: const AxisTitles(),
              topTitles: const AxisTitles(),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 1,
              getDrawingHorizontalLine: (value) => FlLine(
                color: colorScheme.onSurface.withValues(alpha: 0.1),
                strokeWidth: value == 0 ? 1.4 : 1,
              ),
            ),
            barGroups: widget.moodCounts.entries.map((e) {
              final mood = e.key;
              final data = e.value;
              return generateBarGroup(
                MoodTotalsChart.moodToIndexMapping[mood]!,
                _moodColor(colorScheme, mood),
                data.toDouble(),
              );
            }).toList(),
            barTouchData: BarTouchData(
              enabled: true,
              handleBuiltInTouches: false,
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: colorScheme.surface,
                tooltipPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                tooltipMargin: 8,
                getTooltipItem: (
                  BarChartGroupData group,
                  int groupIndex,
                  BarChartRodData rod,
                  int rodIndex,
                ) {
                  return BarTooltipItem(
                    rod.toY.toInt().toString(),
                    TextStyle(
                      fontWeight: FontWeight.w700,
                      color: rod.color ?? colorScheme.primary,
                      fontSize: 15,
                    ),
                  );
                },
              ),
              touchCallback: (event, response) {
                if (event.isInterestedForInteractions &&
                    response != null &&
                    response.spot != null) {
                  setState(() {
                    touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                  });
                } else {
                  setState(() {
                    touchedGroupIndex = -1;
                  });
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Color _moodColor(ColorScheme colorScheme, int mood) {
    switch (mood) {
      case -2:
        return colorScheme.error;
      case -1:
        return Color.alphaBlend(
          colorScheme.error.withValues(alpha: 0.18),
          colorScheme.primary,
        );
      case 0:
        return colorScheme.tertiary;
      case 1:
        return colorScheme.primary;
      case 2:
        return colorScheme.secondary;
      default:
        return colorScheme.primary;
    }
  }
}

class _MoodLabelIconWidget extends ImplicitlyAnimatedWidget {
  const _MoodLabelIconWidget({
    required this.isSelected,
    required this.mood,
  }) : super(duration: const Duration(milliseconds: 100));
  final bool isSelected;
  final int mood;

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _IconWidgetState();
}

class _IconWidgetState extends AnimatedWidgetBaseState<_MoodLabelIconWidget> {
  Tween<double>? _scaleTween;

  @override
  Widget build(BuildContext context) {
    final scale = 1 + _scaleTween!.evaluate(animation) * 0.5;
    return Transform(
      transform: Matrix4.rotationZ(0).scaledByDouble(scale, scale, 1, 1),
      origin: const Offset(14, 14),
      child: MoodIcon(moodValue: widget.mood),
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _scaleTween = visitor(
      _scaleTween,
      widget.isSelected ? 1.0 : 0.0,
      (dynamic value) => Tween<double>(
        begin: value as double,
        end: widget.isSelected ? 1.0 : 0.0,
      ),
    ) as Tween<double>?;
  }
}
