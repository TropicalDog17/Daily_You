import 'package:daily_you/models/entry.dart';
import 'package:daily_you/pages/year_in_review_page.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:daily_you/widgets/mood_by_day_chart.dart';
import 'package:daily_you/widgets/mood_by_month_chart.dart';
import 'package:daily_you/widgets/mood_totals_chart.dart';
import 'package:daily_you/widgets/stat_range_selector.dart';
import 'package:daily_you/widgets/streak_card.dart';
import 'package:flutter/material.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage>
    with AutomaticKeepAliveClientMixin {
  StatsRange statsRange = StatsRange.month;
  List<Entry> entriesInRange = List.empty();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 12),
      child: buildEntries(context),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: isIOS ? 18 : 17,
          fontWeight: isIOS ? FontWeight.w700 : FontWeight.w600,
          letterSpacing: isIOS ? -0.2 : 0,
        ),
      ),
    );
  }

  Widget buildEntries(BuildContext context) {
    final entriesProvider = Provider.of<EntriesProvider>(context);
    entriesInRange = entriesProvider.getEntriesInRange(statsRange);
    var (currentStreak, longestStreak, daysSinceBadDay) =
        entriesProvider.getStreaks();
    final uniqueDays = entriesProvider.entries
        .map((entry) => DateTime(entry.timeCreate.year, entry.timeCreate.month,
            entry.timeCreate.day))
        .toSet()
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Card.filled(
            child: ListTile(
              leading: const Icon(Icons.auto_awesome_motion_rounded),
              title: Text(AppLocalizations.of(context)!.yearInReviewTitle),
              subtitle:
                  Text(AppLocalizations.of(context)!.yearInReviewCardSubtitle),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    allowSnapshotting: false,
                    builder: (context) => const YearInReviewPage(),
                  ),
                );
              },
            ),
          ),
        ),
        if (uniqueDays < 7)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Card.filled(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  AppLocalizations.of(context)!.statsUnlockAfterWeek,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ),
            ),
          ),
        const MoodByMonthChart(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Wrap(
            children: [
              StreakCard(
                title:
                    AppLocalizations.of(context)!.streakCurrent(currentStreak),
                isVisible: currentStreak > 0,
                icon: Icons.bolt,
              ),
              StreakCard(
                  title: AppLocalizations.of(context)!
                      .streakLongest(longestStreak),
                  isVisible: longestStreak > currentStreak,
                  icon: Icons.history_rounded),
              StreakCard(
                  title: AppLocalizations.of(context)!
                      .streakSinceBadDay(daysSinceBadDay ?? 0),
                  isVisible: daysSinceBadDay != null && daysSinceBadDay > 3,
                  icon: Icons.timeline_rounded),
              StreakCard(
                title: AppLocalizations.of(context)!
                    .logCount(entriesProvider.entries.length),
                isVisible: entriesProvider.entries.isNotEmpty,
                icon: Icons.description_outlined,
              ),
              StreakCard(
                title: AppLocalizations.of(context)!
                    .wordCount(entriesProvider.wordCount),
                isVisible: entriesProvider.wordCount > 100,
                icon: Icons.sort_rounded,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: StatsRangeSelector(
              statsRange: statsRange,
              onSelectionChanged: (newSelection) {
                setState(() {
                  statsRange = newSelection;
                });
              },
            ),
          ),
        ),
        Center(
          child: _sectionTitle(
            context,
            AppLocalizations.of(context)!
                .chartSummaryTitle(AppLocalizations.of(context)!.tagMoodTitle),
          ),
        ),
        MoodTotalsChart(
          moodCounts: getMoodTotals(entriesInRange),
        ),
        Center(
          child: _sectionTitle(
            context,
            AppLocalizations.of(context)!
                .chartByDayTitle(AppLocalizations.of(context)!.tagMoodTitle),
          ),
        ),
        MoodByDayChart(
          averageMood: getMoodsByDay(entriesInRange),
        ),
      ],
    );
  }

  Map<int, int> getMoodTotals(List<Entry> entriesInRange) {
    Map<int, int> moodTotals = {
      -2: 0,
      -1: 0,
      0: 0,
      1: 0,
      2: 0,
    };

    for (Entry entry in entriesInRange) {
      if (entry.mood == null) continue;
      moodTotals.update(
        entry.mood!,
        (value) => value + 1,
      );
    }

    return moodTotals;
  }

  Map<String, double> getMoodsByDay(List<Entry> entriesInRange) {
    Map<String, List<double>> moodsByDay = {};

    for (Entry entry in entriesInRange) {
      if (entry.mood == null) continue;
      String dayKey = DateFormat('EEE').format(entry.timeCreate);

      if (moodsByDay[dayKey] == null) {
        moodsByDay[dayKey] = List.empty(growable: true);
        moodsByDay[dayKey]!.add(entry.mood!.toDouble());
      } else {
        moodsByDay[dayKey]!.add(entry.mood!.toDouble());
      }
    }

    // Average the mood for each day
    for (var key in moodsByDay.keys) {
      moodsByDay[key]!.first =
          moodsByDay[key]!.reduce((a, b) => a + b) / moodsByDay[key]!.length;
    }

    Map<String, double> averageMoodsByDay = {
      'Mon': -2,
      'Tue': -2,
      'Wed': -2,
      'Thu': -2,
      'Fri': -2,
      'Sat': -2,
      'Sun': -2,
    };

    for (String key in moodsByDay.keys) {
      if (moodsByDay[key] == null) {
        averageMoodsByDay[key] = -2;
      } else {
        averageMoodsByDay[key] = moodsByDay[key]!.first;
      }
    }

    return averageMoodsByDay;
  }
}
