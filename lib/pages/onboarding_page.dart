import 'package:daily_you/config_provider.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/models/image.dart';
import 'package:daily_you/notification_manager.dart';
import 'package:daily_you/pages/edit_entry_page.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:daily_you/providers/entry_images_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({
    super.key,
    required this.nextPage,
  });

  final Widget nextPage;

  static const String completionKey = 'onboarding_completed_v1';

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _enableDailyReminder = true;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finishOnboarding({required bool openFirstEntry}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(OnboardingPage.completionKey, true);

    if (_enableDailyReminder) {
      if (await NotificationManager.instance.hasNotificationPermission()) {
        await ConfigProvider.instance.set(ConfigKey.dailyReminders, true);
        await NotificationManager.instance.startScheduledDailyReminders();
      }
    }

    await ConfigProvider.instance
        .set(ConfigKey.dismissedNotificationOnboarding, true);

    if (!mounted) return;
    final navigator = Navigator.of(context);
    navigator.pushReplacement(
      MaterialPageRoute(
        allowSnapshotting: false,
        builder: (context) => widget.nextPage,
      ),
    );

    if (!openFirstEntry) return;

    final Entry? todayEntry = EntriesProvider.instance.getEntryForToday();
    final List<EntryImage> todayImages = todayEntry != null
        ? EntryImagesProvider.instance.getForEntry(todayEntry)
        : [];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigator.push(
        MaterialPageRoute(
          allowSnapshotting: false,
          builder: (context) => AddEditEntryPage(
            entry: todayEntry,
            images: todayImages,
          ),
        ),
      );
    });
  }

  Future<void> _goNext() async {
    if (_currentPage == 3) {
      await _finishOnboarding(openFirstEntry: true);
      return;
    }
    await _pageController.nextPage(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () async => _finishOnboarding(openFirstEntry: false),
                child: Text(l10n.onboardingSkip),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    _currentPage = value;
                  });
                },
                children: [
                  _buildScreen(
                    icon: Icons.auto_awesome_rounded,
                    title: l10n.onboardingWelcomeTitle,
                    subtitle: l10n.onboardingWelcomeSubtitle,
                    body: l10n.onboardingWelcomeBody,
                  ),
                  _buildScreen(
                    icon: Icons.photo_library_rounded,
                    title: l10n.onboardingCaptureTitle,
                    subtitle: l10n.onboardingCaptureSubtitle,
                    body: l10n.onboardingCaptureBody,
                  ),
                  _buildScreen(
                    icon: Icons.lock_rounded,
                    title: l10n.onboardingPrivacyTitle,
                    subtitle: l10n.onboardingPrivacySubtitle,
                    body: l10n.onboardingPrivacyBody,
                  ),
                  _buildFinalScreen(theme, l10n),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                  width: _currentPage == index ? 18 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _goNext,
                  child: Text(_currentPage == 3
                      ? l10n.onboardingCreateFirstEntry
                      : l10n.onboardingContinue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScreen({
    required IconData icon,
    required String title,
    required String subtitle,
    required String body,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64),
          const SizedBox(height: 18),
          Text(
            title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          Text(
            body,
            style: const TextStyle(fontSize: 16, height: 1.3),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFinalScreen(ThemeData theme, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.notifications_active_rounded, size: 64),
          const SizedBox(height: 18),
          Text(
            l10n.onboardingGetStartedTitle,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            l10n.onboardingEnableReminderPrompt,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          SwitchListTile.adaptive(
            value: _enableDailyReminder,
            onChanged: (value) {
              setState(() {
                _enableDailyReminder = value;
              });
            },
            title: Text(l10n.onboardingDailyReminderTitle),
            subtitle: Text(l10n.onboardingDailyReminderSubtitle),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: theme.dividerColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
