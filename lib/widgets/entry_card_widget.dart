import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/models/image.dart';
import 'package:daily_you/time_manager.dart';
import 'package:daily_you/widgets/scaled_markdown.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/widgets/mood_icon.dart';
import 'local_image_loader.dart';
import 'video_duration_badge.dart';

class EntryCardWidget extends StatelessWidget {
  const EntryCardWidget(
      {super.key,
      this.title,
      required this.entry,
      required this.images,
      this.hideImage = false});

  final Entry entry;
  final String? title;
  final List<EntryImage> images;
  final bool hideImage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final overlayIconColor = theme.brightness == Brightness.dark
        ? theme.colorScheme.onSurface
        : theme.colorScheme.onPrimary;
    final overlayShadowColor = theme.colorScheme.scrim.withValues(alpha: 0.6);
    final time = DateFormat.yMMMd(TimeManager.currentLocale(context))
        .format(entry.timeCreate);
    return Card.filled(
      color: Theme.of(context).colorScheme.surfaceContainer,
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.topRight,
                  clipBehavior: Clip.antiAlias,
                  children: [
                    (images.isNotEmpty && !hideImage)
                        ? LocalImageLoader(
                            imagePath: images.first.imgPath,
                          )
                        : (entry.text.isNotEmpty)
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Wrap(children: [
                                  IgnorePointer(
                                      child: SizedBox(
                                    width: double.maxFinite,
                                    child: ScaledMarkdown(data: entry.text),
                                  ))
                                ]),
                              )
                            : Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .writeSomethingHint,
                                  style: TextStyle(
                                      color: theme.disabledColor, fontSize: 16),
                                ),
                              ),
                    if (images.length > 1 && !hideImage)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.collections_rounded,
                            color: overlayIconColor,
                            shadows: [
                              Shadow(
                                  color: overlayShadowColor,
                                  blurRadius: 6,
                                  offset: Offset(0, 0)),
                            ],
                          ),
                        ),
                      ),
                    if (images.isNotEmpty &&
                        entry.text.isNotEmpty &&
                        !hideImage)
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Icon(
                          Icons.edit_note_rounded,
                          color: overlayIconColor,
                          shadows: [
                            Shadow(
                                color: overlayShadowColor,
                                blurRadius: 6,
                                offset: Offset(0, 0)),
                          ],
                        ),
                      ),
                    if (images.isNotEmpty &&
                        images.first.mediaType != 'image' &&
                        !hideImage)
                      Positioned(
                        left: 8,
                        top: 8,
                        child: Icon(
                          images.first.mediaType == 'live_photo'
                              ? Icons.motion_photos_on_rounded
                              : Icons.play_circle_fill_rounded,
                          color: overlayIconColor,
                          shadows: [
                            Shadow(
                              color: overlayShadowColor,
                              blurRadius: 6,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    if (images.isNotEmpty &&
                        images.first.mediaType != 'image' &&
                        images.first.videoPath != null &&
                        !hideImage)
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: VideoDurationBadge(
                          videoPath: images.first.videoPath!,
                        ),
                      ),
                  ]),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  title == null ? time : title!,
                  style: TextStyle(
                      color: theme.textTheme.labelSmall?.color,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Container(
                  constraints: const BoxConstraints(minWidth: 16),
                  child: MoodIcon(
                    moodValue: entry.mood,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
