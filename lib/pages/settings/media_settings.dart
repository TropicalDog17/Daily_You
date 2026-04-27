import 'dart:io';

import 'package:daily_you/config_provider.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/widgets/settings_page_shell.dart';
import 'package:daily_you/widgets/settings_section.dart';
import 'package:daily_you/widgets/settings_toggle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MediaSettings extends StatefulWidget {
  const MediaSettings({super.key});

  @override
  State<MediaSettings> createState() => _MediaSettingsState();
}

class _MediaSettingsState extends State<MediaSettings> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final configProvider = Provider.of<ConfigProvider>(context);
    final maxDuration =
        (configProvider.get(ConfigKey.maxVideoDurationSeconds) as int?) ?? 3;

    return SettingsPageShell(
      title: l10n.settingsMediaTitle,
      child: ListView(
        physics: Platform.isIOS
            ? const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              )
            : null,
        children: [
          SettingsSection(
            children: [
              SettingsToggle(
                title: l10n.settingsMediaImportLivePhotoTitle,
                hint: l10n.settingsMediaImportLivePhotoDescription,
                settingsKey: ConfigKey.importLivePhotosAsVideo,
                onChanged: (value) async {
                  await configProvider.set(
                    ConfigKey.importLivePhotosAsVideo,
                    value,
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.settingsMediaMaxVideoDurationTitle,
                      style: Platform.isIOS
                          ? TextStyle(
                              fontSize: 17,
                              color: CupertinoDynamicColor.resolve(
                                CupertinoColors.label,
                                context,
                              ),
                            )
                          : Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.settingsMediaDurationSeconds(maxDuration),
                      style: Platform.isIOS
                          ? TextStyle(
                              fontSize: 13,
                              color: CupertinoDynamicColor.resolve(
                                CupertinoColors.secondaryLabel,
                                context,
                              ),
                            )
                          : Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    Platform.isIOS
                        ? CupertinoSlider(
                            min: 1,
                            max: 10,
                            divisions: 9,
                            value: maxDuration.toDouble(),
                            onChanged: (value) async {
                              await configProvider.set(
                                ConfigKey.maxVideoDurationSeconds,
                                value.round(),
                              );
                            },
                          )
                        : Slider(
                            min: 1,
                            max: 10,
                            divisions: 9,
                            value: maxDuration.toDouble(),
                            label: '$maxDuration s',
                            onChanged: (value) async {
                              await configProvider.set(
                                ConfigKey.maxVideoDurationSeconds,
                                value.round(),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
