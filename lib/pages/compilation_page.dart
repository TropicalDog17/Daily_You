import 'dart:io';

import 'package:daily_you/compilation_service.dart';
import 'package:daily_you/file_layer.dart';
import 'package:flutter/material.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:path/path.dart' show basename;
import 'package:share_plus/share_plus.dart';

enum CompilationRange { week, month, year, custom }

class CompilationPage extends StatefulWidget {
  const CompilationPage({super.key});

  @override
  State<CompilationPage> createState() => _CompilationPageState();
}

class _CompilationPageState extends State<CompilationPage> {
  CompilationRange _range = CompilationRange.week;
  DateTimeRange? _customRange;
  bool _generating = false;
  String? _outputPath;
  String? _status;

  DateTimeRange _resolveRange() {
    final now = DateTime.now();
    return switch (_range) {
      CompilationRange.week => DateTimeRange(
          start: now.subtract(const Duration(days: 7)),
          end: now,
        ),
      CompilationRange.month => DateTimeRange(
          start: now.subtract(const Duration(days: 30)),
          end: now,
        ),
      CompilationRange.year => DateTimeRange(
          start: now.subtract(const Duration(days: 365)),
          end: now,
        ),
      CompilationRange.custom => _customRange ??
          DateTimeRange(
            start: now.subtract(const Duration(days: 30)),
            end: now,
          ),
    };
  }

  Future<void> _pickCustomRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: now,
      initialDateRange: _customRange ??
          DateTimeRange(
              start: now.subtract(const Duration(days: 30)), end: now),
    );
    if (picked != null && mounted) {
      setState(() {
        _customRange = picked;
      });
    }
  }

  Future<void> _generate() async {
    final range = _resolveRange();
    setState(() {
      _generating = true;
      _status = "Generating compilation...";
      _outputPath = null;
    });

    final output = await CompilationService.instance.generateCompilation(
      start: range.start,
      end: range.end,
    );
    if (!mounted) return;
    setState(() {
      _outputPath = output;
      _generating = false;
      _status = output == null
          ? "No output generated. Add media entries in this range and try again."
          : "Compilation ready.";
    });
  }

  Future<void> _shareOutput() async {
    if (_outputPath == null) return;
    await Share.shareXFiles([XFile(_outputPath!)]);
  }

  Future<void> _saveOutput() async {
    if (_outputPath == null) return;
    final pickedDir = await FileLayer.pickDirectory();
    if (pickedDir == null) return;
    final file = File(_outputPath!);
    final bytes = await file.readAsBytes();
    final newPath = await FileLayer.createFile(
      pickedDir,
      basename(_outputPath!),
      bytes,
    );
    if (newPath != null && Platform.isAndroid) {
      MediaScanner.loadMedia(path: newPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final range = _resolveRange();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Compilation"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Generate a 1SE-style montage from your selected date range.",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          SegmentedButton<CompilationRange>(
            segments: const [
              ButtonSegment(
                value: CompilationRange.week,
                label: Text("Week"),
              ),
              ButtonSegment(
                value: CompilationRange.month,
                label: Text("Month"),
              ),
              ButtonSegment(
                value: CompilationRange.year,
                label: Text("Year"),
              ),
              ButtonSegment(
                value: CompilationRange.custom,
                label: Text("Custom"),
              ),
            ],
            selected: {_range},
            onSelectionChanged: (selection) async {
              final selected = selection.first;
              setState(() {
                _range = selected;
              });
              if (selected == CompilationRange.custom) {
                await _pickCustomRange();
              }
            },
          ),
          const SizedBox(height: 12),
          Text(
            "Range: ${range.start.toLocal().toIso8601String().split('T').first} to ${range.end.toLocal().toIso8601String().split('T').first}",
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _generating ? null : _generate,
            icon: _generating
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.movie_creation_rounded),
            label: Text(_generating ? "Generating..." : "Generate Compilation"),
          ),
          const SizedBox(height: 12),
          if (_status != null) Text(_status!),
          if (_outputPath != null) ...[
            const SizedBox(height: 12),
            Text("Output: $_outputPath"),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: _shareOutput,
                  icon: const Icon(Icons.share_rounded),
                  label: const Text("Share"),
                ),
                OutlinedButton.icon(
                  onPressed: _saveOutput,
                  icon: const Icon(Icons.download_rounded),
                  label: const Text("Save"),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
