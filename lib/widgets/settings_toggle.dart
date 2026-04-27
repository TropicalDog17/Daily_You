import 'dart:io';

import 'package:daily_you/config_provider.dart';
import 'package:daily_you/widgets/adaptive_settings_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsToggle extends StatelessWidget {
  final String title;
  final String? hint;
  final String settingsKey;
  final Function(bool) onChanged;

  const SettingsToggle({
    super.key,
    required this.title,
    this.hint,
    required this.settingsKey,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context);
    final currentValue = (configProvider.get(settingsKey) as bool?) ?? false;

    return AdaptiveSettingsRow(
      title: title,
      hint: hint,
      trailing: Platform.isIOS
          ? CupertinoSwitch(value: currentValue, onChanged: onChanged)
          : Switch(value: currentValue, onChanged: onChanged),
      onTap: () => onChanged(!currentValue),
    );
  }
}
