import 'dart:io';

import 'package:daily_you/pages/settings/about_settings.dart';
import 'package:daily_you/pages/settings/appearance_settings.dart';
import 'package:daily_you/pages/settings/backup_restore_settings.dart';
import 'package:daily_you/pages/settings/flashback_settings.dart';
import 'package:daily_you/pages/settings/language_settings.dart';
import 'package:daily_you/pages/settings/media_settings.dart';
import 'package:daily_you/pages/settings/notification_settings.dart';
import 'package:daily_you/pages/settings/security_settings.dart';
import 'package:daily_you/pages/settings/storage_settings.dart';
import 'package:daily_you/pages/settings/templates_page.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:daily_you/widgets/settings_category.dart';
import 'package:daily_you/widgets/settings_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final entriesProvider = Provider.of<EntriesProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    final primaryItems = <_SettingsDestination>[
      _SettingsDestination(
        title: localizations.settingsAppearanceTitle,
        icon: CupertinoIcons.paintbrush_fill,
        page: AppearanceSettings(),
      ),
      _SettingsDestination(
        title: localizations.settingsLanguageTitle,
        icon: CupertinoIcons.globe,
        page: LanguageSettings(),
      ),
      if (Platform.isAndroid || Platform.isIOS)
        _SettingsDestination(
          title: localizations.settingsNotificationsTitle,
          icon: CupertinoIcons.bell_fill,
          page: NotificationSettings(),
        ),
    ];

    final journalItems = <_SettingsDestination>[
      _SettingsDestination(
        title: localizations.flashbacksTitle,
        icon: CupertinoIcons.time,
        page: FlashbackSettings(),
      ),
      _SettingsDestination(
        title: localizations.settingsTemplatesTitle,
        icon: CupertinoIcons.doc_text_fill,
        page: TemplateSettings(),
      ),
      _SettingsDestination(
        title: localizations.settingsMediaTitle,
        icon: CupertinoIcons.photo_fill,
        page: const MediaSettings(),
      ),
    ];

    final systemItems = <_SettingsDestination>[
      _SettingsDestination(
        title: localizations.settingsStorageTitle,
        icon: CupertinoIcons.archivebox,
        page: StorageSettings(),
      ),
      _SettingsDestination(
        title: localizations.settingsSecurityTitle,
        icon: CupertinoIcons.lock_fill,
        page: SecuritySettings(),
      ),
      _SettingsDestination(
        title: localizations.settingsBackupRestoreTitle,
        icon: CupertinoIcons.arrow_clockwise_circle_fill,
        page: BackupRestoreSettings(),
      ),
      _SettingsDestination(
        title: localizations.settingsAboutTitle,
        icon: CupertinoIcons.info_circle_fill,
        page: AboutSettings(),
      ),
    ];

    if (Platform.isIOS) {
      final backgroundColor = CupertinoDynamicColor.resolve(
        CupertinoColors.systemGroupedBackground,
        context,
      );
      final secondaryLabel = CupertinoDynamicColor.resolve(
        CupertinoColors.secondaryLabel,
        context,
      );

      return CupertinoPageScaffold(
        backgroundColor: backgroundColor,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            CupertinoSliverNavigationBar(
              largeTitle: Text(localizations.pageSettingsTitle),
              previousPageTitle: localizations.pageHomeTitle,
              backgroundColor: backgroundColor.withValues(alpha: 0.94),
              border: null,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
                child: Text(
                  localizations.logCount(entriesProvider.entries.length),
                  style: TextStyle(fontSize: 15, color: secondaryLabel),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SettingsSection(
                    dividerInset: 48,
                    children: _buildSectionRows(primaryItems),
                  ),
                  SettingsSection(
                    dividerInset: 48,
                    children: _buildSectionRows(journalItems),
                  ),
                  SettingsSection(
                    dividerInset: 48,
                    children: _buildSectionRows(systemItems),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 2, 24, 32),
                    child: Center(
                      child: _buildSupportFooter(context, entriesProvider),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.pageSettingsTitle),
        centerTitle: true,
      ),
      persistentFooterButtons: [
        Center(
          child: _buildSupportFooter(context, entriesProvider),
        ),
      ],
      body: ListView(
        children: [
          SettingsCategory(
            title: localizations.settingsAppearanceTitle,
            icon: Icons.palette_rounded,
            page: AppearanceSettings(),
          ),
          SettingsCategory(
            title: localizations.settingsLanguageTitle,
            icon: Icons.language_rounded,
            page: LanguageSettings(),
          ),
          if (Platform.isAndroid || Platform.isIOS)
            SettingsCategory(
              title: localizations.settingsNotificationsTitle,
              icon: Icons.notifications_rounded,
              page: NotificationSettings(),
            ),
          SettingsCategory(
            title: localizations.flashbacksTitle,
            icon: Icons.history_rounded,
            page: FlashbackSettings(),
          ),
          SettingsCategory(
            title: localizations.settingsTemplatesTitle,
            icon: Icons.description_rounded,
            page: TemplateSettings(),
          ),
          SettingsCategory(
            title: localizations.settingsMediaTitle,
            icon: Icons.perm_media_rounded,
            page: const MediaSettings(),
          ),
          SettingsCategory(
            title: localizations.settingsStorageTitle,
            icon: Icons.storage_rounded,
            page: StorageSettings(),
          ),
          SettingsCategory(
            title: localizations.settingsSecurityTitle,
            icon: Icons.security_rounded,
            page: SecuritySettings(),
          ),
          SettingsCategory(
            title: localizations.settingsBackupRestoreTitle,
            icon: Icons.settings_backup_restore_rounded,
            page: BackupRestoreSettings(),
          ),
          SettingsCategory(
            title: localizations.settingsAboutTitle,
            icon: Icons.info_rounded,
            page: AboutSettings(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSectionRows(List<_SettingsDestination> items) {
    return items
        .map(
          (item) => SettingsCategory(
            title: item.title,
            icon: item.icon,
            page: item.page,
          ),
        )
        .toList();
  }

  Widget _buildSupportFooter(
    BuildContext context,
    EntriesProvider entriesProvider,
  ) {
    final localizations = AppLocalizations.of(context)!;

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: localizations.settingsMadeWithLove,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          if (entriesProvider.entries.length > 30)
            TextSpan(
              text: ' ',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          if (entriesProvider.entries.length > 30)
            TextSpan(
              text: localizations.settingsConsiderSupporting,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.primary,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  await launchUrl(
                    Uri(
                      scheme: 'https',
                      host: 'github.com',
                      path: '/Demizo/Daily_You',
                      queryParameters: {'tab': 'readme-ov-file'},
                      fragment: 'support-the-app',
                    ),
                    mode: LaunchMode.externalApplication,
                  );
                },
            ),
        ],
      ),
    );
  }
}

class _SettingsDestination {
  const _SettingsDestination({
    required this.title,
    required this.icon,
    required this.page,
  });

  final String title;
  final IconData icon;
  final Widget page;
}
