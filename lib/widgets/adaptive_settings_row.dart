import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveSettingsRow extends StatelessWidget {
  const AdaptiveSettingsRow({
    super.key,
    required this.title,
    this.hint,
    this.leading,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? hint;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final row = Padding(
      padding: EdgeInsetsDirectional.only(
        start: Platform.isIOS ? (leading == null ? 16 : 14) : 16,
        end: 16,
        top: hint == null ? 12 : 10,
        bottom: hint == null ? 12 : 10,
      ),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Platform.isIOS
                      ? TextStyle(
                          fontSize: 17,
                          color: CupertinoDynamicColor.resolve(
                            CupertinoColors.label,
                            context,
                          ),
                        )
                      : const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                ),
                if (hint != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    hint!,
                    style: Platform.isIOS
                        ? TextStyle(
                            fontSize: 13,
                            color: CupertinoDynamicColor.resolve(
                              CupertinoColors.secondaryLabel,
                              context,
                            ),
                          )
                        : TextStyle(
                            fontSize: 14,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing!,
          ],
        ],
      ),
    );

    if (onTap == null) {
      return row;
    }

    if (Platform.isIOS) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        pressedOpacity: 0.55,
        onPressed: onTap,
        child: row,
      );
    }

    return InkWell(onTap: onTap, child: row);
  }
}
