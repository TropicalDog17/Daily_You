import 'package:daily_you/config_provider.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsMediaTitle),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(l10n.settingsMediaImportLivePhotoTitle),
            subtitle: Text(
              l10n.settingsMediaImportLivePhotoDescription,
            ),
            value:
                configProvider.get(ConfigKey.importLivePhotosAsVideo) ?? false,
            onChanged: (value) async {
              await configProvider.set(
                  ConfigKey.importLivePhotosAsVideo, value);
            },
          ),
          ListTile(
            title: Text(l10n.settingsMediaMaxVideoDurationTitle),
            subtitle: Text(l10n.settingsMediaDurationSeconds(maxDuration)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Slider(
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
          ),
        ],
      ),
    );
  }
}
