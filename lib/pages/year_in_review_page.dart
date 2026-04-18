import 'dart:io';

import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/models/image.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:daily_you/providers/entry_images_provider.dart';
import 'package:daily_you/services/compilation_service.dart';
import 'package:daily_you/services/year_in_review_service.dart';
import 'package:daily_you/time_manager.dart';
import 'package:daily_you/widgets/mood_totals_chart.dart';
import 'package:daily_you/widgets/streak_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

class YearInReviewPage extends StatefulWidget {
  const YearInReviewPage({super.key});

  @override
  State<YearInReviewPage> createState() => _YearInReviewPageState();
}

class _YearInReviewPageState extends State<YearInReviewPage> {
  int? _selectedYear;
  bool _isGenerating = false;
  double _progress = 0;
  String _progressText = '';
  String? _resultPath;
  VideoPlayerController? _previewController;
  List<Entry> _selectedEntries = [];

  @override
  void dispose() {
    _previewController?.dispose();
    super.dispose();
  }

  Map<int, List<EntryImage>> _buildMediaByEntry(EntryImagesProvider provider) {
    final map = <int, List<EntryImage>>{};
    for (final image in provider.images) {
      final entryId = image.entryId;
      if (entryId == null) continue;
      map.putIfAbsent(entryId, () => []).add(image);
    }
    for (final list in map.values) {
      list.sort((a, b) => b.imgRank.compareTo(a.imgRank));
    }
    return map;
  }

  Future<void> _generate() async {
    final l10n = AppLocalizations.of(context)!;
    final year = _selectedYear;
    if (year == null) return;

    final entriesProvider =
        Provider.of<EntriesProvider>(context, listen: false);
    final imagesProvider =
        Provider.of<EntryImagesProvider>(context, listen: false);
    final mediaByEntry = _buildMediaByEntry(imagesProvider);

    final selected = YearInReviewService.instance.selectEntries(
      year: year,
      entries: entriesProvider.entries,
      mediaByEntry: mediaByEntry,
    );

    final clips = selected
        .map((entry) {
          final media = mediaByEntry[entry.id]?.firstOrNull;
          if (media == null) return null;
          return CompilationClip(entry: entry, media: media);
        })
        .whereType<CompilationClip>()
        .toList();

    if (clips.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.yearInReviewNoMediaEntries)),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
      _progress = 0;
      _progressText = l10n.compilationProgressPreparing;
      _selectedEntries = selected;
    });

    try {
      final outputPath = await CompilationService.instance.generateCompilation(
        clips: clips,
        clipDurationSeconds: 1.0,
        onProgress: (p) {
          if (!mounted) return;
          setState(() {
            _progress = p.fraction;
            _progressText = _progressLabel(l10n, p);
          });
        },
      );

      await _previewController?.dispose();
      final controller = VideoPlayerController.file(File(outputPath));
      await controller.initialize();
      await controller.setLooping(true);

      if (!mounted) return;
      setState(() {
        _resultPath = outputPath;
        _previewController = controller;
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.compilationFailed(error.toString()))),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  Future<void> _shareResult() async {
    final l10n = AppLocalizations.of(context)!;
    final path = _resultPath;
    if (path == null) return;
    await Share.shareXFiles(
      [XFile(path, mimeType: 'video/mp4')],
      text: l10n.yearInReviewShareText,
    );
  }

  Future<void> _saveResult() async {
    final l10n = AppLocalizations.of(context)!;
    final path = _resultPath;
    if (path == null) return;
    await MediaScanner.loadMedia(path: path);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.savedToGalleryMessage)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final entriesProvider = Provider.of<EntriesProvider>(context);
    final imagesProvider = Provider.of<EntryImagesProvider>(context);
    final mediaByEntry = _buildMediaByEntry(imagesProvider);
    final allYears = entriesProvider.entries
        .map((entry) => entry.timeCreate.year)
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    final suggestedYear = DateTime.now().year - 1;
    _selectedYear ??= allYears.contains(suggestedYear)
        ? suggestedYear
        : (allYears.isNotEmpty ? allYears.first : null);

    final selectedYear = _selectedYear;
    final yearEntries = selectedYear == null
        ? const <Entry>[]
        : entriesProvider.entries
            .where((entry) => entry.timeCreate.year == selectedYear)
            .toList();
    final mediaEntriesCount = yearEntries
        .where((entry) =>
            (mediaByEntry[entry.id] ?? const <EntryImage>[]).isNotEmpty)
        .length;
    final uniqueDays = _countUniqueDays(yearEntries);
    final (currentStreak, longestStreak) = _calculateYearStreaks(yearEntries);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.yearInReviewTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card.filled(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.yearInReviewSelectYearTitle,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: allYears
                        .map(
                          (year) => ChoiceChip(
                            label: Text('$year'),
                            selected: selectedYear == year,
                            onSelected: (_) {
                              setState(() {
                                _selectedYear = year;
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  if (selectedYear != null) ...[
                    Text(l10n.yearInReviewEntriesCount(yearEntries.length)),
                    Text(l10n
                        .yearInReviewEntriesWithMediaCount(mediaEntriesCount)),
                    Text(
                      l10n.yearInReviewRange(
                        DateFormat.yMMMd(TimeManager.currentLocale(context))
                            .format(DateTime(selectedYear, 1, 1)),
                        DateFormat.yMMMd(TimeManager.currentLocale(context))
                            .format(DateTime(selectedYear, 12, 31)),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (selectedYear != null) ...[
            const SizedBox(height: 8),
            Card.filled(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.yearInReviewSummaryTitle,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(l10n.yearInReviewActiveDaysCount(uniqueDays)),
                    const SizedBox(height: 8),
                    Wrap(
                      children: [
                        StreakCard(
                          title: l10n.streakCurrent(currentStreak),
                          isVisible: currentStreak > 0,
                          icon: Icons.bolt,
                        ),
                        StreakCard(
                          title: l10n.streakLongest(longestStreak),
                          isVisible: longestStreak > 0,
                          icon: Icons.history_rounded,
                        ),
                      ],
                    ),
                    MoodTotalsChart(
                      moodCounts: _buildMoodTotals(yearEntries),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: _isGenerating || selectedYear == null ? null : _generate,
            icon: const Icon(Icons.auto_awesome_motion_rounded),
            label: Text(l10n.yearInReviewGenerateAction),
          ),
          if (_isGenerating)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: _progress.clamp(0.0, 1.0),
                  ),
                  const SizedBox(height: 8),
                  Text(_progressText),
                  Text(
                    l10n.compilationProgressPercent(
                      (_progress.clamp(0.0, 1.0) * 100).round(),
                    ),
                  ),
                ],
              ),
            ),
          if (_selectedEntries.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                l10n.yearInReviewSelectedHighlights(_selectedEntries.length),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          if (_previewController != null && _resultPath != null) ...[
            const SizedBox(height: 12),
            Card.filled(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: _previewController!.value.aspectRatio == 0
                        ? 9 / 16
                        : _previewController!.value.aspectRatio,
                    child: VideoPlayer(_previewController!),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          if (_previewController!.value.isPlaying) {
                            await _previewController!.pause();
                          } else {
                            await _previewController!.play();
                          }
                          if (mounted) setState(() {});
                        },
                        icon: Icon(
                          _previewController!.value.isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                        ),
                      ),
                      Expanded(
                        child: VideoProgressIndicator(
                          _previewController!,
                          allowScrubbing: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _shareResult,
                    icon: const Icon(Icons.share_rounded),
                    label: Text(l10n.compilationShareAction),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _saveResult,
                    icon: const Icon(Icons.download_rounded),
                    label: Text(l10n.compilationSaveAction),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _progressLabel(AppLocalizations l10n, CompilationProgress progress) {
    switch (progress.phase) {
      case CompilationPhase.encodingClip:
        return l10n.compilationProgressEncodingClip(
          progress.clipIndex,
          progress.clipCount,
        );
      case CompilationPhase.renderingFinal:
        return l10n.compilationProgressRenderingFinal;
      case CompilationPhase.completed:
        return l10n.compilationProgressReady;
    }
  }

  Map<int, int> _buildMoodTotals(List<Entry> entries) {
    final moodTotals = <int, int>{
      -2: 0,
      -1: 0,
      0: 0,
      1: 0,
      2: 0,
    };

    for (final entry in entries) {
      if (entry.mood == null) continue;
      moodTotals.update(entry.mood!, (value) => value + 1);
    }

    return moodTotals;
  }

  int _countUniqueDays(List<Entry> entries) {
    return entries
        .map((entry) => DateTime(entry.timeCreate.year, entry.timeCreate.month,
            entry.timeCreate.day))
        .toSet()
        .length;
  }

  (int, int) _calculateYearStreaks(List<Entry> entries) {
    if (entries.isEmpty) return (0, 0);

    final days = entries
        .map((entry) => DateTime(entry.timeCreate.year, entry.timeCreate.month,
            entry.timeCreate.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    if (days.isEmpty) return (0, 0);

    var currentStreak = 1;
    for (var i = 1; i < days.length; i++) {
      final difference = days[i - 1].difference(days[i]).inDays;
      if (difference == 1) {
        currentStreak += 1;
      } else {
        break;
      }
    }

    var longestStreak = 1;
    var running = 1;
    for (var i = 1; i < days.length; i++) {
      final difference = days[i - 1].difference(days[i]).inDays;
      if (difference == 1) {
        running += 1;
      } else {
        running = 1;
      }
      if (running > longestStreak) {
        longestStreak = running;
      }
    }

    return (currentStreak, longestStreak);
  }
}
