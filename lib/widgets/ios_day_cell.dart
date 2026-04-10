import 'package:daily_you/config_provider.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/models/image.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:daily_you/providers/entry_images_provider.dart';
import 'package:daily_you/time_manager.dart';
import 'package:daily_you/widgets/local_image_loader.dart';
import 'package:daily_you/widgets/mood_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../pages/edit_entry_page.dart';
import '../pages/entry_detail_page.dart';

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
    final isDark = theme.brightness == Brightness.dark;

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

    // Cell background
    final Color cellBg =
        isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7);

    // Today highlight ring color
    final Color todayRingColor = theme.colorScheme.primary;

    return GestureDetector(
      onTap: isFuture
          ? null
          : () async {
              if (entry != null) {
                await Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => EntryDetailPage(
                    filtered: false,
                    index: entriesProvider.getIndexOfEntry(entry.id!),
                  ),
                ));
              } else {
                await Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => AddEditEntryPage(
                    overrideCreateDate:
                        TimeManager.currentTimeOnDifferentDate(date)
                            .copyWith(isUtc: false),
                  ),
                ));
              }
            },
      child: Container(
        decoration: BoxDecoration(
          color: hasImage ? Colors.black : cellBg,
          borderRadius: BorderRadius.circular(14),
          border:
              isToday ? Border.all(color: todayRingColor, width: 2.0) : null,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            if (hasImage)
              Positioned.fill(
                child: Opacity(
                  opacity: 0.75,
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
                          ? (isDark ? Colors.white24 : Colors.black26)
                          : isToday
                              ? todayRingColor
                              : (hasImage
                                  ? Colors.white70
                                  : (isDark ? Colors.white54 : Colors.black45)),
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
                          ? (isDark ? Colors.white12 : Colors.black12)
                          : (isToday
                              ? todayRingColor
                              : (hasImage
                                  ? Colors.white
                                  : (isDark
                                      ? Colors.white.withValues(alpha: 0.9)
                                      : Colors.black87))),
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
                                  ? CupertinoIcons.play_fill
                                  : image.mediaType == 'live_photo'
                                      ? Icons.motion_photos_on_rounded
                                      : CupertinoIcons.camera_fill,
                              size: 12,
                              color: hasImage
                                  ? Colors.white60
                                  : (isDark ? Colors.white38 : Colors.black38),
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
