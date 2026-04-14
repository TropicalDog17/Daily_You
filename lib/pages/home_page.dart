import 'dart:io';

import 'package:daily_you/config_provider.dart';
import 'package:daily_you/device_info_service.dart';
import 'package:daily_you/flashback_manager.dart';
import 'package:daily_you/launch_intent.dart';
import 'package:daily_you/models/flashback.dart';
import 'package:daily_you/models/image.dart';
import 'package:daily_you/notification_manager.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:daily_you/providers/entry_images_provider.dart';
import 'package:daily_you/time_manager.dart';
import 'package:daily_you/widgets/entry_calendar.dart';
import 'package:daily_you/widgets/hiding_widget.dart';
import 'package:daily_you/widgets/ios_calendar_grid.dart';
import 'package:daily_you/widgets/large_entry_card_widget.dart';
import 'package:daily_you/widgets/rewind_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/pages/entry_detail_page.dart';
import 'package:daily_you/pages/edit_entry_page.dart';
import 'package:daily_you/pages/compilation_page.dart';
import 'package:daily_you/pages/year_in_review_page.dart';
import 'package:provider/provider.dart';
import '../widgets/entry_card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  String searchText = '';
  bool sortOrderAsc = true;
  bool firstLoad = true;
  final ScrollController _scrollController = ScrollController();
  Entry? _rewindEntry;
  List<Entry> _rewindCandidates = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _checkForLaunchIntent();
    _checkForNotificationLaunch();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Future<void> addOrEditTodayEntry(
    Entry? todayEntry,
    List<EntryImage> todayImages,
    bool openCamera,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        allowSnapshotting: false,
        builder: (context) => AddEditEntryPage(
          entry: todayEntry,
          openCamera: openCamera,
          images: todayImages,
        ),
      ),
    );
  }

  Future<void> _openCompilation() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        allowSnapshotting: false,
        builder: (context) => const CompilationPage(),
      ),
    );
  }

  Future _checkForLaunchIntent() async {
    final intent = DeviceInfoService().launchIntent;
    if (intent != null) {
      Entry? todayEntry = EntriesProvider.instance.getEntryForToday();
      List<EntryImage> todayImages = todayEntry != null
          ? EntryImagesProvider.instance.getForEntry(todayEntry)
          : [];
      bool openCamera = (intent is TakePhotoIntent) ? true : false;
      DeviceInfoService().launchIntent = null;
      await addOrEditTodayEntry(todayEntry, todayImages, openCamera);
    }
  }

  Future _checkForNotificationLaunch() async {
    if (firstLoad) {
      firstLoad = false;
      if (Platform.isAndroid || Platform.isIOS) {
        var launchDetails = await NotificationManager.instance.notifications
            .getNotificationAppLaunchDetails();

        if (NotificationManager.instance.justLaunched &&
            launchDetails?.notificationResponse?.id == 0) {
          NotificationManager.instance.justLaunched = false;

          DateTime targetDate = DateTime.tryParse(
                launchDetails?.notificationResponse?.payload ?? "",
              ) ??
              DateTime.now();
          Entry? entry = EntriesProvider.instance.getEntryForDate(targetDate);
          List<EntryImage> entryImages = entry != null
              ? EntryImagesProvider.instance.getForEntry(entry)
              : [];

          await Navigator.of(context).push(
            MaterialPageRoute(
              allowSnapshotting: false,
              builder: (context) => AddEditEntryPage(
                entry: entry,
                openCamera: false,
                images: entryImages,
                overrideCreateDate: TimeManager.isToday(targetDate)
                    ? DateTime.now()
                    : TimeManager.currentTimeOnDifferentDate(targetDate),
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final configProvider = Provider.of<ConfigProvider>(context);
    final entriesProvider = Provider.of<EntriesProvider>(context);
    final entryImagesProvider = Provider.of<EntryImagesProvider>(context);

    Entry? todayEntry = entriesProvider.getEntryForToday();
    List<EntryImage> todayImages =
        todayEntry != null ? entryImagesProvider.getForEntry(todayEntry) : [];

    List<Flashback> flashbacks = FlashbackManager.getFlashbacks(
      context,
      entriesProvider.entries,
    );

    String viewMode = ConfigProvider.instance.get(ConfigKey.homePageViewMode);
    bool listView = viewMode == 'list';

    final isIOS = Platform.isIOS;

    return Center(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          buildEntries(context, configProvider, flashbacks, listView),
          HidingWidget(
            duration: Duration(milliseconds: 200),
            hideDirection: HideDirection.down,
            scrollController: _scrollController,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                bottom: 8.0,
              ),
              child: isIOS
                  ? _buildIosActionButtons(context, todayEntry, todayImages)
                  : _buildMaterialActionButtons(
                      context, todayEntry, todayImages),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIosActionButtons(
    BuildContext context,
    Entry? todayEntry,
    List<EntryImage> todayImages,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark
        ? colorScheme.primary.withValues(alpha: 0.85)
        : colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _openCompilation,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(
              CupertinoIcons.film_fill,
              color: theme.colorScheme.onSecondaryContainer,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Camera button — smaller pill
        GestureDetector(
          onTap: () async {
            await addOrEditTodayEntry(todayEntry, todayImages, true);
          },
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              CupertinoIcons.camera_fill,
              color: colorScheme.onPrimary,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Main entry button — larger pill
        GestureDetector(
          onTap: () async {
            await addOrEditTodayEntry(todayEntry, todayImages, false);
          },
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              todayEntry == null ? CupertinoIcons.plus : CupertinoIcons.pencil,
              color: colorScheme.onPrimary,
              size: 26,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMaterialActionButtons(
    BuildContext context,
    Entry? todayEntry,
    List<EntryImage> todayImages,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FloatingActionButton.small(
          heroTag: "home-compilation-button",
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          elevation: 1,
          shape: CircleBorder(),
          onPressed: _openCompilation,
          child: Icon(
            Icons.movie_creation_rounded,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            size: 22,
          ),
        ),
        if (Platform.isAndroid || Platform.isIOS)
          FloatingActionButton.small(
            heroTag: "home-camera-button",
            backgroundColor: Theme.of(context).colorScheme.primary,
            elevation: 1,
            shape: CircleBorder(),
            onPressed: () async {
              await addOrEditTodayEntry(todayEntry, todayImages, true);
            },
            child: Icon(
              Icons.camera_alt_rounded,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 24,
            ),
          ),
        FloatingActionButton(
          heroTag: "home-entry-button",
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 1,
          onPressed: () async {
            await addOrEditTodayEntry(todayEntry, todayImages, false);
          },
          child: Icon(
            todayEntry == null ? Icons.add_rounded : Icons.edit_rounded,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 28,
          ),
        ),
      ],
    );
  }

  Widget buildEntries(
    BuildContext context,
    ConfigProvider configProvider,
    List<Flashback> flashbacks,
    bool listView,
  ) {
    final entriesProvider = Provider.of<EntriesProvider>(context);
    final entryImagesProvider = Provider.of<EntryImagesProvider>(context);

    _syncRewindEntries(entriesProvider);
    final rewindCard =
        _buildRewindCard(context, entriesProvider, entryImagesProvider);
    final emptyState = entriesProvider.entries.isEmpty
        ? _buildCalendarEmptyState(context)
        : null;
    final yearInReviewBanner = _buildYearInReviewBanner(context);

    if (Platform.isIOS) {
      return IosCalendarGrid(
        scrollController: _scrollController,
        rewindCard: rewindCard,
        emptyState: emptyState,
        yearInReviewBanner: yearInReviewBanner,
      );
    }
    return ListView(
      controller: _scrollController,
      children: [
        const Center(
          child: SizedBox(height: 430, width: 400, child: EntryCalendar()),
        ),
        if (emptyState != null) emptyState,
        if (rewindCard != null) rewindCard,
        if (yearInReviewBanner != null) yearInReviewBanner,
        if (configProvider.get(ConfigKey.showFlashbacks))
          Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 8.0,
              bottom: 8.0,
            ),
            child: Text(
              AppLocalizations.of(context)!.flashbacksTitle,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.normal),
            ),
          ),
        if (configProvider.get(ConfigKey.showFlashbacks))
          flashbacks.isEmpty
              ? Center(
                  child: Text(
                    AppLocalizations.of(context)!.flaskbacksEmpty,
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: listView ? 500 : 300,
                    crossAxisSpacing: 1.0,
                    mainAxisSpacing: 1.0,
                    childAspectRatio: listView ? 2.0 : 1.0,
                  ),
                  itemCount: flashbacks.length,
                  itemBuilder: (context, index) {
                    final flashback = flashbacks[index];
                    return _buildFlashbackReveal(
                      index: index,
                      entryId: flashback.entry.id,
                      child: GestureDetector(
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              allowSnapshotting: false,
                              builder: (context) => EntryDetailPage(
                                filtered: false,
                                index: EntriesProvider.instance.getIndexOfEntry(
                                  flashback.entry.id!,
                                ),
                              ),
                            ),
                          );
                        },
                        child: listView
                            ? LargeEntryCardWidget(
                                title: flashback.title,
                                entry: flashback.entry,
                                images:
                                    EntryImagesProvider.instance.getForEntry(
                                  flashback.entry,
                                ),
                              )
                            : EntryCardWidget(
                                title: flashback.title,
                                entry: flashback.entry,
                                images:
                                    EntryImagesProvider.instance.getForEntry(
                                  flashback.entry,
                                ),
                              ),
                      ),
                    );
                  },
                ),
      ],
    );
  }

  Widget _buildFlashbackReveal({
    required int index,
    required int? entryId,
    required Widget child,
  }) {
    final clampedIndex = index > 6 ? 6 : index;
    return TweenAnimationBuilder<double>(
      key: ValueKey('flashback-${entryId ?? index}'),
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 160 + (clampedIndex * 35)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 10),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  void _syncRewindEntries(EntriesProvider entriesProvider) {
    final now = DateTime.now();
    final candidates =
        entriesProvider.getLocalEntriesForDayOfYear(now.month, now.day);

    _rewindCandidates = candidates;
    if (_rewindEntry == null ||
        !candidates.any((entry) => entry.id == _rewindEntry!.id)) {
      _rewindEntry = candidates.isNotEmpty
          ? entriesProvider.pickRandomEntry(candidates)
          : null;
    }
  }

  Widget? _buildRewindCard(
    BuildContext context,
    EntriesProvider entriesProvider,
    EntryImagesProvider entryImagesProvider,
  ) {
    final rewindEntry = _rewindEntry;
    if (rewindEntry == null) return null;

    return RewindCard(
      entry: rewindEntry,
      images: entryImagesProvider.getForEntry(rewindEntry),
      onOpen: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            allowSnapshotting: false,
            builder: (context) => EntryDetailPage(
              filtered: false,
              index: entriesProvider.getIndexOfEntry(rewindEntry.id!),
            ),
          ),
        );
      },
      onShowAnother: () {
        if (_rewindCandidates.isEmpty) return;
        setState(() {
          _rewindEntry = entriesProvider.pickRandomEntry(
            _rewindCandidates,
            excludeId: _rewindEntry?.id,
          );
        });
      },
    );
  }

  Widget _buildCalendarEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Card.filled(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(
                Icons.wb_sunny_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child:
                    Text(AppLocalizations.of(context)!.homeEmptyStateMessage),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _buildYearInReviewBanner(BuildContext context) {
    final month = DateTime.now().month;
    if (month != 1) return null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Card.filled(
        color: Theme.of(context)
            .colorScheme
            .tertiaryContainer
            .withValues(alpha: 0.6),
        child: ListTile(
          leading: const Icon(Icons.auto_awesome_motion_rounded),
          title: Text(AppLocalizations.of(context)!.yearInReviewBannerTitle),
          subtitle:
              Text(AppLocalizations.of(context)!.yearInReviewBannerSubtitle),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                allowSnapshotting: false,
                builder: (context) => const YearInReviewPage(),
              ),
            );
          },
        ),
      ),
    );
  }
}
