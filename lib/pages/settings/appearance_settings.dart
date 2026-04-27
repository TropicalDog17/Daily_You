import 'dart:io';

import 'package:daily_you/config_provider.dart';
import 'package:daily_you/time_manager.dart';
import 'package:daily_you/widgets/mood_icon.dart';
import 'package:daily_you/widgets/settings_dropdown.dart';
import 'package:daily_you/widgets/settings_icon_action.dart';
import 'package:daily_you/widgets/settings_page_shell.dart';
import 'package:daily_you/widgets/settings_section.dart';
import 'package:daily_you/widgets/settings_toggle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:daily_you/theme_mode_provider.dart';

class AppearanceSettings extends StatefulWidget {
  const AppearanceSettings({super.key});

  @override
  State<AppearanceSettings> createState() => _AppearanceSettingsPageState();
}

class _AppearanceSettingsPageState extends State<AppearanceSettings> {
  void _showAccentColorPopup(ThemeModeProvider themeProvider) {
    Color accentColor =
        Color(ConfigProvider.instance.get(ConfigKey.accentColor));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: [
            TextButton(
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(MaterialLocalizations.of(context).okButtonLabel),
              onPressed: () {
                themeProvider.accentColor = accentColor;
                themeProvider.updateAccentColor();
                Navigator.pop(context);
              },
            ),
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ColorPicker(
                  enableAlpha: false,
                  labelTypes: const [ColorLabelType.rgb, ColorLabelType.hex],
                  paletteType: PaletteType.hueWheel,
                  pickerColor:
                      Color(ConfigProvider.instance.get(ConfigKey.accentColor)),
                  onColorChanged: (color) {
                    accentColor = color;
                  }),
            ],
          ),
        );
      },
    );
  }

  void _showMoodEmojiPopup(int? value) {
    String newEmoji = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: MoodIcon(
              moodValue: value,
              size: 32,
            ),
          ),
          actions: [
            TextButton(
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(MaterialLocalizations.of(context).okButtonLabel),
              onPressed: () async {
                final navigator = Navigator.of(context);
                if (newEmoji.isNotEmpty) {
                  if (value != null) {
                    await ConfigProvider.instance.set(
                        ConfigProvider.moodValueFieldMapping[value]!, newEmoji);
                  } else {
                    await ConfigProvider.instance
                        .set(ConfigKey.noMoodIcon, newEmoji);
                  }
                }
                if (!navigator.mounted) return;
                navigator.pop();
              },
            ),
          ],
          content: TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(1), // Limit to one character
            ],
            onChanged: (value) {
              newEmoji = value;
            },
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.moodIconPrompt,
            ),
          ),
        );
      },
    );
  }

  _resetMoodIcons() async {
    for (var mood in ConfigProvider.defaultMoodIconFieldMapping.entries) {
      await ConfigProvider.instance.set(mood.key, mood.value);
    }
  }

  Widget moodIconButton(int? index) {
    final child = Container(
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      decoration: BoxDecoration(
        color: Platform.isIOS
            ? CupertinoDynamicColor.resolve(
                CupertinoColors.systemGrey5,
                context,
              )
            : Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(child: MoodIcon(moodValue: index, size: 24)),
    );

    if (Platform.isIOS) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        onPressed: () => _showMoodEmojiPopup(index),
        child: child,
      );
    }

    return GestureDetector(
      child: Card.filled(
        color: Theme.of(context).colorScheme.surfaceContainer,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: child,
        ),
      ),
      onTap: () => _showMoodEmojiPopup(index),
    );
  }

  String _themeLabel(BuildContext context, String value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 'dark':
        return l10n.themeDark;
      case 'light':
        return l10n.themeLight;
      case 'amoled':
        return l10n.themeAmoled;
      case 'system':
      default:
        return l10n.themeSystem;
    }
  }

  String _layoutLabel(BuildContext context, String value) {
    final l10n = AppLocalizations.of(context)!;
    switch (value) {
      case 'grid':
        return l10n.viewLayoutGrid;
      case 'list':
      default:
        return l10n.viewLayoutList;
    }
  }

  String _firstDayOfWeekLabel(BuildContext context, String value) {
    if (value == 'system') {
      return AppLocalizations.of(context)!.themeSystem;
    }

    final dayLabels = TimeManager.daysOfWeekLabels(context);
    final dayIndex = TimeManager.dayOfWeekIndexMapping.entries
        .firstWhere((entry) => entry.value == value)
        .key;
    return dayLabels[dayIndex];
  }

  List<DropdownMenuItem<String>> _buildFirstDayOfWeekDropdownItems(
      BuildContext context) {
    final dayLabels = TimeManager.daysOfWeekLabels(context);
    List<DropdownMenuItem<String>> dropdownItems = List.empty(growable: true);
    dropdownItems.add(DropdownMenuItem<String>(
      value: "system",
      child: Text(AppLocalizations.of(context)!.themeSystem),
    ));

    var dropdownDays = List.generate(7, (index) {
      return DropdownMenuItem<String>(
        value: TimeManager.dayOfWeekIndexMapping[index],
        child: Text(
          dayLabels[index],
        ),
      );
    });
    dropdownItems.addAll(dropdownDays);
    return dropdownItems;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeModeProvider>(context);
    final configProvider = Provider.of<ConfigProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return SettingsPageShell(
      title: l10n.settingsAppearanceTitle,
      child: ListView(
        physics: Platform.isIOS
            ? const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              )
            : null,
        children: [
          SettingsSection(
            children: [
              SettingsDropdown<String>(
                title: l10n.settingsTheme,
                value: configProvider.get(ConfigKey.theme),
                labelBuilder: (value) => _themeLabel(context, value),
                options: [
                  DropdownMenuItem<String>(
                    value: 'system',
                    child: Text(l10n.themeSystem),
                  ),
                  DropdownMenuItem<String>(
                    value: 'dark',
                    child: Text(l10n.themeDark),
                  ),
                  DropdownMenuItem<String>(
                    value: 'light',
                    child: Text(l10n.themeLight),
                  ),
                  DropdownMenuItem<String>(
                    value: 'amoled',
                    child: Text(l10n.themeAmoled),
                  ),
                ],
                onChanged: (String? newValue) {
                  ThemeMode themeMode = ThemeMode.system;
                  switch (newValue) {
                    case 'system':
                      themeMode = ThemeMode.system;
                      break;
                    case 'light':
                      themeMode = ThemeMode.light;
                      break;
                    case 'dark':
                    case 'amoled':
                      themeMode = ThemeMode.dark;
                      break;
                    default:
                      themeMode = ThemeMode.system;
                      break;
                  }
                  themeProvider.themeMode = themeMode;
                  configProvider.set(ConfigKey.theme, newValue);
                },
              ),
              SettingsToggle(
                title: l10n.settingsUseSystemAccentColor,
                settingsKey: ConfigKey.followSystemColor,
                onChanged: (value) {
                  configProvider.set(ConfigKey.followSystemColor, value);
                  themeProvider.updateAccentColor();
                },
              ),
              if (!configProvider.get(ConfigKey.followSystemColor))
                SettingsIconAction(
                  title: l10n.settingsCustomAccentColor,
                  icon: const Icon(Icons.colorize_rounded),
                  onPressed: () async {
                    _showAccentColorPopup(themeProvider);
                  },
                ),
              SettingsDropdown<String>(
                title: l10n.settingsFirstDayOfWeek,
                value: configProvider.get(ConfigKey.startingDayOfWeek),
                labelBuilder: (value) => _firstDayOfWeekLabel(context, value),
                options: _buildFirstDayOfWeekDropdownItems(context),
                onChanged: (String? newValue) async {
                  await configProvider.set(
                    ConfigKey.startingDayOfWeek,
                    newValue,
                  );
                },
              ),
              SettingsDropdown<String>(
                title: l10n.settingsFlashbacksViewLayout,
                value: configProvider.get(ConfigKey.homePageViewMode),
                labelBuilder: (value) => _layoutLabel(context, value),
                options: [
                  DropdownMenuItem<String>(
                    value: 'list',
                    child: Text(l10n.viewLayoutList),
                  ),
                  DropdownMenuItem<String>(
                    value: 'grid',
                    child: Text(l10n.viewLayoutGrid),
                  ),
                ],
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    configProvider.set(ConfigKey.homePageViewMode, newValue);
                  }
                },
              ),
              SettingsDropdown<String>(
                title: l10n.settingsGalleryViewLayout,
                value: configProvider.get(ConfigKey.galleryPageViewMode),
                labelBuilder: (value) => _layoutLabel(context, value),
                options: [
                  DropdownMenuItem<String>(
                    value: 'list',
                    child: Text(l10n.viewLayoutList),
                  ),
                  DropdownMenuItem<String>(
                    value: 'grid',
                    child: Text(l10n.viewLayoutGrid),
                  ),
                ],
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    configProvider.set(ConfigKey.galleryPageViewMode, newValue);
                  }
                },
              ),
              SettingsToggle(
                title: l10n.settingsHideImagesInGallery,
                settingsKey: ConfigKey.hideImagesInGallery,
                onChanged: (value) {
                  configProvider.set(ConfigKey.hideImagesInGallery, value);
                },
              ),
            ],
          ),
          SettingsSection(
            header: l10n.settingsChangeMoodIcons,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          moodIconButton(-2),
                          moodIconButton(-1),
                          moodIconButton(0),
                          moodIconButton(1),
                          moodIconButton(2),
                          moodIconButton(null),
                        ],
                      ),
                    ),
                    Platform.isIOS
                        ? CupertinoButton(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(32, 32),
                            onPressed: _resetMoodIcons,
                            child: const Icon(CupertinoIcons.refresh),
                          )
                        : IconButton(
                            onPressed: _resetMoodIcons,
                            icon: const Icon(Icons.refresh_rounded),
                          ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
