import 'dart:math';

import 'package:daily_you/models/entry.dart';
import 'package:daily_you/models/image.dart';

class YearInReviewService {
  static final YearInReviewService instance = YearInReviewService._init();

  YearInReviewService._init();

  List<Entry> selectEntries({
    required int year,
    required List<Entry> entries,
    required Map<int, List<EntryImage>> mediaByEntry,
    int minCount = 30,
    int maxCount = 60,
  }) {
    final yearEntries = entries.where((e) => e.timeCreate.year == year).toList()
      ..sort((a, b) => a.timeCreate.compareTo(b.timeCreate));
    if (yearEntries.isEmpty) return [];

    final targetCount = min(maxCount, max(minCount, yearEntries.length));
    final selected = <Entry>[];
    final selectedIds = <int>{};
    final random = Random(year);

    final entriesByMonth = <int, List<Entry>>{};
    for (final entry in yearEntries) {
      entriesByMonth.putIfAbsent(entry.timeCreate.month, () => []).add(entry);
    }

    for (var month = 1; month <= 12; month++) {
      final monthEntries = entriesByMonth[month] ?? const <Entry>[];
      if (monthEntries.isEmpty) continue;
      final picked = _pickWeighted(monthEntries, mediaByEntry, random);
      if (picked.id != null && !selectedIds.contains(picked.id)) {
        selected.add(picked);
        selectedIds.add(picked.id!);
      }
    }

    final pool = yearEntries
        .where((entry) => entry.id == null || !selectedIds.contains(entry.id))
        .toList();

    while (selected.length < targetCount && pool.isNotEmpty) {
      final picked = _pickWeighted(pool, mediaByEntry, random);
      pool.removeWhere((entry) => entry.id == picked.id);
      if (picked.id == null || selectedIds.contains(picked.id)) {
        continue;
      }
      selected.add(picked);
      selectedIds.add(picked.id!);
    }

    selected.sort((a, b) => a.timeCreate.compareTo(b.timeCreate));
    return selected;
  }

  Entry _pickWeighted(
    List<Entry> entries,
    Map<int, List<EntryImage>> mediaByEntry,
    Random random,
  ) {
    final scored = entries.map((entry) {
      final media = mediaByEntry[entry.id] ?? const <EntryImage>[];
      final hasMedia = media.isNotEmpty;
      final mood = entry.mood ?? 0;
      final moodWeight = switch (mood) {
        2 => 28,
        1 => 18,
        0 => 10,
        -1 => 6,
        -2 => 3,
        _ => 8,
      };
      final mediaWeight = hasMedia ? 30 : 4;
      final textWeight = min(24, max(0, entry.text.length ~/ 16));
      final score = mediaWeight + moodWeight + textWeight + random.nextInt(12);
      return (entry: entry, score: score);
    }).toList();

    final totalScore = scored.fold<int>(0, (sum, item) => sum + item.score);
    var roll = random.nextInt(max(1, totalScore));

    for (final candidate in scored) {
      roll -= candidate.score;
      if (roll < 0) {
        return candidate.entry;
      }
    }

    return scored.first.entry;
  }
}
