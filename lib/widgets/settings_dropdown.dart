import 'dart:io';

import 'package:daily_you/widgets/adaptive_settings_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsDropdown<T> extends StatelessWidget {
  final String title;
  final T value;
  final List<DropdownMenuItem<T>> options;
  final Function(T?) onChanged;
  final String Function(T) labelBuilder;

  const SettingsDropdown({
    super.key,
    required this.title,
    required this.value,
    required this.options,
    required this.onChanged,
    required this.labelBuilder,
  });

  Future<void> _showIosOptions(BuildContext context) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) {
        return CupertinoActionSheet(
          title: Text(title),
          actions: [
            for (final option in options)
              CupertinoActionSheetAction(
                isDefaultAction: option.value == value,
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  onChanged(option.value);
                },
                child: Text(labelBuilder(option.value as T)),
              ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(sheetContext).pop(),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      final secondaryLabel = CupertinoDynamicColor.resolve(
        CupertinoColors.secondaryLabel,
        context,
      );

      return AdaptiveSettingsRow(
        title: title,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 140),
              child: Text(
                labelBuilder(value),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 17, color: secondaryLabel),
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              CupertinoIcons.chevron_down,
              size: 16,
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.tertiaryLabel,
                context,
              ),
            ),
          ],
        ),
        onTap: () => _showIosOptions(context),
      );
    }

    return Padding(
      padding:
          const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          DropdownButton<T>(
            underline: Container(),
            elevation: 1,
            isDense: true,
            isExpanded: false,
            alignment: AlignmentDirectional.centerEnd,
            borderRadius: BorderRadius.circular(20),
            value: value,
            items: options,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
