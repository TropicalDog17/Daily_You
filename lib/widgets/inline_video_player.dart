import 'dart:io';

import 'package:daily_you/database/image_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';

class InlineVideoPlayer extends StatefulWidget {
  final String videoPath;
  final bool autoplay;
  final bool loop;

  const InlineVideoPlayer({
    super.key,
    required this.videoPath,
    this.autoplay = false,
    this.loop = true,
  });

  @override
  State<InlineVideoPlayer> createState() => _InlineVideoPlayerState();
}

class _InlineVideoPlayerState extends State<InlineVideoPlayer> {
  VideoPlayerController? _controller;
  bool _loading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initPlayer() async {
    try {
      // Ensure bytes are available in the internal folder first.
      await ImageStorage.instance.getBytes(widget.videoPath);
      final folder = await ImageStorage.instance.getInternalFolder();
      final file = File(join(folder, widget.videoPath));
      if (!await file.exists()) {
        setState(() {
          _hasError = true;
          _loading = false;
        });
        return;
      }

      final controller = VideoPlayerController.file(file);
      await controller.initialize();
      await controller.setLooping(widget.loop);
      if (widget.autoplay) {
        await controller.play();
      }

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _controller = controller;
        _loading = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }
    if (_hasError || _controller == null) {
      return const Center(
        child: Icon(Icons.videocam_off_rounded, size: 36),
      );
    }

    final controller = _controller!;
    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: controller.value.aspectRatio == 0
              ? (16 / 9)
              : controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ),
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () async {
              if (controller.value.isPlaying) {
                await controller.pause();
              } else {
                await controller.play();
              }
              if (mounted) {
                setState(() {});
              }
            },
            child: Center(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: controller.value.isPlaying ? 0.0 : 1.0,
                child: const Icon(
                  Icons.play_circle_fill_rounded,
                  size: 56,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 8,
          right: 8,
          bottom: 8,
          child: VideoProgressIndicator(
            controller,
            allowScrubbing: true,
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
