import 'dart:async';
import 'dart:io';

import 'package:daily_you/database/image_storage.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/models/image.dart';
import 'package:ffmpeg_kit_flutter_new_min/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new_min/return_code.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CompilationClip {
  const CompilationClip({
    required this.entry,
    required this.media,
  });

  final Entry entry;
  final EntryImage media;
}

enum CompilationPhase {
  encodingClip,
  renderingFinal,
  completed,
}

class CompilationProgress {
  const CompilationProgress({
    required this.current,
    required this.total,
    required this.overallFraction,
    required this.phase,
    this.clipIndex = 0,
    this.clipCount = 0,
  });

  final int current;
  final int total;
  final double overallFraction;
  final CompilationPhase phase;
  final int clipIndex;
  final int clipCount;

  double get fraction => overallFraction.clamp(0.0, 1.0).toDouble();
}

typedef CompilationProgressCallback = void Function(
    CompilationProgress progress);

class CompilationService {
  static final CompilationService instance = CompilationService._init();

  CompilationService._init();

  Future<String> generateCompilation({
    required List<CompilationClip> clips,
    double clipDurationSeconds = 1.0,
    CompilationProgressCallback? onProgress,
  }) async {
    if (clips.isEmpty) {
      throw ArgumentError('No clips selected for compilation');
    }

    final tempRoot = await getTemporaryDirectory();
    final runDirectory = Directory(
      join(tempRoot.path,
          'daily_you_compilation_${DateTime.now().millisecondsSinceEpoch}'),
    );
    await runDirectory.create(recursive: true);

    final segments = <String>[];
    final transitionDurationSeconds = clipDurationSeconds >= 0.6 ? 0.3 : 0.15;
    final totalSteps = clips.length + (clips.length > 1 ? 1 : 0);
    final segmentDurationMs = clipDurationSeconds * 1000;
    final finalRenderDurationSeconds = clips.length <= 1
        ? 0.0
        : (clipDurationSeconds * clips.length) -
            (transitionDurationSeconds * (clips.length - 1));
    final finalRenderDurationMs = finalRenderDurationSeconds > 0
        ? finalRenderDurationSeconds * 1000
        : 0.0;
    final totalWorkMs =
        (segmentDurationMs * clips.length) + finalRenderDurationMs;
    double completedWorkMs = 0;

    try {
      for (var i = 0; i < clips.length; i++) {
        final clip = clips[i];
        final segmentPath = join(
            runDirectory.path, 'segment_${i.toString().padLeft(3, '0')}.mp4');
        await _createSegment(
          media: clip.media,
          outputPath: segmentPath,
          clipDurationSeconds: clipDurationSeconds,
          onProgress: (phaseFraction) {
            final currentWorkMs = completedWorkMs +
                (segmentDurationMs * phaseFraction.clamp(0.0, 1.0).toDouble());
            onProgress?.call(
              CompilationProgress(
                current: i + 1,
                total: totalSteps,
                overallFraction: _fractionFromWork(currentWorkMs, totalWorkMs),
                phase: CompilationPhase.encodingClip,
                clipIndex: i + 1,
                clipCount: clips.length,
              ),
            );
          },
        );
        segments.add(segmentPath);
        completedWorkMs += segmentDurationMs;
      }

      final outputPath = join(
        runDirectory.path,
        'daily_you_compilation_${DateTime.now().millisecondsSinceEpoch}.mp4',
      );

      if (segments.length == 1) {
        await File(segments.first).copy(outputPath);
      } else {
        await _runCommand(
          _buildCrossfadeCommand(
            segments: segments,
            outputPath: outputPath,
            clipDurationSeconds: clipDurationSeconds,
            transitionDurationSeconds: transitionDurationSeconds,
          ),
          expectedDurationMs: finalRenderDurationMs,
          onProgress: (phaseFraction) {
            final currentWorkMs = completedWorkMs +
                (finalRenderDurationMs *
                    phaseFraction.clamp(0.0, 1.0).toDouble());
            onProgress?.call(
              CompilationProgress(
                current: totalSteps,
                total: totalSteps,
                overallFraction: _fractionFromWork(currentWorkMs, totalWorkMs),
                phase: CompilationPhase.renderingFinal,
                clipCount: clips.length,
              ),
            );
          },
        );
        completedWorkMs += finalRenderDurationMs;
      }

      onProgress?.call(
        CompilationProgress(
          current: totalSteps,
          total: totalSteps,
          overallFraction: 1,
          phase: CompilationPhase.completed,
          clipCount: clips.length,
        ),
      );

      for (final segment in segments) {
        final segmentFile = File(segment);
        if (await segmentFile.exists()) {
          await segmentFile.delete();
        }
      }

      return outputPath;
    } catch (_) {
      rethrow;
    }
  }

  String _buildCrossfadeCommand({
    required List<String> segments,
    required String outputPath,
    required double clipDurationSeconds,
    required double transitionDurationSeconds,
  }) {
    final inputs = segments.map((segment) => '-i ${_quote(segment)}').join(' ');

    final filterParts = <String>[];
    final step = clipDurationSeconds - transitionDurationSeconds;
    for (var i = 1; i < segments.length; i++) {
      final offset = step * i;
      final left = i == 1 ? '[0:v]' : '[v${i - 1}]';
      final right = '[$i:v]';
      final out = '[v$i]';
      filterParts.add(
        '$left$right'
        'xfade=transition=fade:duration=$transitionDurationSeconds:offset=${offset.toStringAsFixed(2)}$out',
      );
    }

    final finalMap = '[v${segments.length - 1}]';
    final filterComplex = filterParts.join(';');

    return '-y $inputs -filter_complex "$filterComplex" '
        '-map $finalMap -c:v libx264 -preset veryfast -pix_fmt yuv420p '
        '-movflags +faststart -an ${_quote(outputPath)}';
  }

  Future<void> _createSegment({
    required EntryImage media,
    required String outputPath,
    required double clipDurationSeconds,
    required void Function(double phaseFraction) onProgress,
  }) async {
    final inputName =
        (media.mediaType == 'video' || media.mediaType == 'live_photo')
            ? media.videoPath
            : media.imgPath;
    if (inputName == null) {
      throw StateError('Selected media is missing a source file path');
    }

    final inputPath = await ImageStorage.instance.getFilePath(inputName);
    if (inputPath == null) {
      throw FileSystemException('Unable to resolve media file', inputName);
    }

    final baseFilter =
        'scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2,format=yuv420p';

    if (media.mediaType == 'video' || media.mediaType == 'live_photo') {
      await _runCommand(
        '-y -i ${_quote(inputPath)} -t $clipDurationSeconds '
        '-vf "$baseFilter" -c:v libx264 -preset veryfast -an ${_quote(outputPath)}',
        expectedDurationMs: clipDurationSeconds * 1000,
        onProgress: onProgress,
      );
    } else {
      await _runCommand(
        '-y -loop 1 -i ${_quote(inputPath)} -t $clipDurationSeconds '
        '-vf "$baseFilter" -c:v libx264 -preset veryfast -an ${_quote(outputPath)}',
        expectedDurationMs: clipDurationSeconds * 1000,
        onProgress: onProgress,
      );
    }
  }

  Future<void> _runCommand(
    String command, {
    required double expectedDurationMs,
    void Function(double phaseFraction)? onProgress,
  }) async {
    final done = Completer<void>();
    var lastReported = -1.0;

    await FFmpegKit.executeAsync(
      command,
      (session) async {
        try {
          final returnCode = await session.getReturnCode();
          if (!ReturnCode.isSuccess(returnCode)) {
            final output = await session.getOutput();
            if (!done.isCompleted) {
              done.completeError(
                Exception('FFmpeg command failed: $command\n${output ?? ''}'),
              );
            }
            return;
          }

          onProgress?.call(1);
          if (!done.isCompleted) {
            done.complete();
          }
        } catch (error, stackTrace) {
          if (!done.isCompleted) {
            done.completeError(error, stackTrace);
          }
        }
      },
      null,
      (statistics) {
        if (onProgress == null || expectedDurationMs <= 0) {
          return;
        }

        final phaseFraction = (statistics.getTime() / expectedDurationMs)
            .clamp(0.0, 1.0)
            .toDouble();
        final shouldReport = lastReported < 0 ||
            phaseFraction >= 1 ||
            (phaseFraction - lastReported) >= 0.005;
        if (!shouldReport) {
          return;
        }

        lastReported = phaseFraction;
        onProgress(phaseFraction);
      },
    );

    await done.future;
  }

  double _fractionFromWork(double workMs, double totalWorkMs) {
    if (totalWorkMs <= 0) {
      return 0;
    }

    return (workMs / totalWorkMs).clamp(0.0, 1.0).toDouble();
  }

  String _quote(String path) {
    return '"${path.replaceAll('"', '\\"')}"';
  }
}
