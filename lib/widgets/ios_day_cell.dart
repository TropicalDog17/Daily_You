import 'dart:io';

import 'package:daily_you/config_provider.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/models/image.dart';
import 'package:daily_you/pages/edit_entry_page.dart';
import 'package:daily_you/pages/entry_detail_page.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:daily_you/providers/entry_images_provider.dart';
import 'package:daily_you/time_manager.dart';
import 'package:daily_you/widgets/local_image_loader.dart';
import 'package:daily_you/widgets/mood_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class IosDayCell extends StatelessWidget {
  final DateTime date;
  final bool isFuture;

  const IosDayCell({
    super.key,
    required this.date,
    this.isFuture = false,
  });

  @override
  Widget build(BuildContext context) {
    final entry = context.select<EntriesProvider, Entry?>(
      (provider) => provider.getEntryForDate(date),
    );
    final entryId = entry?.id;
    final image = entryId == null
        ? null
        : context.select<EntryImagesProvider, EntryImage?>(
            (provider) => provider.getPrimaryForEntryId(entryId),
          );
    final showMood = context.select<ConfigProvider, bool>(
      (provider) => provider.get(ConfigKey.calendarViewMode) == 'mood',
    );
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isToday = TimeManager.isToday(date);
    final hasImage = entry != null && image != null && !showMood;

    final dayAbbrev = DateFormat(
      'EEE',
      TimeManager.currentLocale(context),
    ).format(date).toUpperCase();

    final cellBg = colorScheme.surfaceContainerHighest;
    final imageFallbackBg = colorScheme.scrim;
    final todayRingColor = colorScheme.primary;
    final futureLabelColor = colorScheme.onSurface.withValues(alpha: 0.38);
    final futureNumberColor = colorScheme.onSurface.withValues(alpha: 0.24);
    final imageLabelColor = colorScheme.onPrimary.withValues(alpha: 0.78);
    final imageNumberColor = colorScheme.onPrimary;
    final normalLabelColor = colorScheme.onSurfaceVariant;
    final normalNumberColor = colorScheme.onSurface;
    final mediaIndicatorColor = hasImage
        ? colorScheme.onPrimary.withValues(alpha: 0.72)
        : colorScheme.onSurfaceVariant.withValues(alpha: 0.78);

    Future<void> handleTap() async {
      final entriesProvider = context.read<EntriesProvider>();
      PageRoute<T> buildRoute<T>(Widget page) {
        return Platform.isIOS
            ? CupertinoPageRoute(builder: (context) => page)
            : MaterialPageRoute(builder: (context) => page);
      }

      if (entry != null) {
        await Navigator.of(context).push(
          buildRoute(
            EntryDetailPage(
              filtered: false,
              index: entriesProvider.getIndexOfEntry(entry.id!),
            ),
          ),
        );
        return;
      }

      await Navigator.of(context).push(
        buildRoute(
          AddEditEntryPage(
            overrideCreateDate: TimeManager.currentTimeOnDifferentDate(date)
                .copyWith(isUtc: false),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: isFuture ? null : handleTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: hasImage ? imageFallbackBg : cellBg,
          borderRadius: BorderRadius.circular(14),
          border: isToday ? Border.all(color: todayRingColor, width: 2) : null,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (image != null)
              Positioned.fill(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  opacity: hasImage ? 0.75 : 0,
                  child: LocalImageLoader(
                    imagePath: image.imgPath,
                    cacheSize: 200,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dayAbbrev,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                      color: isFuture
                          ? futureLabelColor
                          : isToday
                              ? todayRingColor
                              : hasImage
                                  ? imageLabelColor
                                  : normalLabelColor,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: isToday ? FontWeight.w800 : FontWeight.w600,
                      height: 1.1,
                      color: isFuture
                          ? futureNumberColor
                          : isToday
                              ? todayRingColor
                              : hasImage
                                  ? imageNumberColor
                                  : normalNumberColor,
                    ),
                  ),
                  const Spacer(),
                  if (entry != null && !isFuture)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: (showMood || image == null)
                          ? MoodIcon(moodValue: entry.mood, size: 16)
                          : Icon(
                              image.mediaType == 'video'
                                  ? Icons.play_circle_fill_rounded
                                  : image.mediaType == 'live_photo'
                                      ? Icons.motion_photos_on_rounded
                                      : Icons.photo_camera_rounded,
                              size: 14,
                              color: mediaIndicatorColor,
                            ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
