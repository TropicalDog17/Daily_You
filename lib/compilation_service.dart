import 'dart:io';

import 'package:daily_you/database/image_storage.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/models/image.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:daily_you/providers/entry_images_provider.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CompilationService {
  static final CompilationService instance = CompilationService._init();

  CompilationService._init();

  List<EntryImage> collectMediaForRange({
    required DateTime start,
    required DateTime end,
  }) {
    final entries = EntriesProvider.instance.entries
        .where(
          (entry) =>
              !entry.timeCreate.isBefore(start) &&
              !entry.timeCreate.isAfter(end),
        )
        .toList()
      ..sort((a, b) => a.timeCreate.compareTo(b.timeCreate));

    final media = <EntryImage>[];
    for (final Entry entry in entries) {
      final images = EntryImagesProvider.instance.getForEntry(entry).toList()
        ..sort((a, b) => a.imgRank.compareTo(b.imgRank));
      media.addAll(images);
    }
    return media;
  }

  Future<String?> generateCompilation({
    required DateTime start,
    required DateTime end,
    int imageFrameSeconds = 1,
    int videoFrameSeconds = 2,
  }) async {
    if (!(Platform.isIOS || Platform.isAndroid)) {
      return null;
    }

    final media = collectMediaForRange(start: start, end: end);
    if (media.isEmpty) {
      return null;
    }

    final preparedInputs = <_PreparedInput>[];
    for (final item in media) {
      final sourceName = item.hasMotion && item.videoPath != null
          ? item.videoPath!
          : item.imgPath;
      await ImageStorage.instance.getBytes(sourceName);
      final internalFolder = await ImageStorage.instance.getInternalFolder();
      final sourceFile = File(join(internalFolder, sourceName));
      if (!await sourceFile.exists()) {
        continue;
      }
      preparedInputs.add(
        _PreparedInput(
          path: sourceFile.path,
          isVideo: item.hasMotion && item.videoPath != null,
          durationSeconds: item.hasMotion && item.videoPath != null
              ? videoFrameSeconds
              : imageFrameSeconds,
        ),
      );
    }

    if (preparedInputs.isEmpty) {
      return null;
    }

    final tempDir = await getTemporaryDirectory();
    final outPath = join(
      tempDir.path,
      'daily_you_compilation_${DateTime.now().toIso8601String().replaceAll(':', '-')}.mp4',
    );

    final inputArgs = <String>[];
    final filterParts = <String>[];
    for (int i = 0; i < preparedInputs.length; i++) {
      final item = preparedInputs[i];
      final escapedPath = _escape(item.path);
      if (item.isVideo) {
        inputArgs.add("-i '$escapedPath'");
        filterParts.add(
          "[$i:v]trim=duration=${item.durationSeconds},setpts=PTS-STARTPTS,scale=720:720:force_original_aspect_ratio=decrease,pad=720:720:(ow-iw)/2:(oh-ih)/2:color=black,setsar=1,fps=30,format=yuv420p[v$i]",
        );
      } else {
        inputArgs.add("-loop 1 -t ${item.durationSeconds} -i '$escapedPath'");
        filterParts.add(
          "[$i:v]trim=duration=${item.durationSeconds},setpts=PTS-STARTPTS,scale=720:720:force_original_aspect_ratio=decrease,pad=720:720:(ow-iw)/2:(oh-ih)/2:color=black,setsar=1,fps=30,format=yuv420p[v$i]",
        );
      }
    }

    final concatInputs =
        List.generate(preparedInputs.length, (i) => "[v$i]").join();
    final filter =
        "${filterParts.join(';')};$concatInputs concat=n=${preparedInputs.length}:v=1:a=0[vout]";
    final cmd =
        "${inputArgs.join(' ')} -filter_complex \"$filter\" -map \"[vout]\" "
        "-r 30 -c:v libx264 -pix_fmt yuv420p -movflags +faststart -y '${_escape(outPath)}'";

    final session = await FFmpegKit.execute(cmd);
    final returnCode = await session.getReturnCode();
    if (!ReturnCode.isSuccess(returnCode)) {
      return null;
    }
    return outPath;
  }

  String _escape(String value) => value.replaceAll("'", "'\\''");
}

class _PreparedInput {
  final String path;
  final bool isVideo;
  final int durationSeconds;

  const _PreparedInput({
    required this.path,
    required this.isVideo,
    required this.durationSeconds,
  });
}
