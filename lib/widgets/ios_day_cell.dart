import 'package:daily_you/config_provider.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/models/image.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:daily_you/providers/entry_images_provider.dart';
import 'package:daily_you/time_manager.dart';
import 'package:daily_you/pages/edit_entry_page.dart';
import 'package:daily_you/pages/entry_detail_page.dart';
import 'package:daily_you/widgets/local_image_loader.dart';
import 'package:daily_you/widgets/mood_icon.dart';
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
    final entriesProvider = Provider.of<EntriesProvider>(context);
    final entryImagesProvider = Provider.of<EntryImagesProvider>(context);
    final configProvider = Provider.of<ConfigProvider>(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Entry? entry = entriesProvider.getEntryForDate(date);
    EntryImage? image;
    if (entry != null) {
      image = entryImagesProvider.getForEntry(entry).firstOrNull;
    }

    final bool isToday = TimeManager.isToday(date);
    final bool showMood =
        configProvider.get(ConfigKey.calendarViewMode) == 'mood';
    final bool hasImage = entry != null && image != null && !showMood;

    final String dayAbbrev = DateFormat(
      "EEE",
      TimeManager.currentLocale(context),
    ).format(date).toUpperCase();

    final Color cellBg = colorScheme.surfaceContainerHighest;
    final Color imageFallbackBg = colorScheme.scrim;
    final Color todayRingColor = colorScheme.primary;
    final Color futureLabelColor =
        colorScheme.onSurface.withValues(alpha: 0.38);
    final Color futureNumberColor =
        colorScheme.onSurface.withValues(alpha: 0.24);
    final Color imageLabelColor = colorScheme.onPrimary.withValues(alpha: 0.78);
    final Color imageNumberColor = colorScheme.onPrimary;
    final Color normalLabelColor = colorScheme.onSurfaceVariant;
    final Color normalNumberColor = colorScheme.onSurface;
    final Color mediaIndicatorColor = hasImage
        ? colorScheme.onPrimary.withValues(alpha: 0.72)
        : colorScheme.onSurfaceVariant.withValues(alpha: 0.78);

    Future<void> handleTap() async {
      entriesProvider.setSelectedDate(date);
      if (entry != null) {
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EntryDetailPage(
            filtered: false,
            index: entriesProvider.getIndexOfEntry(entry.id!),
          ),
        ));
        return;
      }

      await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddEditEntryPage(
          overrideCreateDate: TimeManager.currentTimeOnDifferentDate(date)
              .copyWith(isUtc: false),
        ),
      ));
    }

    return GestureDetector(
      onTap: isFuture ? null : handleTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: hasImage ? imageFallbackBg : cellBg,
          borderRadius: BorderRadius.circular(14),
          border:
              isToday ? Border.all(color: todayRingColor, width: 2.0) : null,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
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
            // Text content
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Day abbreviation
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
                              : (hasImage ? imageLabelColor : normalLabelColor),
                    ),
                  ),
                  const SizedBox(height: 1),
                  // Day number
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: isToday ? FontWeight.w800 : FontWeight.w600,
                      height: 1.1,
                      color: isFuture
                          ? futureNumberColor
                          : (isToday
                              ? todayRingColor
                              : (hasImage
                                  ? imageNumberColor
                                  : normalNumberColor)),
                    ),
                  ),
                  const Spacer(),
                  // Content indicator at bottom right
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
