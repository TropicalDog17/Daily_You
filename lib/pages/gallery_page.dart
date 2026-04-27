import 'dart:io';

import 'package:daily_you/config_provider.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:daily_you/providers/entry_images_provider.dart';
import 'package:daily_you/widgets/frosted_panel.dart';
import 'package:daily_you/widgets/hiding_widget.dart';
import 'package:daily_you/widgets/large_entry_card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/widgets/entry_card_widget.dart';
import 'package:daily_you/pages/entry_detail_page.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:provider/provider.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final FocusNode _focusNode = FocusNode();
  GalleryFilters _filters = const GalleryFilters();
  double _searchElevation = 0.0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _searchController.text = _filters.searchText;
    _scrollController.addListener(() {
      final elevation = _scrollController.position.pixels > 0 ? 1.0 : 0.0;

      if (_searchElevation != elevation) {
        setState(() {
          _searchElevation = elevation;
        });
      }
    });
  }

  @override
  void dispose() {
    EasyDebounce.cancel('search-debounce');
    _searchController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _updateFilters(GalleryFilters nextFilters) {
    if (!mounted) return;
    setState(() {
      _filters = nextFilters;
    });
  }

  void _showSortSelectionPopup(BuildContext context) {
    if (Platform.isIOS) {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (popupContext) {
          var draftFilters = _filters;

          return StatefulBuilder(
            builder: (context, setModalState) {
              void updateFilters(GalleryFilters nextFilters) {
                setModalState(() {
                  draftFilters = nextFilters;
                });
                _updateFilters(nextFilters);
              }

              return SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Material(
                    color: Colors.transparent,
                    child: FrostedPanel(
                      borderRadius: BorderRadius.circular(28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .pageGalleryTitle,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(28, 28),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Icon(CupertinoIcons.xmark),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildIosSortSection(
                            context,
                            title: AppLocalizations.of(context)!.sortDateTitle,
                            child: CupertinoSlidingSegmentedControl<OrderBy>(
                              groupValue: draftFilters.orderBy,
                              children: {
                                OrderBy.date: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.sortDateTitle,
                                  ),
                                ),
                                OrderBy.mood: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.tagMoodTitle,
                                  ),
                                ),
                              },
                              onValueChanged: (selection) {
                                if (selection == null) return;
                                updateFilters(
                                  draftFilters.copyWith(orderBy: selection),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildIosSortSection(
                            context,
                            title: AppLocalizations.of(context)!
                                .sortOrderDescendingTitle,
                            child: CupertinoSlidingSegmentedControl<SortOrder>(
                              groupValue: draftFilters.sortOrder,
                              children: {
                                SortOrder.descending: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .sortOrderDescendingTitle,
                                  ),
                                ),
                                SortOrder.ascending: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .sortOrderAscendingTitle,
                                  ),
                                ),
                              },
                              onValueChanged: (selection) {
                                if (selection == null) return;
                                updateFilters(
                                  draftFilters.copyWith(sortOrder: selection),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        var draftFilters = _filters;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            void updateFilters(GalleryFilters nextFilters) {
              setDialogState(() {
                draftFilters = nextFilters;
              });
              _updateFilters(nextFilters);
            }

            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)!.sortDateTitle),
                  const SizedBox(height: 12),
                  SegmentedButton<OrderBy>(
                    segments: [
                      ButtonSegment<OrderBy>(
                        value: OrderBy.date,
                        label:
                            Text(AppLocalizations.of(context)!.sortDateTitle),
                      ),
                      ButtonSegment<OrderBy>(
                        value: OrderBy.mood,
                        label: Text(AppLocalizations.of(context)!.tagMoodTitle),
                      ),
                    ],
                    selected: {draftFilters.orderBy},
                    onSelectionChanged: (selection) {
                      updateFilters(
                        draftFilters.copyWith(orderBy: selection.first),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(AppLocalizations.of(context)!.sortOrderDescendingTitle),
                  const SizedBox(height: 12),
                  SegmentedButton<SortOrder>(
                    segments: [
                      ButtonSegment<SortOrder>(
                        value: SortOrder.descending,
                        label: Text(
                          AppLocalizations.of(context)!
                              .sortOrderDescendingTitle,
                        ),
                      ),
                      ButtonSegment<SortOrder>(
                        value: SortOrder.ascending,
                        label: Text(
                          AppLocalizations.of(context)!.sortOrderAscendingTitle,
                        ),
                      ),
                    ],
                    selected: {draftFilters.sortOrder},
                    onSelectionChanged: (selection) {
                      updateFilters(
                        draftFilters.copyWith(sortOrder: selection.first),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final entriesProvider = Provider.of<EntriesProvider>(context);
    final configProvider = Provider.of<ConfigProvider>(context);
    final isIOS = Platform.isIOS;
    String viewMode = configProvider.get(ConfigKey.galleryPageViewMode);
    bool listView = viewMode == 'list';
    var entries = entriesProvider.getFilteredEntries(filters: _filters);
    return Center(
      child: Stack(alignment: Alignment.topCenter, children: [
        buildEntries(context, listView, entries),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isIOS
                ? _buildIosSearchHeader(context, entries.length)
                : Padding(
                    padding: const EdgeInsets.only(
                      top: 4,
                      bottom: 8,
                      left: 8,
                      right: 8,
                    ),
                    child: SearchBar(
                      focusNode: _focusNode,
                      controller: _searchController,
                      elevation: WidgetStatePropertyAll(_searchElevation),
                      leading: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.search_rounded,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      trailing: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            final rotationAnimation =
                                Tween<double>(begin: 0.0, end: 0.5).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOut,
                              ),
                            );

                            final scaleAnimation = TweenSequence([
                              TweenSequenceItem(
                                tween:
                                    Tween<double>(begin: 0.0, end: 1.1).chain(
                                  CurveTween(curve: Curves.easeOut),
                                ),
                                weight: 50,
                              ),
                              TweenSequenceItem(
                                tween:
                                    Tween<double>(begin: 1.1, end: 1.0).chain(
                                  CurveTween(curve: Curves.easeIn),
                                ),
                                weight: 50,
                              ),
                            ]).animate(animation);

                            return RotationTransition(
                              turns: rotationAnimation,
                              child: ScaleTransition(
                                scale: scaleAnimation,
                                child: child,
                              ),
                            );
                          },
                          child: _searchController.text.isNotEmpty
                              ? IconButton(
                                  visualDensity: const VisualDensity(
                                    horizontal: VisualDensity.minimumDensity,
                                  ),
                                  key: const ValueKey('clearButton'),
                                  icon: const Icon(Icons.close_rounded),
                                  onPressed: () {
                                    _searchController.clear();
                                    _updateFilters(
                                      _filters.copyWith(searchText: ''),
                                    );
                                  },
                                )
                              : const SizedBox.shrink(
                                  key: ValueKey('empty'),
                                ),
                        ),
                        if (_filters.searchText.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .logCount(entries.length),
                            ),
                          ),
                        IconButton(
                          icon: const Icon(Icons.sort_rounded),
                          onPressed: () => _showSortSelectionPopup(context),
                        ),
                      ],
                      hintText: AppLocalizations.of(context)!.searchLogsHint,
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.only(left: 4, right: 4),
                      ),
                      backgroundColor: WidgetStatePropertyAll(
                        Theme.of(context).colorScheme.secondaryContainer,
                      ),
                      onChanged: _onSearchChanged,
                    ),
                  ),
            if (entries.isNotEmpty)
              isIOS
                  ? _buildIosJumpButton(context)
                  : HidingWidget(
                      scrollController: _scrollController,
                      duration: const Duration(milliseconds: 200),
                      hideDirection: HideDirection.down,
                      shouldShow: () {
                        return _scrollController.position.pixels >= 500;
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FloatingActionButton(
                              heroTag: 'gallery-jump-to-top-button',
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              elevation: 1,
                              onPressed: _scrollToTop,
                              child: Icon(
                                Icons.arrow_upward_rounded,
                                color: Theme.of(context).colorScheme.primary,
                                size: 28,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
          ],
        ),
      ]),
    );
  }

  void _onSearchChanged(String queryText) {
    EasyDebounce.debounce('search-debounce', const Duration(milliseconds: 300),
        () {
      _updateFilters(_filters.copyWith(searchText: queryText));
    });
  }

  Future<void> _scrollToTop() async {
    await _scrollController.position.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Widget _buildIosSearchHeader(BuildContext context, int resultsCount) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: FrostedPanel(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  borderRadius: BorderRadius.circular(24),
                  color: colorScheme.surface.withValues(alpha: 0.74),
                  child: CupertinoSearchTextField(
                    controller: _searchController,
                    focusNode: _focusNode,
                    placeholder: AppLocalizations.of(context)!.searchLogsHint,
                    backgroundColor: Colors.transparent,
                    style: Theme.of(context).textTheme.bodyLarge,
                    placeholderStyle:
                        Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                    onChanged: _onSearchChanged,
                    onSuffixTap: () {
                      _searchController.clear();
                      _updateFilters(_filters.copyWith(searchText: ''));
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              FrostedPanel(
                padding: EdgeInsets.zero,
                borderRadius: BorderRadius.circular(22),
                color: colorScheme.surface.withValues(alpha: 0.78),
                child: CupertinoButton(
                  padding: const EdgeInsets.all(12),
                  minimumSize: Size.zero,
                  onPressed: () => _showSortSelectionPopup(context),
                  child: Icon(
                    CupertinoIcons.slider_horizontal_3,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          if (_filters.searchText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FrostedPanel(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  borderRadius: BorderRadius.circular(18),
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderColor: colorScheme.primary.withValues(alpha: 0.15),
                  boxShadow: const [],
                  child: Text(
                    AppLocalizations.of(context)!.logCount(resultsCount),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: colorScheme.primary,
                        ),
                  ),
                ),
              ),
            ),
        ],
      )
          .animate()
          .fadeIn(duration: 280.ms)
          .moveY(begin: -8, end: 0, duration: 280.ms),
    );
  }

  Widget _buildIosJumpButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return HidingWidget(
      scrollController: _scrollController,
      duration: const Duration(milliseconds: 200),
      hideDirection: HideDirection.down,
      shouldShow: () {
        return _scrollController.position.pixels >= 500;
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
          child: FrostedPanel(
            padding: EdgeInsets.zero,
            borderRadius: BorderRadius.circular(24),
            color: colorScheme.surface.withValues(alpha: 0.78),
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              minimumSize: Size.zero,
              onPressed: _scrollToTop,
              child: Icon(
                CupertinoIcons.arrow_up,
                color: colorScheme.primary,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIosSortSection(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }

  Widget buildEntries(
      BuildContext context, bool listView, List<Entry> entries) {
    final entryImagesProvider = Provider.of<EntryImagesProvider>(context);
    final configProvider = Provider.of<ConfigProvider>(context);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: entries.isEmpty
          ? Center(
              key: const ValueKey('gallery-empty'),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Platform.isIOS
                    ? FrostedPanel(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              CupertinoIcons.photo,
                              size: 38,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              AppLocalizations.of(context)!.noLogs,
                              style: const TextStyle(fontSize: 17),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Add photos or videos to see your gallery grow.',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 250.ms)
                    : Card.filled(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.photo_library_outlined,
                                size: 38,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                AppLocalizations.of(context)!.noLogs,
                                style: const TextStyle(fontSize: 17),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Add photos or videos to see your gallery grow.',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            )
          : GridView.builder(
              key: ValueKey('gallery-grid-$listView'),
              controller: _scrollController,
              padding: EdgeInsets.only(
                top: Platform.isIOS ? 92 : 70,
                bottom: Platform.isIOS ? 96 : 70,
              ),
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: listView ? 500 : 300,
                  crossAxisSpacing: 1.0, // Spacing between columns
                  mainAxisSpacing: 1.0, // Spacing between rows
                  childAspectRatio: listView ? 2.0 : 1.0),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return _buildEntryReveal(
                  entryId: entry.id,
                  index: index,
                  child: GestureDetector(
                    onTap: () async {
                      await Navigator.of(context).push(
                        Platform.isIOS
                            ? CupertinoPageRoute(
                                builder: (context) => EntryDetailPage(
                                  filtered: true,
                                  galleryFilters: _filters,
                                  index: index,
                                ),
                              )
                            : MaterialPageRoute(
                                allowSnapshotting: false,
                                builder: (context) => EntryDetailPage(
                                  filtered: true,
                                  galleryFilters: _filters,
                                  index: index,
                                ),
                              ),
                      );
                    },
                    child: listView
                        ? LargeEntryCardWidget(
                            entry: entry,
                            images: entryImagesProvider.getForEntry(entry),
                            hideImage: configProvider
                                .get(ConfigKey.hideImagesInGallery),
                          )
                        : EntryCardWidget(
                            entry: entry,
                            images: entryImagesProvider.getForEntry(entry),
                            hideImage: configProvider
                                .get(ConfigKey.hideImagesInGallery),
                          ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEntryReveal({
    required int? entryId,
    required int index,
    required Widget child,
  }) {
    final clampedIndex = index > 8 ? 8 : index;
    return TweenAnimationBuilder<double>(
      key: ValueKey('gallery-entry-${entryId ?? index}'),
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 140 + (clampedIndex * 24)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 8),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
