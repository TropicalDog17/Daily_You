import 'dart:ui' as ui;

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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class EntryDayCell extends StatelessWidget {
  final DateTime date;
  final DateTime currentMonth;
  final ui.Image dayNumber;

  const EntryDayCell({
    super.key,
    required this.date,
    required this.currentMonth,
    required this.dayNumber,
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

    Future<void> handleTap() async {
      final entriesProvider = context.read<EntriesProvider>();
      if (entry != null) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            allowSnapshotting: false,
            builder: (context) => EntryDetailPage(
              filtered: false,
              index: entriesProvider.getIndexOfEntry(entry.id!),
            ),
          ),
        );
        return;
      }

      await Navigator.of(context).push(
        MaterialPageRoute(
          allowSnapshotting: false,
          builder: (context) => AddEditEntryPage(
            overrideCreateDate: TimeManager.currentTimeOnDifferentDate(date)
                .copyWith(isUtc: false),
          ),
        ),
      );
    }

    if (entry != null) {
      if (showMood || image == null) {
        return GestureDetector(
          onTap: handleTap,
          child: SizedBox(
            width: 57,
            height: 57,
            child: Card(
              margin: const EdgeInsets.all(2),
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.0,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  MoodIcon(moodValue: entry.mood, size: 18),
                ],
              ),
            ),
          ),
        );
      }

      return GestureDetector(
        onTap: handleTap,
        child: Container(
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 57,
                child: Card(
                  elevation: 0,
                  margin: const EdgeInsets.all(2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: LocalImageLoader(
                    imagePath: image.imgPath,
                    cacheSize: 100,
                  ),
                ),
              ),
              // The baked day number avoids renderer stutter from live shadows.
              RawImage(image: dayNumber),
              if (image.mediaType == 'video' || image.mediaType == 'live_photo')
                Positioned(
                  right: 8,
                  bottom: 6,
                  child: Icon(
                    image.mediaType == 'live_photo'
                        ? Icons.motion_photos_on_rounded
                        : Icons.play_circle_fill_rounded,
                    size: 16,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: handleTap,
      child: Center(
        child: Text(
          '${date.day}',
          style: isSameDay(date, DateTime.now())
              ? TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                )
              : const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
