import 'dart:io';

import 'package:daily_you/layouts/fast_page_view_scroll_physics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/pages/statistics_page.dart';
import 'package:daily_you/pages/gallery_page.dart';
import 'package:daily_you/pages/home_page.dart';

import '../pages/settings_page.dart';

class MobileScaffold extends StatefulWidget {
  const MobileScaffold({super.key});

  @override
  State<MobileScaffold> createState() => _MobileScaffoldState();
}

class _MobileScaffoldState extends State<MobileScaffold> {
  static const _pageAnimationDuration = Duration(milliseconds: 280);

  int currentIndex = 0;
  late final PageController _pageController;
  final List<bool> _isScrolled = [false, false, false];

  final List<Widget> pages = [
    const HomePage(),
    const GalleryPage(),
    const StatsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _selectPage(int index) {
    if (index == currentIndex) return;

    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: _pageAnimationDuration,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = Platform.isIOS;
    final List<String> appBarsTitles = [
      AppLocalizations.of(context)!.pageHomeTitle,
      AppLocalizations.of(context)!.pageGalleryTitle,
      AppLocalizations.of(context)!.pageStatisticsTitle,
    ];
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        // Ignore the root scrollable, which belongs to the page view, and horizontal scrolling.
        if (notification.metrics.axis != Axis.vertical ||
            notification.depth == 0) {
          return false;
        }

        final scrolled = notification.metrics.pixels > 0;
        if (_isScrolled[currentIndex] != scrolled) {
          setState(() {
            _isScrolled[currentIndex] = scrolled;
          });
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          centerTitle: isIOS,
          title: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.18),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Text(
              appBarsTitles[currentIndex],
              key: ValueKey(currentIndex),
            ),
          ),
          elevation: _isScrolled[currentIndex] ? 1 : 0,
          scrolledUnderElevation: 1,
          actions: [
            IconButton(
              icon: Icon(
                isIOS ? CupertinoIcons.gear_alt_fill : Icons.settings_rounded,
              ),
              onPressed: () async {
                await Navigator.of(context).push(
                  isIOS
                      ? CupertinoPageRoute(
                          builder: (context) => const SettingsPage(),
                        )
                      : MaterialPageRoute(
                          allowSnapshotting: false,
                          builder: (context) => const SettingsPage(),
                        ),
                );
              },
            ),
          ],
        ),
        body: PageView(
          controller: _pageController,
          physics: const FastPageViewScrollPhysics(),
          onPageChanged: (index) {
            FocusManager.instance.primaryFocus?.unfocus();
            if (index != currentIndex) {
              setState(() {
                currentIndex = index;
              });
            }
          },
          children: pages,
        ),
        bottomNavigationBar: isIOS
            ? CupertinoTabBar(
                currentIndex: currentIndex,
                backgroundColor:
                    theme.colorScheme.surface.withValues(alpha: 0.95),
                activeColor: theme.colorScheme.primary,
                inactiveColor: theme.colorScheme.onSurfaceVariant,
                border: Border(
                  top: BorderSide(
                    color: theme.dividerColor.withValues(alpha: 0.35),
                  ),
                ),
                onTap: _selectPage,
                items: [
                  BottomNavigationBarItem(
                    icon: const Icon(CupertinoIcons.house_fill),
                    label: AppLocalizations.of(context)!.pageHomeTitle,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(CupertinoIcons.photo_fill),
                    label: AppLocalizations.of(context)!.pageGalleryTitle,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(CupertinoIcons.chart_bar_fill),
                    label: AppLocalizations.of(context)!.pageStatisticsTitle,
                  ),
                ],
              )
            : NavigationBar(
                height: 65,
                labelBehavior:
                    NavigationDestinationLabelBehavior.onlyShowSelected,
                elevation: 1,
                selectedIndex: currentIndex,
                onDestinationSelected: _selectPage,
                destinations: [
                  NavigationDestination(
                    icon: const Icon(Icons.home_outlined),
                    selectedIcon: const Icon(Icons.home_rounded),
                    label: AppLocalizations.of(context)!.pageHomeTitle,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.photo_library_outlined),
                    selectedIcon: const Icon(Icons.photo_library_rounded),
                    label: AppLocalizations.of(context)!.pageGalleryTitle,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.auto_graph_outlined),
                    selectedIcon: const Icon(Icons.auto_graph_rounded),
                    label: AppLocalizations.of(context)!.pageStatisticsTitle,
                  ),
                ],
              ),
      ),
    );
  }
}
