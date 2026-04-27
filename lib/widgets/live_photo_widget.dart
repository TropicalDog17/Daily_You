import 'dart:io';

import 'package:daily_you/database/image_storage.dart';
import 'package:daily_you/models/image.dart';
import 'package:daily_you/widgets/local_image_loader.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LivePhotoWidget extends StatefulWidget {
  const LivePhotoWidget({
    super.key,
    required this.media,
    this.onTap,
    this.onToggle,
    this.borderRadius = 12,
    this.cacheSize = 500,
  });

  final EntryImage media;
  final VoidCallback? onTap;
  final VoidCallback? onToggle;
  final double borderRadius;
  final int cacheSize;

  @override
  State<LivePhotoWidget> createState() => _LivePhotoWidgetState();
}

class _LivePhotoWidgetState extends State<LivePhotoWidget>
    with WidgetsBindingObserver {
  VideoPlayerController? _controller;
  bool _initializing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _syncPlayback();
  }

  @override
  void didUpdateWidget(covariant LivePhotoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.media.videoPath != widget.media.videoPath) {
      _disposeController();
    }

    if (oldWidget.media.videoPath != widget.media.videoPath ||
        oldWidget.media.livePhotoMode != widget.media.livePhotoMode) {
      _syncPlayback();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _syncPlayback();
      return;
    }

    _controller?.pause();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _disposeController();
    super.dispose();
  }

  Future<void> _syncPlayback() async {
    if (!widget.media.rendersMotion) {
      await _controller?.pause();
      if (mounted) {
        setState(() {});
      }
      return;
    }

    final controller = await _ensureController();
    if (!mounted || controller == null) {
      return;
    }

    await controller.seekTo(Duration.zero);
    await controller.play();
    if (mounted) {
      setState(() {});
    }
  }

  Future<VideoPlayerController?> _ensureController() async {
    if (_controller != null) {
      return _controller;
    }
    if (_initializing) {
      return null;
    }

    final videoPath = widget.media.videoPath;
    if (videoPath == null) {
      return null;
    }

    _initializing = true;
    try {
      final resolvedPath = await ImageStorage.instance.getFilePath(videoPath);
      if (!mounted || resolvedPath == null) {
        return null;
      }

      final controller = VideoPlayerController.file(File(resolvedPath));
      await controller.initialize();
      await controller.setLooping(true);
      await controller.setVolume(0);

      if (!mounted) {
        await controller.dispose();
        return null;
      }

      _controller = controller;
      return controller;
    } finally {
      _initializing = false;
    }
  }

  void _disposeController() {
    _controller?.dispose();
    _controller = null;
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final isPlayingMotion =
        widget.media.rendersMotion && controller?.value.isInitialized == true;

    return Card.filled(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            LocalImageLoader(
              imagePath: widget.media.imgPath,
              cacheSize: widget.cacheSize,
            ),
            if (isPlayingMotion && controller != null)
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: controller.value.size.width,
                  height: controller.value.size.height,
                  child: VideoPlayer(controller),
                ),
              ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.16),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.28),
                    ],
                  ),
                ),
              ),
            ),
            if (_initializing && widget.media.rendersMotion)
              const Center(child: CircularProgressIndicator()),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      widget.media.rendersMotion
                          ? Icons.motion_photos_on_rounded
                          : Icons.motion_photos_off_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            if (widget.onToggle != null)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: IconButton.filledTonal(
                    tooltip: widget.media.rendersMotion
                        ? 'Show still image'
                        : 'Show live photo',
                    onPressed: widget.onToggle,
                    icon: Icon(
                      widget.media.rendersMotion
                          ? Icons.pause_circle_rounded
                          : Icons.play_circle_fill_rounded,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
