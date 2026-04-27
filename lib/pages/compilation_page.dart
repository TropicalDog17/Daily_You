import 'dart:io';

import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/models/image.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:daily_you/providers/entry_images_provider.dart';
import 'package:daily_you/services/compilation_service.dart';
import 'package:daily_you/time_manager.dart';
import 'package:daily_you/widgets/local_image_loader.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

enum CompilationRangePreset { week, month, year, custom }

class CompilationPage extends StatefulWidget {
  const CompilationPage({super.key});

  @override
  State<CompilationPage> createState() => _CompilationPageState();
}

class _CompilationPageState extends State<CompilationPage> {
  CompilationRangePreset _rangePreset = CompilationRangePreset.month;
  DateTimeRange? _customRange;
  double _clipDuration = 1.0;
  final Map<int, bool> _included = {};

  bool _isGenerating = false;
  double _progress = 0;
  String _progressText = '';

  String? _resultPath;
  VideoPlayerController? _previewController;

  @override
  void dispose() {
    _previewController?.dispose();
    super.dispose();
  }

  Future<void> _pickCustomRange() async {
    final now = DateTime.now();
    final initial = _customRange ??
        DateTimeRange(
          start: DateTime(now.year, now.month, now.day)
              .subtract(const Duration(days: 30)),
          end: DateTime(now.year, now.month, now.day),
        );
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.utc(2000),
      lastDate: DateTime.now(),
      initialDateRange: initial,
    );
    if (picked != null) {
      setState(() {
        _rangePreset = CompilationRangePreset.custom;
        _customRange = picked;
        _syncIncludedMap();
      });
    }
  }

  DateTimeRange _activeRange() {
    final now = DateTime.now();
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    switch (_rangePreset) {
      case CompilationRangePreset.week:
        return DateTimeRange(
            start: end.subtract(const Duration(days: 6)), end: end);
      case CompilationRangePreset.month:
        return DateTimeRange(start: DateTime(now.year, now.month, 1), end: end);
      case CompilationRangePreset.year:
        return DateTimeRange(start: DateTime(now.year, 1, 1), end: end);
      case CompilationRangePreset.custom:
        return _customRange ??
            DateTimeRange(start: DateTime(now.year, now.month, 1), end: end);
    }
  }

  List<(Entry, EntryImage)> _candidateEntries() {
    final entriesProvider =
        Provider.of<EntriesProvider>(context, listen: false);
    final imagesProvider =
        Provider.of<EntryImagesProvider>(context, listen: false);

    final range = _activeRange();
    final list = <(Entry, EntryImage)>[];
    for (final entry in entriesProvider.entries) {
      final date = entry.timeCreate;
      if (date.isBefore(range.start) || date.isAfter(range.end)) continue;
      final media = imagesProvider.getForEntry(entry).firstOrNull;
      if (media == null) continue;
      list.add((entry, media));
    }
    list.sort((a, b) => a.$1.timeCreate.compareTo(b.$1.timeCreate));
    return list;
  }

  void _syncIncludedMap() {
    final candidates = _candidateEntries();
    final validIds = candidates.map((item) => item.$1.id!).toSet();

    _included.removeWhere((key, _) => !validIds.contains(key));
    for (final item in candidates) {
      final id = item.$1.id!;
      _included.putIfAbsent(id, () => true);
    }
  }

  Future<void> _generate() async {
    final l10n = AppLocalizations.of(context)!;
    final candidates = _candidateEntries();
    final selected = candidates
        .where((item) => _included[item.$1.id!] ?? true)
        .map((item) => CompilationClip(entry: item.$1, media: item.$2))
        .toList();

    if (selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.compilationSelectAtLeastOneEntry)),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
      _progress = 0;
      _progressText = l10n.compilationProgressPreparing;
    });

    try {
      final resultPath = await CompilationService.instance.generateCompilation(
        clips: selected,
        clipDurationSeconds: _clipDuration,
        onProgress: (p) {
          if (!mounted) return;
          setState(() {
            _progress = p.fraction;
            _progressText = _progressLabel(l10n, p);
          });
        },
      );

      await _previewController?.dispose();
      final controller = VideoPlayerController.file(File(resultPath));
      await controller.initialize();
      await controller.setLooping(true);

      if (!mounted) return;
      setState(() {
        _resultPath = resultPath;
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
      text: l10n.compilationShareText,
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

  Future<void> _discardResult() async {
    final path = _resultPath;
    if (path == null) return;
    await _previewController?.pause();
    await _previewController?.dispose();
    if (await File(path).exists()) {
      await File(path).delete();
    }
    if (!mounted) return;
    setState(() {
      _resultPath = null;
      _previewController = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final candidates = _candidateEntries();
    _syncIncludedMap();

    final selectedCount =
        candidates.where((item) => _included[item.$1.id!] ?? true).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.compilationTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _buildRangePicker(context),
          const SizedBox(height: 8),
          Card.filled(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.compilationClipDurationTitle,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Slider(
                    value: _clipDuration,
                    min: 0.5,
                    max: 3,
                    divisions: 10,
                    label: '${_clipDuration.toStringAsFixed(1)}s',
                    onChanged: (value) {
                      setState(() {
                        _clipDuration = value;
                      });
                    },
                  ),
                  Text(l10n.compilationSelectedClipCount(selectedCount)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card.filled(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.compilationIncludedEntriesTitle,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  if (candidates.isEmpty)
                    Text(l10n.compilationNoEntriesInRange)
                  else
                    ...candidates.map((item) {
                      final entry = item.$1;
                      final media = item.$2;
                      final id = entry.id!;
                      return CheckboxListTile(
                        value: _included[id] ?? true,
                        onChanged: (value) {
                          setState(() {
                            _included[id] = value ?? true;
                          });
                        },
                        secondary: SizedBox(
                          width: 40,
                          height: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                LocalImageLoader(imagePath: media.imgPath),
                                if (media.isVideo)
                                  const Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.play_circle_fill_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                if (media.isLivePhoto)
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(
                                            alpha: 0.45,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Icon(
                                            media.rendersMotion
                                                ? Icons.motion_photos_on_rounded
                                                : Icons
                                                    .motion_photos_off_rounded,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        title: Text(
                          DateFormat.yMMMd(TimeManager.currentLocale(context))
                              .format(entry.timeCreate),
                        ),
                        subtitle: Text(
                          entry.text.isEmpty
                              ? l10n.compilationNoTextFallback
                              : entry.text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        contentPadding: EdgeInsets.zero,
                      );
                    }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: _isGenerating ? null : _generate,
            icon: const Icon(Icons.movie_creation_rounded),
            label: Text(l10n.compilationGenerateAction),
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
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _discardResult,
                    icon: const Icon(Icons.delete_outline_rounded),
                    label: Text(l10n.compilationDiscardAction),
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

  Widget _buildRangePicker(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = TimeManager.currentLocale(context);
    final range = _activeRange();

    return Card.filled(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.compilationRangeTitle,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: Text(l10n.compilationRangeWeek),
                  selected: _rangePreset == CompilationRangePreset.week,
                  onSelected: (_) {
                    setState(() {
                      _rangePreset = CompilationRangePreset.week;
                    });
                  },
                ),
                ChoiceChip(
                  label: Text(l10n.compilationRangeMonth),
                  selected: _rangePreset == CompilationRangePreset.month,
                  onSelected: (_) {
                    setState(() {
                      _rangePreset = CompilationRangePreset.month;
                    });
                  },
                ),
                ChoiceChip(
                  label: Text(l10n.compilationRangeYear),
                  selected: _rangePreset == CompilationRangePreset.year,
                  onSelected: (_) {
                    setState(() {
                      _rangePreset = CompilationRangePreset.year;
                    });
                  },
                ),
                ChoiceChip(
                  label: Text(l10n.compilationRangeCustom),
                  selected: _rangePreset == CompilationRangePreset.custom,
                  onSelected: (_) => _pickCustomRange(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.compilationRangeValue(
                DateFormat.yMMMd(locale).format(range.start),
                DateFormat.yMMMd(locale).format(range.end),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
