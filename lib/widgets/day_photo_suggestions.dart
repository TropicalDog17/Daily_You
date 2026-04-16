import 'dart:typed_data';

import 'package:daily_you/database/image_storage.dart';
import 'package:daily_you/models/image.dart';
import 'package:daily_you/time_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' show basename;
import 'package:photo_manager/photo_manager.dart';

Future<EntryImage?> importSuggestedPhoto(
  AssetEntity asset, {
  int? entryId,
}) async {
  final file = await asset.file;
  if (file == null) return null;

  final bytes = await file.readAsBytes();
  final imageName = await ImageStorage.instance.create(
    basename(file.path),
    bytes,
    currTime: asset.createDateTime,
  );
  if (imageName == null) return null;

  return EntryImage(
    entryId: entryId,
    imgPath: imageName,
    imgRank: 0,
    timeCreate: asset.createDateTime,
  );
}

class DayPhotoSuggestionsSection extends StatefulWidget {
  final DateTime date;
  final Future<void> Function(EntryImage image) onUsePhoto;

  const DayPhotoSuggestionsSection({
    super.key,
    required this.date,
    required this.onUsePhoto,
  });

  @override
  State<DayPhotoSuggestionsSection> createState() =>
      _DayPhotoSuggestionsSectionState();
}

class _DayPhotoSuggestionsSectionState
    extends State<DayPhotoSuggestionsSection> {
  List<AssetEntity> _dayAssets = [];
  Map<DateTime, List<AssetEntity>> _nearbyByDate = {};
  bool _loading = true;
  bool _denied = false;
  bool _importing = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final permission = await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth && !permission.hasAccess) {
      if (!mounted) return;
      setState(() {
        _denied = true;
        _loading = false;
      });
      return;
    }

    final start =
        DateTime(widget.date.year, widget.date.month, widget.date.day);
    final end = start.add(const Duration(days: 1));

    final dayFilter = FilterOptionGroup(
      createTimeCond: DateTimeCond(min: start, max: end),
    );
    final dayAlbums = await PhotoManager.getAssetPathList(
      type: RequestType.common,
      filterOption: dayFilter,
    );
    final dayAssets = <AssetEntity>[];
    for (final album in dayAlbums) {
      final assets = await album.getAssetListRange(start: 0, end: 200);
      for (final asset in assets) {
        if (!dayAssets.any((existing) => existing.id == asset.id)) {
          dayAssets.add(asset);
        }
      }
    }
    dayAssets.sort((a, b) => b.createDateTime.compareTo(a.createDateTime));

    const window = 7;
    final nearbyFilter = FilterOptionGroup(
      createTimeCond: DateTimeCond(
        min: start.subtract(const Duration(days: window)),
        max: end.add(const Duration(days: window)),
      ),
    );
    final nearbyAlbums = await PhotoManager.getAssetPathList(
      type: RequestType.common,
      filterOption: nearbyFilter,
    );
    final nearbyAssets = <AssetEntity>[];
    for (final album in nearbyAlbums) {
      final assets = await album.getAssetListRange(start: 0, end: 500);
      for (final asset in assets) {
        if (!nearbyAssets.any((existing) => existing.id == asset.id)) {
          nearbyAssets.add(asset);
        }
      }
    }

    final byDate = <DateTime, List<AssetEntity>>{};
    for (final asset in nearbyAssets) {
      final assetDate = asset.createDateTime;
      final day = DateTime(assetDate.year, assetDate.month, assetDate.day);
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

    if (!mounted) return;
    setState(() {
      _dayAssets = dayAssets;
      _nearbyByDate = sortedByDate;
      _loading = false;
    });
  }

  Future<void> _usePhoto(AssetEntity asset) async {
    if (_importing) return;

    setState(() => _importing = true);
    try {
      final image = await importSuggestedPhoto(asset);
      if (image == null) return;
      await widget.onUsePhoto(image);
    } finally {
      if (mounted) {
        setState(() => _importing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card.filled(
      color: theme.colorScheme.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
              child:
                  Text('Suggested photos', style: theme.textTheme.titleMedium),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
              child: Text(
                'Photos taken on or near ${DateFormat.MMMd(TimeManager.currentLocale(context)).format(widget.date)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CupertinoActivityIndicator()),
              )
            else if (_denied)
              _PermissionDeniedView(isDark: isDark)
            else
              _PhotoContent(
                date: widget.date,
                dayAssets: _dayAssets,
                nearbyByDate: _nearbyByDate,
                isDark: isDark,
                onPhotoTap: (asset, allAssets, index) => _openPhotoViewer(
                  context,
                  allAssets,
                  index,
                ),
                onUsePhoto: _usePhoto,
                importing: _importing,
              ),
          ],
        ),
      ),
    );
  }

  void _openPhotoViewer(
    BuildContext context,
    List<AssetEntity> allAssets,
    int index,
  ) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => _DevicePhotoViewPage(
        assets: allAssets,
        initialIndex: index,
      ),
    ));
  }
}

class _PhotoContent extends StatelessWidget {
  final DateTime date;
  final List<AssetEntity> dayAssets;
  final Map<DateTime, List<AssetEntity>> nearbyByDate;
  final bool isDark;
  final void Function(AssetEntity, List<AssetEntity>, int) onPhotoTap;
  final void Function(AssetEntity) onUsePhoto;
  final bool importing;

  const _PhotoContent({
    required this.date,
    required this.dayAssets,
    required this.nearbyByDate,
    required this.isDark,
    required this.onPhotoTap,
    required this.onUsePhoto,
    required this.importing,
  });

  @override
  Widget build(BuildContext context) {
    final hasDay = dayAssets.isNotEmpty;
    final hasNearby = nearbyByDate.isNotEmpty;

    if (!hasDay && !hasNearby) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Text(
          'No photos found around this date',
          style: TextStyle(
            color: isDark ? Colors.white38 : Colors.black38,
            fontSize: 14,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
            importing: importing,
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
              importing: importing,
            ),
        ],
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final int? count;
  final bool isDark;

  const _SectionHeader({required this.label, this.count, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
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

class _PhotoGrid extends StatelessWidget {
  final List<AssetEntity> assets;
  final bool isDark;
  final void Function(AssetEntity, int) onTap;
  final void Function(AssetEntity) onUse;
  final bool importing;

  const _PhotoGrid({
    required this.assets,
    required this.isDark,
    required this.onTap,
    required this.onUse,
    required this.importing,
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
          onUse: importing ? null : () => onUse(assets[index]),
        ),
      ),
    );
  }
}

class _NearbyDateSection extends StatelessWidget {
  final DateTime date;
  final List<AssetEntity> assets;
  final bool isDark;
  final void Function(AssetEntity, int) onTap;
  final void Function(AssetEntity) onUse;
  final bool importing;

  const _NearbyDateSection({
    required this.date,
    required this.assets,
    required this.isDark,
    required this.onTap,
    required this.onUse,
    required this.importing,
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
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
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
                onUse: importing ? null : () => onUse(assets[index]),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _AssetTile extends StatefulWidget {
  final AssetEntity asset;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback? onUse;

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
    if (mounted) {
      setState(() => _thumb = bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isVideo = widget.asset.type == AssetType.video;
    final cardBg = widget.isDark ? const Color(0xFF2C2C2E) : Colors.white;

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

class _PermissionDeniedView extends StatelessWidget {
  final bool isDark;

  const _PermissionDeniedView({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            CupertinoIcons.photo,
            size: 40,
            color: isDark ? Colors.white24 : Colors.black26,
          ),
          const SizedBox(height: 12),
          Text(
            'Photo library access is required to suggest photos.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white54 : Colors.black54,
            ),
          ),
          const SizedBox(height: 12),
          CupertinoButton.filled(
            onPressed: PhotoManager.openSetting,
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}

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
  late final PageController _controller;
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
        onPageChanged: (index) => setState(() => _current = index),
        itemBuilder: (_, index) => _FullAssetView(asset: widget.assets[index]),
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
    if (mounted) {
      setState(() => _bytes = bytes);
    }
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
