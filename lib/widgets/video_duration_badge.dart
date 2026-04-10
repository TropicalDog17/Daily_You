import 'dart:io';

import 'package:daily_you/database/image_storage.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoDurationBadge extends StatefulWidget {
  const VideoDurationBadge({
    super.key,
    required this.videoPath,
  });

  final String videoPath;

  @override
  State<VideoDurationBadge> createState() => _VideoDurationBadgeState();
}

class _VideoDurationBadgeState extends State<VideoDurationBadge> {
  static final Map<String, Duration> _durationCache = {};

  Duration? _duration;

  @override
  void initState() {
    super.initState();
    _loadDuration();
  }

  @override
  void didUpdateWidget(covariant VideoDurationBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoPath != widget.videoPath) {
      _duration = null;
      _loadDuration();
    }
  }

  Future<void> _loadDuration() async {
    if (_durationCache.containsKey(widget.videoPath)) {
      if (mounted) {
        setState(() {
          _duration = _durationCache[widget.videoPath];
        });
      }
      return;
    }

    final resolvedPath =
        await ImageStorage.instance.getFilePath(widget.videoPath);
    if (resolvedPath == null) return;

    final controller = VideoPlayerController.file(File(resolvedPath));
    try {
      await controller.initialize();
      _durationCache[widget.videoPath] = controller.value.duration;
      if (mounted) {
        setState(() {
          _duration = controller.value.duration;
        });
      }
    } catch (_) {
      // Leave badge hidden if duration cannot be read.
    } finally {
      await controller.dispose();
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = duration.inHours;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    if (_duration == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _formatDuration(_duration!),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
