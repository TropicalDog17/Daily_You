import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:daily_you/config_provider.dart';
import 'package:daily_you/device_info_service.dart';
import 'package:daily_you/language_option.dart';
import 'package:daily_you/widgets/settings_dropdown.dart';
import 'package:daily_you/widgets/settings_icon_action.dart';
import 'package:daily_you/widgets/settings_page_shell.dart';
import 'package:daily_you/widgets/settings_section.dart';
import 'package:flutter/material.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LanguageSettings extends StatefulWidget {
  const LanguageSettings({super.key});

  @override
  State<LanguageSettings> createState() => _LanguageSettingsState();
}

class _LanguageSettingsState extends State<LanguageSettings> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ConfigProvider configProvider = Provider.of<ConfigProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return SettingsPageShell(
      title: l10n.settingsLanguageTitle,
      child: ListView(
        children: [
          SettingsSection(
            children: [
              if (Platform.isAndroid &&
                  DeviceInfoService().androidSdk != null &&
                  DeviceInfoService().androidSdk! >= 33)
                SettingsIconAction(
                  title: l10n.settingsAppLanguageTitle,
                  icon: const Icon(Icons.language_rounded),
                  onPressed: () => AppSettings.openAppSettings(
                    type: AppSettingsType.appLocale,
                  ),
                ),
              SettingsDropdown<LanguageOption?>(
                title: (Platform.isAndroid &&
                        DeviceInfoService().androidSdk != null &&
                        DeviceInfoService().androidSdk! >= 33)
                    ? l10n.settingsOverrideAppLanguageTitle
                    : l10n.settingsAppLanguageTitle,
                value: LanguageOption.fromJsonOrNull(
                  configProvider.get(ConfigKey.overrideLanguage),
                ),
                labelBuilder: (value) =>
                    value?.displayName() ?? l10n.themeSystem,
                options: [
                  DropdownMenuItem<LanguageOption?>(
                    value: null,
                    child: Text(l10n.themeSystem),
                  ),
                  for (var locale in AppLocalizations.supportedLocales)
                    DropdownMenuItem<LanguageOption?>(
                      value: LanguageOption.fromLocale(locale),
                      child:
                          Text(LanguageOption.fromLocale(locale).displayName()),
                    ),
                ],
                onChanged: (LanguageOption? newValue) {
                  configProvider.set(
                    ConfigKey.overrideLanguage,
                    newValue?.toJson(),
                  );
                },
              ),
            ],
          ),
          SettingsSection(
            children: [
              SettingsIconAction(
                title: l10n.settingsHelpTranslate,
                hint: 'hosted.weblate.org/projects/daily-you',
                icon: const Icon(Icons.translate_rounded),
                onPressed: () async {
                  await launchUrl(
                    Uri.https('hosted.weblate.org', '/projects/daily-you'),
                    mode: LaunchMode.externalApplication,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
