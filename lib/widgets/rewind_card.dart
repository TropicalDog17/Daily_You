import 'package:daily_you/models/entry.dart';
import 'package:daily_you/models/image.dart';
import 'package:daily_you/time_manager.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/widgets/local_image_loader.dart';
import 'package:daily_you/widgets/mood_icon.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RewindCard extends StatelessWidget {
  const RewindCard({
    super.key,
    required this.entry,
    required this.images,
    required this.onOpen,
    required this.onShowAnother,
  });

  final Entry entry;
  final List<EntryImage> images;
  final VoidCallback onOpen;
  final VoidCallback onShowAnother;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final subtitle = DateFormat.yMMMMd(TimeManager.currentLocale(context))
        .format(entry.timeCreate);

    return Card.filled(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.45),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.history_rounded,
                    size: 20,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.rewindTitle,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: onShowAnother,
                    child: Text(l10n.rewindShowAnother),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (images.isNotEmpty)
                    SizedBox(
                      width: 74,
                      height: 74,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LocalImageLoader(
                          imagePath: images.first.imgPath,
                          cacheSize: 200,
                        ),
                      ),
                    ),
                  if (images.isNotEmpty) const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSecondaryContainer,
                                ),
                              ),
                            ),
                            MoodIcon(moodValue: entry.mood, size: 18),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          entry.text.isEmpty
                              ? l10n.rewindOpenMemoryHint
                              : entry.text,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: theme.colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
