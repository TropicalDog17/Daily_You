import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.children,
    this.header,
    this.margin,
    this.dividerInset = 16,
  });

  final List<Widget> children;
  final String? header;
  final EdgeInsetsGeometry? margin;
  final double dividerInset;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    if (!Platform.isIOS) {
      return Padding(
        padding: margin ?? EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (header != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  header!,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ...children,
          ],
        ),
      );
    }

    final sectionColor = CupertinoDynamicColor.resolve(
      CupertinoColors.secondarySystemGroupedBackground,
      context,
    );
    final separatorColor = CupertinoDynamicColor.resolve(
      CupertinoColors.separator,
      context,
    );
    final headerColor = CupertinoDynamicColor.resolve(
      CupertinoColors.secondaryLabel,
      context,
    );

    return Padding(
      padding: margin ?? const EdgeInsets.fromLTRB(16, 0, 16, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 6),
              child: Text(
                header!.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 0.3,
                  color: headerColor,
                ),
              ),
            ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: sectionColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Column(
                children: [
                  for (var index = 0; index < children.length; index++) ...[
                    children[index],
                    if (index < children.length - 1)
                      Divider(
                        height: 1,
                        indent: dividerInset,
                        endIndent: 0,
                        color: separatorColor,
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
