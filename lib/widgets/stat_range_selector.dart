import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';

enum StatsRange { month, sixMonths, year, allTime }

class StatsRangeSelector extends StatefulWidget {
  final StatsRange statsRange;
  final Function(StatsRange newSelection) onSelectionChanged;
  const StatsRangeSelector(
      {super.key, required this.statsRange, required this.onSelectionChanged});

  @override
  State<StatsRangeSelector> createState() => _StatsRangeSelectorState();
}

class _StatsRangeSelectorState extends State<StatsRangeSelector> {
  late StatsRange statsRange;

  bool get _isIOS => Theme.of(context).platform == TargetPlatform.iOS;

  @override
  void initState() {
    super.initState();
    statsRange = widget.statsRange;
  }

  @override
  void didUpdateWidget(covariant StatsRangeSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.statsRange != widget.statsRange) {
      statsRange = widget.statsRange;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isIOS) {
      return CupertinoSlidingSegmentedControl<StatsRange>(
        groupValue: statsRange,
        thumbColor:
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        children: <StatsRange, Widget>{
          StatsRange.month: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Text(AppLocalizations.of(context)!.statisticsRangeOneMonth),
          ),
          StatsRange.sixMonths: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Text(AppLocalizations.of(context)!.statisticsRangeSixMonths),
          ),
          StatsRange.year: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Text(AppLocalizations.of(context)!.statisticsRangeOneYear),
          ),
          StatsRange.allTime: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Text(AppLocalizations.of(context)!.statisticsRangeAllTime),
          ),
        },
        onValueChanged: (StatsRange? newSelection) {
          if (newSelection == null) {
            return;
          }
          setState(() {
            statsRange = newSelection;
          });
          widget.onSelectionChanged(newSelection);
        },
      );
    }

    return SegmentedButton<StatsRange>(
      showSelectedIcon: false,
      segments: <ButtonSegment<StatsRange>>[
        ButtonSegment<StatsRange>(
          value: StatsRange.month,
          label: Text(AppLocalizations.of(context)!.statisticsRangeOneMonth),
        ),
        ButtonSegment<StatsRange>(
          value: StatsRange.sixMonths,
          label: Text(AppLocalizations.of(context)!.statisticsRangeSixMonths),
        ),
        ButtonSegment<StatsRange>(
          value: StatsRange.year,
          label: Text(AppLocalizations.of(context)!.statisticsRangeOneYear),
        ),
        ButtonSegment<StatsRange>(
          value: StatsRange.allTime,
          label: Text(AppLocalizations.of(context)!.statisticsRangeAllTime),
        ),
      ],
      selected: <StatsRange>{statsRange},
      onSelectionChanged: (Set<StatsRange> newSelection) {
        setState(() {
          statsRange = newSelection.first;
        });
        widget.onSelectionChanged(newSelection.first);
      },
    );
  }
}
