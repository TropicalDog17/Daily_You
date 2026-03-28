import 'package:daily_you/models/image.dart';
import 'package:daily_you/widgets/local_image_loader.dart';
import 'package:flutter/material.dart';

class EntryMediaPreview extends StatelessWidget {
  final EntryImage media;
  final int cacheSize;

  const EntryMediaPreview({
    super.key,
    required this.media,
    this.cacheSize = 500,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        LocalImageLoader(
          imagePath: media.imgPath,
          cacheSize: cacheSize,
        ),
        if (media.hasMotion)
          const Center(
            child: Icon(
              Icons.play_circle_fill_rounded,
              color: Colors.white,
              size: 36,
              shadows: [
                Shadow(
                  color: Colors.black54,
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        Positioned(
          top: 8,
          right: 8,
          child: _MediaTypeBadge(mediaType: media.mediaType),
        ),
      ],
    );
  }
}

class _MediaTypeBadge extends StatelessWidget {
  final String mediaType;

  const _MediaTypeBadge({required this.mediaType});

  @override
  Widget build(BuildContext context) {
    final (IconData icon, String label) = switch (mediaType) {
      EntryMediaType.video => (Icons.videocam_rounded, 'Video'),
      EntryMediaType.livePhoto => (Icons.motion_photos_on_rounded, 'Live'),
      _ => (Icons.photo_rounded, 'Photo'),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.56),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 12),
            const SizedBox(width: 3),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
