import 'dart:io';

import 'package:daily_you/database/image_storage.dart';
import 'package:daily_you/models/image.dart';
import 'package:daily_you/widgets/local_image_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({
    super.key,
    required this.media,
    this.height = 220,
    this.borderRadius = 12,
    this.autoStart = false,
  });

  final EntryImage media;
  final double height;
  final double borderRadius;
  final bool autoStart;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with WidgetsBindingObserver {
  VideoPlayerController? _controller;
  Future<void>? _initializeFuture;
  bool _showPlayer = false;
  ScrollPosition? _scrollPosition;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startPlayer();
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final nextPosition = Scrollable.maybeOf(context)?.position;
    if (_scrollPosition == nextPosition) return;

    _scrollPosition?.removeListener(_onScroll);
    _scrollPosition = nextPosition;
    _scrollPosition?.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.media.videoPath != widget.media.videoPath) {
      _disposeController();
      _showPlayer = false;
    }
    if (widget.autoStart && !_showPlayer) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startPlayer();
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      _controller?.pause();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollPosition?.removeListener(_onScroll);
    _disposeController();
    super.dispose();
  }

  void _onScroll() {
    if (!_showPlayer || _controller == null || !_controller!.value.isPlaying) {
      return;
    }

    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return;

    final viewport = RenderAbstractViewport.of(renderObject);
    if (_scrollPosition == null) return;

    final top = viewport.getOffsetToReveal(renderObject, 0).offset;
    final bottom = viewport.getOffsetToReveal(renderObject, 1).offset;
    final viewportTop = _scrollPosition!.pixels;
    final viewportBottom = viewportTop + _scrollPosition!.viewportDimension;

    final isVisible = bottom > viewportTop && top < viewportBottom;
    if (!isVisible) {
      _controller?.pause();
    }
  }

  void _disposeController() {
    _controller?.dispose();
    _controller = null;
    _initializeFuture = null;
  }

  Future<void> _startPlayer() async {
    final videoPath = widget.media.videoPath;
    if (videoPath == null) return;

    if (_controller == null) {
      final resolvedPath = await ImageStorage.instance.getFilePath(videoPath);
      if (resolvedPath == null) return;

      final controller = VideoPlayerController.file(File(resolvedPath));
      _controller = controller;
      _initializeFuture = controller.initialize();
      await _initializeFuture;
      await controller.setLooping(false);
    }

    if (!mounted) return;
    setState(() {
      _showPlayer = true;
    });
    await _controller?.play();
  }

  @override
  Widget build(BuildContext context) {
    final hasVideo = widget.media.videoPath != null;

    return SizedBox(
      height: widget.height,
      child: Card.filled(
        clipBehavior: Clip.antiAlias,
        child: hasVideo && _showPlayer
            ? FutureBuilder<void>(
                future: _initializeFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done ||
                      _controller == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      FittedBox(
                        fit: BoxFit.contain,
                        child: SizedBox(
                          width: _controller!.value.size.width,
                          height: _controller!.value.size.height,
                          child: VideoPlayer(_controller!),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ColoredBox(
                          color: Colors.black.withValues(alpha: 0.35),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  if (_controller!.value.isPlaying) {
                                    await _controller!.pause();
                                  } else {
                                    await _controller!.play();
                                  }
                                  if (mounted) setState(() {});
                                },
                                icon: Icon(
                                  _controller!.value.isPlaying
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                ),
                              ),
                              Expanded(
                                child: VideoProgressIndicator(
                                  _controller!,
                                  allowScrubbing: true,
                                  colors: VideoProgressColors(
                                    playedColor:
                                        Theme.of(context).colorScheme.primary,
                                    bufferedColor: Colors.white54,
                                    backgroundColor: Colors.white24,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _controller!.pause();
                                  setState(() {
                                    _showPlayer = false;
                                  });
                                },
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )
            : InkWell(
                onTap: hasVideo ? _startPlayer : null,
                child: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.center,
                  children: [
                    LocalImageLoader(imagePath: widget.media.imgPath),
                    if (hasVideo)
                      Container(
                        color: Colors.black.withValues(alpha: 0.2),
                        child: const Center(
                          child: Icon(
                            Icons.play_circle_fill_rounded,
                            size: 54,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
