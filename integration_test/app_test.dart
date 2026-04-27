import 'dart:io';

import 'package:daily_you/app_startup_overrides.dart';
import 'package:daily_you/database/app_database.dart';
import 'package:daily_you/device_info_service.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/main.dart' as app;
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/notification_manager.dart';
import 'package:daily_you/pages/onboarding_page.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:daily_you/widgets/entry_card_widget.dart';
import 'package:daily_you/widgets/stat_range_selector.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const quickActionsChannel = MethodChannel('plugins.flutter.io/quick_actions');

  setUpAll(() {
    appStartupOverrides.skipDeviceInfoInit = true;
    appStartupOverrides.skipNotificationInit = true;
    appStartupOverrides.skipQuickActions = true;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(quickActionsChannel, (call) async {
      switch (call.method) {
        case 'getLaunchAction':
          return null;
        case 'setShortcutItems':
        case 'clearShortcutItems':
          return null;
      }
      return null;
    });
  });

  tearDownAll(() {
    appStartupOverrides.reset();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(quickActionsChannel, null);
  });

  tearDown(() async {
    EasyDebounce.cancel('save-config');
    EasyDebounce.cancel('save-entry');
    EasyDebounce.cancel('search-debounce');
    EasyDebounce.cancel('update-remote-database');

    if (AppDatabase.instance.database != null) {
      await AppDatabase.instance.close();
    }
  });

  testWidgets('core journaling flow resists obvious regressions',
      (tester) async {
    await _launchApp(tester, completedOnboarding: false);

    final l10n = _l10nFrom(tester, find.byType(FilledButton).first);
    final entryText =
        'integration entry ${DateTime.now().microsecondsSinceEpoch}';
    final now = DateTime.now();

    expect(find.text(l10n.onboardingSkip), findsOneWidget);
    expect(find.text(l10n.onboardingContinue), findsOneWidget);

    await tester.tap(find.text(l10n.onboardingContinue));
    await _settle(tester);
    await tester.tap(find.text(l10n.onboardingContinue));
    await _settle(tester);
    await tester.tap(find.text(l10n.onboardingContinue));
    await _settle(tester);

    final reminderToggle = find.byWidgetPredicate(
      (widget) => widget is Switch || widget is CupertinoSwitch,
    );
    expect(reminderToggle, findsOneWidget);
    await tester.tap(reminderToggle);
    await _settle(tester);

    await tester.tap(find.text(l10n.onboardingCreateFirstEntry));
    await _settle(tester);
    await _waitForFinder(tester, find.byType(TextField));

    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    expect(find.byIcon(Icons.delete), findsOneWidget);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool(OnboardingPage.completionKey), isTrue);

    final moodOptions = find.byType(Radio<int>);
    expect(moodOptions, findsWidgets);
    await tester.tap(moodOptions.first);
    await _settle(tester);

    await tester.enterText(find.byType(TextField).first, entryText);
    await tester.pump();

    await tester.tap(find.byIcon(Icons.check_rounded));
    await _settle(tester);
    await _waitForFinder(tester, _settingsButtonFinder());

    expect(EntriesProvider.instance.getEntryForToday()?.text, entryText);
    await _waitForFinder(tester, _galleryTabFinder());

    await _seedEntries([
      Entry(
        text: 'alpha search regression',
        mood: 1,
        timeCreate: now.subtract(const Duration(days: 1)),
        timeModified: now,
      ),
      Entry(
        text: 'beta search regression',
        mood: -1,
        timeCreate: now.subtract(const Duration(days: 2)),
        timeModified: now,
      ),
    ]);
    await _settle(tester);

    await tester.tap(_galleryTabFinder());
    await _settle(tester);
    await _waitForFinder(tester, find.byType(EntryCardWidget));

    expect(find.byType(EntryCardWidget), findsNWidgets(3));

    await tester.enterText(_gallerySearchInputFinder(), 'alpha search');
    await tester.pump(const Duration(milliseconds: 350));
    await _settle(tester);

    expect(find.byType(EntryCardWidget), findsOneWidget);

    await tester.enterText(_gallerySearchInputFinder(), '');
    await tester.pump(const Duration(milliseconds: 350));
    await _settle(tester);

    expect(find.byType(EntryCardWidget), findsNWidgets(3));

    await tester.tap(_statsTabFinder());
    await _settle(tester);
    await _waitForFinder(tester, find.byType(StatsRangeSelector));

    expect(find.text(l10n.statsUnlockAfterWeek), findsOneWidget);

    await _seedEntries([
      for (var day = 3; day <= 6; day += 1)
        Entry(
          text: 'stats seed $day',
          mood: day.isEven ? 1 : -1,
          timeCreate: now.subtract(Duration(days: day)),
          timeModified: now,
        ),
    ]);
    await _settle(tester);

    expect(find.text(l10n.statsUnlockAfterWeek), findsNothing);
    expect(find.byType(StatsRangeSelector), findsOneWidget);
  });
}

Future<void> _launchApp(
  WidgetTester tester, {
  required bool completedOnboarding,
}) async {
  await _resetPersistentState(completedOnboarding: completedOnboarding);
  app.main();

  final readyFinder =
      completedOnboarding ? _settingsButtonFinder() : find.byType(FilledButton);
  await _waitForFinder(
    tester,
    readyFinder,
    timeout: const Duration(seconds: 45),
  );
}

Future<void> _resetPersistentState({required bool completedOnboarding}) async {
  EasyDebounce.cancel('save-config');
  EasyDebounce.cancel('save-entry');
  EasyDebounce.cancel('search-debounce');
  EasyDebounce.cancel('update-remote-database');

  DeviceInfoService().launchIntent = null;
  NotificationManager.instance.justLaunched = false;

  if (AppDatabase.instance.database != null) {
    await AppDatabase.instance.close();
  }

  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  if (completedOnboarding) {
    await prefs.setBool(OnboardingPage.completionKey, true);
  }

  final supportDirectory = await getApplicationSupportDirectory();
  final filesToDelete = [
    'config.json',
    'config.json.tmp',
    'daily_you.db',
    'daily_you.db-shm',
    'daily_you.db-wal',
  ];

  for (final fileName in filesToDelete) {
    final file = File(p.join(supportDirectory.path, fileName));
    if (await file.exists()) {
      await file.delete();
    }
  }
}

Future<void> _seedEntries(List<Entry> entries) async {
  for (final entry in entries) {
    await EntriesProvider.instance.add(entry);
  }
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 6; i += 1) {
    await tester.pump(const Duration(milliseconds: 250));
  }
}

Future<void> _waitForFinder(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 20),
}) async {
  final endTime = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(endTime)) {
    await tester.pump(const Duration(milliseconds: 200));
    if (finder.evaluate().isNotEmpty) {
      return;
    }
  }

  expect(finder, findsWidgets);
}

AppLocalizations _l10nFrom(WidgetTester tester, Finder finder) {
  return AppLocalizations.of(tester.element(finder))!;
}

Finder _settingsButtonFinder() {
  if (Platform.isIOS) {
    return find.byIcon(CupertinoIcons.gear_alt_fill);
  }

  return find.byIcon(Icons.settings_rounded);
}

Finder _galleryTabFinder() {
  if (Platform.isIOS) {
    return find.byIcon(CupertinoIcons.photo_fill);
  }

  return find.byWidgetPredicate(
    (widget) =>
        widget is Icon &&
        (widget.icon == Icons.photo_library_outlined ||
            widget.icon == Icons.photo_library_rounded),
  );
}

Finder _statsTabFinder() {
  if (Platform.isIOS) {
    return find.byIcon(CupertinoIcons.chart_bar_fill);
  }

  return find.byWidgetPredicate(
    (widget) =>
        widget is Icon &&
        (widget.icon == Icons.auto_graph_outlined ||
            widget.icon == Icons.auto_graph_rounded),
  );
}

Finder _gallerySearchInputFinder() {
  if (Platform.isIOS) {
    return find.descendant(
      of: find.byType(CupertinoSearchTextField),
      matching: find.byType(EditableText),
    );
  }

  return find.descendant(
    of: find.byType(SearchBar),
    matching: find.byType(EditableText),
  );
}
