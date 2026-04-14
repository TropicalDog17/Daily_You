import 'dart:typed_data';

import 'package:daily_you/database/image_storage.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/models/image.dart';
import 'package:daily_you/pages/edit_entry_page.dart';
import 'package:daily_you/providers/entries_provider.dart';
import 'package:daily_you/providers/entry_images_provider.dart';
import 'package:daily_you/time_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' show basename;
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

import '../pages/entry_detail_page.dart';

/// Opens a bottom sheet that suggests device photos taken on [date] and
/// photos from the ±7 days window around it.
void showDayPhotoSuggestionSheet(BuildContext context, DateTime date) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _DayPhotoSuggestionSheet(date: date),
  );
}

// ── Main sheet ────────────────────────────────────────────────────────────────

class _DayPhotoSuggestionSheet extends StatefulWidget {
  final DateTime date;

  const _DayPhotoSuggestionSheet({required this.date});

  @override
  State<_DayPhotoSuggestionSheet> createState() =>
      _DayPhotoSuggestionSheetState();
}

class _DayPhotoSuggestionSheetState extends State<_DayPhotoSuggestionSheet> {
  List<AssetEntity> _dayAssets = [];
  Map<DateTime, List<AssetEntity>> _nearbyByDate = {};

  bool _loading = true;
  bool _denied = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final permission = await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth && !permission.hasAccess) {
      if (mounted) setState(() { _denied = true; _loading = false; });
      return;
    }

    final date = widget.date;
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    // ── This day ──────────────────────────────────────────────────────────────
    final dayFilter = FilterOptionGroup(
      createTimeCond: DateTimeCond(min: start, max: end),
    );
    final List<AssetPathEntity> dayAlbums = await PhotoManager.getAssetPathList(
      type: RequestType.common,
      filterOption: dayFilter,
    );
    final List<AssetEntity> dayAssets = [];
    for (final album in dayAlbums) {
      final assets = await album.getAssetListRange(start: 0, end: 200);
      for (final a in assets) {
        if (!dayAssets.any((x) => x.id == a.id)) dayAssets.add(a);
      }
    }
    dayAssets.sort(
        (a, b) => b.createDateTime.compareTo(a.createDateTime));

    // ── Nearby ±7 days ────────────────────────────────────────────────────────
    const int window = 7;
    final windowStart = start.subtract(const Duration(days: window));
    final windowEnd = end.add(const Duration(days: window));

    final nearbyFilter = FilterOptionGroup(
      createTimeCond: DateTimeCond(min: windowStart, max: windowEnd),
    );
    final List<AssetPathEntity> nearbyAlbums =
        await PhotoManager.getAssetPathList(
      type: RequestType.common,
      filterOption: nearbyFilter,
    );
    final List<AssetEntity> nearbyAssets = [];
    for (final album in nearbyAlbums) {
      final assets = await album.getAssetListRange(start: 0, end: 500);
      for (final a in assets) {
        if (!nearbyAssets.any((x) => x.id == a.id)) nearbyAssets.add(a);
      }
    }

    // Group by day, exclude the exact tapped day
    final Map<DateTime, List<AssetEntity>> byDate = {};
    for (final asset in nearbyAssets) {
      final d = asset.createDateTime;
      final day = DateTime(d.year, d.month, d.day);
      if (day == start) continue;
      byDate.putIfAbsent(day, () => []).add(asset);
    }

    final sortedByDate = Map.fromEntries(
      byDate.entries.toList()
        ..sort((a, b) {
          final diffA = (a.key.difference(start).inDays).abs();
          final diffB = (b.key.difference(start).inDays).abs();
          return diffA.compareTo(diffB);
        }),
    );

    if (mounted) {
      setState(() {
        _dayAssets = dayAssets;
        _nearbyByDate = sortedByDate;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final entriesProvider = Provider.of<EntriesProvider>(context);
    final entryImagesProvider = Provider.of<EntryImagesProvider>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color sheetBg =
        isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7);
    final Color handleColor = isDark ? Colors.white24 : Colors.black26;

    final Entry? thisEntry = entriesProvider.getEntryForDate(widget.date);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: sheetBg,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 4),
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: handleColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        DateFormat(
                          'EEEE, MMMM d, y',
                          TimeManager.currentLocale(context),
                        ).format(widget.date),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      child: Icon(
                        thisEntry != null
                            ? CupertinoIcons.doc_text
                            : CupertinoIcons.plus_circle,
                        size: 22,
                        color: theme.colorScheme.primary,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        if (thisEntry != null) {
                          Navigator.of(context).push(CupertinoPageRoute(
                            builder: (_) => EntryDetailPage(
                              filtered: false,
                              index: entriesProvider
                                  .getIndexOfEntry(thisEntry.id!),
                            ),
                          ));
                        } else {
                          Navigator.of(context).push(CupertinoPageRoute(
                            builder: (_) => AddEditEntryPage(
                              overrideCreateDate:
                                  TimeManager.currentTimeOnDifferentDate(
                                          widget.date)
                                      .copyWith(isUtc: false),
                            ),
                          ));
                        }
                      },
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: _loading
                    ? const Center(child: CupertinoActivityIndicator())
                    : _denied
                        ? _PermissionDeniedView(isDark: isDark)
                        : _PhotoContent(
                            date: widget.date,
                            dayAssets: _dayAssets,
                            nearbyByDate: _nearbyByDate,
                            isDark: isDark,
                            scrollController: scrollController,
                            onPhotoTap: (asset, allAssets, index) =>
                                _openPhotoViewer(
                                    context, asset, allAssets, index),
                            onUsePhoto: (asset) => _usePhoto(
                                context,
                                asset,
                                entriesProvider,
                                entryImagesProvider),
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openPhotoViewer(BuildContext context, AssetEntity asset,
      List<AssetEntity> allAssets, int index) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => _DevicePhotoViewPage(
        assets: allAssets,
        initialIndex: index,
      ),
    ));
  }

  void _usePhoto(
    BuildContext context,
    AssetEntity asset,
    EntriesProvider entriesProvider,
    EntryImagesProvider entryImagesProvider,
  ) async {
    Navigator.pop(context);
    final file = await asset.file;
    if (file == null) return;

    final bytes = await file.readAsBytes();
    final imageName = await ImageStorage.instance.create(
      basename(file.path),
      bytes,
      currTime: asset.createDateTime,
    );
    if (imageName == null) return;

    Entry? entry = entriesProvider.getEntryForDate(widget.date);
    entry ??= await entriesProvider.createNewEntry(
      TimeManager.currentTimeOnDifferentDate(widget.date)
          .copyWith(isUtc: false),
    );

    final newImage = EntryImage(
      entryId: entry?.id,
      imgPath: imageName,
      imgRank: 0,
      timeCreate: asset.createDateTime,
    );

    final existingImages = entryImagesProvider.getForEntry(entry!);

    if (!context.mounted) return;
    Navigator.of(context).push(CupertinoPageRoute(
      builder: (_) => AddEditEntryPage(
        entry: entry,
        images: [...existingImages, newImage],
      ),
    ));
  }
}

// ── Content ───────────────────────────────────────────────────────────────────

class _PhotoContent extends StatelessWidget {
  final DateTime date;
  final List<AssetEntity> dayAssets;
  final Map<DateTime, List<AssetEntity>> nearbyByDate;
  final bool isDark;
  final ScrollController scrollController;
  final void Function(AssetEntity, List<AssetEntity>, int) onPhotoTap;
  final void Function(AssetEntity) onUsePhoto;

  const _PhotoContent({
    required this.date,
    required this.dayAssets,
    required this.nearbyByDate,
    required this.isDark,
    required this.scrollController,
    required this.onPhotoTap,
    required this.onUsePhoto,
  });

  @override
  Widget build(BuildContext context) {
    final hasDay = dayAssets.isNotEmpty;
    final hasNearby = nearbyByDate.isNotEmpty;

    if (!hasDay && !hasNearby) {
      return Center(
        child: Text(
          'No photos found around this date',
          style: TextStyle(
            color: isDark ? Colors.white38 : Colors.black38,
            fontSize: 14,
          ),
        ),
      );
    }

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        if (hasDay) ...[
          _SectionHeader(
            label: 'Photos from this day',
            count: dayAssets.length,
            isDark: isDark,
          ),
          _PhotoGrid(
            assets: dayAssets,
            isDark: isDark,
            onTap: (asset, index) => onPhotoTap(asset, dayAssets, index),
            onUse: onUsePhoto,
          ),
        ],
        if (hasNearby) ...[
          const SizedBox(height: 8),
          _SectionHeader(label: 'Nearby days', isDark: isDark),
          for (final entry in nearbyByDate.entries)
            _NearbyDateSection(
              date: entry.key,
              assets: entry.value,
              isDark: isDark,
              onTap: (asset, index) => onPhotoTap(asset, entry.value, index),
              onUse: onUsePhoto,
            ),
        ],
      ],
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final int? count;
  final bool isDark;

  const _SectionHeader({required this.label, this.count, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
      child: Row(
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: isDark ? Colors.white38 : Colors.black45,
            ),
          ),
          if (count != null)
            Text(
              '  $count',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white24 : Colors.black26,
              ),
            ),
        ],
      ),
    );
  }
}

// ── Photo grid ────────────────────────────────────────────────────────────────

class _PhotoGrid extends StatelessWidget {
  final List<AssetEntity> assets;
  final bool isDark;
  final void Function(AssetEntity, int) onTap;
  final void Function(AssetEntity) onUse;

  const _PhotoGrid({
    required this.assets,
    required this.isDark,
    required this.onTap,
    required this.onUse,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 1,
        ),
        itemCount: assets.length,
        itemBuilder: (context, index) => _AssetTile(
          asset: assets[index],
          isDark: isDark,
          onTap: () => onTap(assets[index], index),
          onUse: () => onUse(assets[index]),
        ),
      ),
    );
  }
}

// ── Nearby date section ───────────────────────────────────────────────────────

class _NearbyDateSection extends StatelessWidget {
  final DateTime date;
  final List<AssetEntity> assets;
  final bool isDark;
  final void Function(AssetEntity, int) onTap;
  final void Function(AssetEntity) onUse;

  const _NearbyDateSection({
    required this.date,
    required this.assets,
    required this.isDark,
    required this.onTap,
    required this.onUse,
  });

  @override
  Widget build(BuildContext context) {
    final label = DateFormat(
      'EEEE, MMMM d',
      TimeManager.currentLocale(context),
    ).format(date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 6),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: assets.length,
            separatorBuilder: (_, __) => const SizedBox(width: 6),
            itemBuilder: (context, index) => SizedBox(
              width: 110,
              child: _AssetTile(
                asset: assets[index],
                isDark: isDark,
                onTap: () => onTap(assets[index], index),
                onUse: () => onUse(assets[index]),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

// ── Single asset tile ─────────────────────────────────────────────────────────

class _AssetTile extends StatefulWidget {
  final AssetEntity asset;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onUse;

  const _AssetTile({
    required this.asset,
    required this.isDark,
    required this.onTap,
    required this.onUse,
  });

  @override
  State<_AssetTile> createState() => _AssetTileState();
}

class _AssetTileState extends State<_AssetTile> {
  Uint8List? _thumb;

  @override
  void initState() {
    super.initState();
    _loadThumb();
  }

  Future<void> _loadThumb() async {
    final bytes = await widget.asset.thumbnailDataWithSize(
      const ThumbnailSize(300, 300),
    );
    if (mounted) setState(() => _thumb = bytes);
  }

  @override
  Widget build(BuildContext context) {
    final isVideo = widget.asset.type == AssetType.video;
    final Color cardBg =
        widget.isDark ? const Color(0xFF2C2C2E) : Colors.white;

    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onUse,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _thumb != null
                ? Image.memory(_thumb!, fit: BoxFit.cover)
                : Container(color: cardBg),
            if (isVideo)
              const Positioned(
                bottom: 6,
                right: 6,
                child: Icon(
                  CupertinoIcons.play_fill,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            const Positioned(
              bottom: 4,
              left: 4,
              child: _HoldLabel(),
            ),
          ],
        ),
      ),
    );
  }
}

class _HoldLabel extends StatelessWidget {
  const _HoldLabel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(3),
      ),
      child: const Text(
        'Hold to use',
        style: TextStyle(fontSize: 8, color: Colors.white70),
      ),
    );
  }
}

// ── Permission denied ─────────────────────────────────────────────────────────

class _PermissionDeniedView extends StatelessWidget {
  final bool isDark;
  const _PermissionDeniedView({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.photo,
              size: 48,
              color: isDark ? Colors.white24 : Colors.black26,
            ),
            const SizedBox(height: 16),
            Text(
              'Photo library access is required to suggest photos.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white54 : Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            CupertinoButton.filled(
              child: const Text('Open Settings'),
              onPressed: () => PhotoManager.openSetting(),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Full-screen device photo viewer ──────────────────────────────────────────

class _DevicePhotoViewPage extends StatefulWidget {
  final List<AssetEntity> assets;
  final int initialIndex;

  const _DevicePhotoViewPage({
    required this.assets,
    required this.initialIndex,
  });

  @override
  State<_DevicePhotoViewPage> createState() => _DevicePhotoViewPageState();
}

class _DevicePhotoViewPageState extends State<_DevicePhotoViewPage> {
  late PageController _controller;
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          '${_current + 1} / ${widget.assets.length}',
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: widget.assets.length,
        onPageChanged: (i) => setState(() => _current = i),
        itemBuilder: (_, index) =>
            _FullAssetView(asset: widget.assets[index]),
      ),
    );
  }
}

class _FullAssetView extends StatefulWidget {
  final AssetEntity asset;
  const _FullAssetView({required this.asset});

  @override
  State<_FullAssetView> createState() => _FullAssetViewState();
}

class _FullAssetViewState extends State<_FullAssetView> {
  Uint8List? _bytes;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final bytes = await widget.asset.thumbnailDataWithSize(
      const ThumbnailSize(1080, 1080),
    );
    if (mounted) setState(() => _bytes = bytes);
  }

  @override
  Widget build(BuildContext context) {
    if (_bytes == null) {
      return const Center(child: CupertinoActivityIndicator());
    }
    return InteractiveViewer(
      child: Center(child: Image.memory(_bytes!, fit: BoxFit.contain)),
    );
  }
}
