import 'dart:io';

import 'package:daily_you/widgets/adaptive_settings_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsIconAction extends StatelessWidget {
  final String title;
  final String? hint;
  final Icon icon;
  final Icon? secondaryIcon;
  final Function() onPressed;
  final Function()? onSecondaryPressed;

  const SettingsIconAction(
      {super.key,
      required this.title,
      this.hint,
      required this.icon,
      this.secondaryIcon,
      required this.onPressed,
      this.onSecondaryPressed});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      final tintColor = CupertinoTheme.of(context).primaryColor;

      return AdaptiveSettingsRow(
        title: title,
        hint: hint,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (secondaryIcon != null && onSecondaryPressed != null)
              CupertinoButton(
                padding: EdgeInsets.zero,
                minimumSize: const Size(28, 28),
                onPressed: onSecondaryPressed,
                child: IconTheme(
                  data: IconThemeData(color: tintColor, size: 20),
                  child: secondaryIcon!,
                ),
              ),
            if (secondaryIcon != null && onSecondaryPressed != null)
              const SizedBox(width: 10),
            IconTheme(
              data: IconThemeData(color: tintColor, size: 20),
              child: icon,
            ),
          ],
        ),
        onTap: onPressed,
      );
    }

    return Padding(
      padding:
          const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                if (hint != null)
                  Text(
                    hint!,
                    style: TextStyle(fontSize: 14),
                  ),
              ],
            ),
          ),
          IconButton(onPressed: onPressed, icon: icon),
          if (secondaryIcon != null && onSecondaryPressed != null)
            IconButton(onPressed: onSecondaryPressed, icon: secondaryIcon!)
        ],
      ),
    );
  }
}
