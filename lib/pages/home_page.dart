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
import 'package:daily_you/widgets/large_entry_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/pages/entry_detail_page.dart';
import 'package:daily_you/pages/edit_entry_page.dart';
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

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _checkForLaunchIntent();
    _checkForNotificationLaunch();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showMainOnboardingIfNeeded();
    });
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

          if (!mounted) return;
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

  Future<void> _dismissMainOnboarding() async {
    await ConfigProvider.instance.set(ConfigKey.dismissedMainOnboarding, true);
  }

  Future<void> _enableDailyRemindersQuickSetup() async {
    if (!(Platform.isAndroid || Platform.isIOS) || !mounted) {
      return;
    }
    if (ConfigProvider.instance.get(ConfigKey.dailyReminders) == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Daily reminders are already enabled.')),
      );
      return;
    }

    final hasPermission =
        await NotificationManager.instance.hasNotificationPermission();
    if (!mounted) return;
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Notification permission is required to enable reminders.',
          ),
        ),
      );
      return;
    }

    await ConfigProvider.instance.set(ConfigKey.dailyReminders, true);
    await ConfigProvider.instance.set(
      ConfigKey.dismissedNotificationOnboarding,
      true,
    );
    await NotificationManager.instance.stopDailyReminders();
    await NotificationManager.instance.startScheduledDailyReminders();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Daily reminders enabled.')),
    );
  }

  Widget _buildOnboardingStep({
    required IconData icon,
    required String title,
    required String description,
    Widget? footer,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 40),
        const SizedBox(height: 12),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),
        if (footer != null) ...[
          const SizedBox(height: 12),
          footer,
        ],
      ],
    );
  }

  Future<void> _showMainOnboardingIfNeeded() async {
    if (!mounted) return;
    final bindingName = WidgetsBinding.instance.runtimeType.toString();
    if (bindingName.contains("Test")) {
      return;
    }
    if (ConfigProvider.instance.get(ConfigKey.dismissedMainOnboarding)) {
      return;
    }
    if (EntriesProvider.instance.entries.isNotEmpty) {
      await _dismissMainOnboarding();
      return;
    }

    final pageController = PageController();
    var currentPage = 0;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Welcome to Daily You'),
          content: SizedBox(
            width: 380,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 230,
                  child: PageView(
                    controller: pageController,
                    onPageChanged: (value) {
                      setState(() {
                        currentPage = value;
                      });
                    },
                    children: [
                      _buildOnboardingStep(
                        icon: Icons.auto_awesome_rounded,
                        title: 'Your private daily story',
                        description:
                            'Capture one photo or short clip every day, add a note, and build your timeline on-device.',
                      ),
                      _buildOnboardingStep(
                        icon: Icons.notifications_active_rounded,
                        title: 'Set up reminders quickly',
                        description:
                            'Enable daily reminders now and Daily You will nudge you when it is time to log today.',
                        footer: (Platform.isAndroid || Platform.isIOS)
                            ? FilledButton.tonalIcon(
                                onPressed: () async {
                                  await _enableDailyRemindersQuickSetup();
                                },
                                icon: const Icon(Icons.alarm_add_rounded),
                                label: const Text('Enable reminders'),
                              )
                            : const SizedBox.shrink(),
                      ),
                      _buildOnboardingStep(
                        icon: Icons.add_circle_outline_rounded,
                        title: 'Create your first entry',
                        description:
                            'Start with one moment from today. You can add photos, videos, and a short reflection.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: currentPage == index ? 18 : 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: currentPage == index
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await _dismissMainOnboarding();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Maybe later'),
            ),
            if (currentPage < 2)
              FilledButton(
                onPressed: () {
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                  );
                },
                child: const Text('Next'),
              ),
            if (currentPage == 2)
              FilledButton(
                onPressed: () async {
                  await _dismissMainOnboarding();
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                  final todayEntry =
                      EntriesProvider.instance.getEntryForToday();
                  final todayImages = todayEntry != null
                      ? EntryImagesProvider.instance.getForEntry(todayEntry)
                      : <EntryImage>[];
                  if (mounted) {
                    await addOrEditTodayEntry(todayEntry, todayImages, false);
                  }
                },
                child: const Text('Create first entry'),
              ),
          ],
        ),
      ),
    );
    pageController.dispose();
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

    return Center(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          buildEntries(
            context,
            configProvider,
            flashbacks,
            listView,
            entriesProvider,
            todayEntry,
            todayImages,
          ),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (Platform.isAndroid || Platform.isIOS)
                    FloatingActionButton.small(
                      heroTag: "home-camera-button",
                      tooltip: 'Capture a photo or video for today',
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      elevation: 1,
                      shape: CircleBorder(),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        color: Theme.of(context).colorScheme.primaryContainer,
                        size: 24,
                      ),
                      onPressed: () async {
                        await addOrEditTodayEntry(
                          todayEntry,
                          todayImages,
                          true,
                        );
                      },
                    ),
                  FloatingActionButton(
                    heroTag: "home-entry-button",
                    tooltip: todayEntry == null
                        ? 'Create today entry'
                        : 'Edit today entry',
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    elevation: 1,
                    child: Icon(
                      todayEntry == null
                          ? Icons.add_rounded
                          : Icons.edit_rounded,
                      color: Theme.of(context).colorScheme.primaryContainer,
                      size: 28,
                    ),
                    onPressed: () async {
                      await addOrEditTodayEntry(todayEntry, todayImages, false);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _streakOverview(EntriesProvider entriesProvider) {
    final (currentStreak, longestStreak, _) = entriesProvider.getStreaks();
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: Card.filled(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const Text('Current Streak',
                        style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(
                      '$currentStreak days',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Card.filled(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const Text('Best Streak', style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(
                      '$longestStreak days',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _firstEntryChecklist(Entry? todayEntry, List<EntryImage> todayImages) {
    return Card.filled(
      margin: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.flag_rounded, size: 18),
                SizedBox(width: 8),
                Text(
                  'First entry checklist',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Start with one moment from today. Add a photo or short clip, then write a quick note.',
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: () async {
                    await addOrEditTodayEntry(todayEntry, todayImages, false);
                  },
                  icon: const Icon(Icons.edit_rounded),
                  label: Text(
                    todayEntry == null
                        ? 'Create today entry'
                        : 'Edit today entry',
                  ),
                ),
                if (Platform.isAndroid || Platform.isIOS)
                  OutlinedButton.icon(
                    onPressed: () async {
                      await addOrEditTodayEntry(todayEntry, todayImages, true);
                    },
                    icon: const Icon(Icons.camera_alt_rounded),
                    label: const Text('Open camera'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEntries(
    BuildContext context,
    ConfigProvider configProvider,
    List<Flashback> flashbacks,
    bool listView,
    EntriesProvider entriesProvider,
    Entry? todayEntry,
    List<EntryImage> todayImages,
  ) =>
      ListView(
        controller: _scrollController,
        children: [
          const Center(
            child: SizedBox(height: 430, width: 400, child: EntryCalendar()),
          ),
          _streakOverview(entriesProvider),
          if (entriesProvider.entries.isEmpty)
            _firstEntryChecklist(todayEntry, todayImages),
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
                      crossAxisSpacing: 1.0, // Spacing between columns
                      mainAxisSpacing: 1.0, // Spacing between rows
                      childAspectRatio: listView ? 2.0 : 1.0,
                    ),
                    itemCount: flashbacks.length,
                    itemBuilder: (context, index) {
                      final flashback = flashbacks[index];
                      return GestureDetector(
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
                      );
                    },
                  ),
        ],
      );
}
