import 'dart:io';

import 'package:daily_you/widgets/adaptive_settings_row.dart';
import 'package:daily_you/widgets/settings_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsCategory extends StatelessWidget {
  final String title;
  final String? hint;
  final IconData icon;
  final Widget page;

  const SettingsCategory({
    super.key,
    required this.title,
    this.hint,
    required this.icon,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      final iconColor = CupertinoDynamicColor.resolve(
        CupertinoColors.systemGrey,
        context,
      );

      return AdaptiveSettingsRow(
        title: title,
        hint: hint,
        leading: Icon(icon, color: iconColor, size: 22),
        trailing: Icon(
          CupertinoIcons.chevron_forward,
          color: CupertinoDynamicColor.resolve(
            CupertinoColors.tertiaryLabel,
            context,
          ),
          size: 18,
        ),
        onTap: () async {
          await Navigator.of(context).push(
            settingsPageRoute(builder: (context) => page),
          );
        },
      );
    }

    return ListTile(
      title: Text(title),
      subtitle: hint != null ? Text(hint!) : null,
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Icon(icon),
      ),
      minVerticalPadding: 18,
      onTap: () async {
        await Navigator.of(context).push(
          settingsPageRoute(builder: (context) => page),
        );
      },
    );
  }
}
