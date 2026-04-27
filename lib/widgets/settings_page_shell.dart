import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPageShell extends StatelessWidget {
  const SettingsPageShell({
    super.key,
    required this.title,
    required this.child,
    this.previousPageTitle,
    this.trailing,
  });

  final String title;
  final Widget child;
  final String? previousPageTitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      final backgroundColor = CupertinoDynamicColor.resolve(
        CupertinoColors.systemGroupedBackground,
        context,
      );

      return CupertinoPageScaffold(
        backgroundColor: backgroundColor,
        navigationBar: CupertinoNavigationBar(
          middle: Text(title),
          previousPageTitle: previousPageTitle,
          trailing: trailing,
          backgroundColor: backgroundColor.withValues(alpha: 0.94),
          border: null,
        ),
        child: SafeArea(
          bottom: false,
          child: child,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: trailing == null ? null : [trailing!],
      ),
      body: child,
    );
  }
}
