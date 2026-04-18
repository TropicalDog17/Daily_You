import 'dart:collection';

import 'package:daily_you/database/app_database.dart';
import 'package:daily_you/database/entry_image_dao.dart';
import 'package:daily_you/models/entry.dart';
import 'package:daily_you/models/image.dart';
import 'package:flutter/material.dart';

class EntryImagesProvider with ChangeNotifier {
  static final EntryImagesProvider instance = EntryImagesProvider._init();

  EntryImagesProvider._init();

  List<EntryImage> _images = [];
  final Map<int, List<EntryImage>> _imagesByEntryId = {};

  List<EntryImage> get images => UnmodifiableListView(_images);

  /// Load the provider's data from the app database
  Future<void> load() async {
    _images = await EntryImageDao.getAll();
    _rebuildIndex();
    notifyListeners();
  }

  // CRUD operations

  Future<void> add(EntryImage image, {skipUpdate = false}) async {
    // Insert the image into the database so that it has an ID
    final imageWithId = await EntryImageDao.add(image);
    _images.add(imageWithId);
    _rebuildIndex();
    await AppDatabase.instance.updateExternalDatabase();
    if (!skipUpdate) {
      notifyListeners();
    }
  }

  Future<void> remove(EntryImage image) async {
    await EntryImageDao.remove(image);
    _images.removeWhere((x) => x.id == image.id);
    _rebuildIndex();
    await AppDatabase.instance.updateExternalDatabase();
    notifyListeners();
  }

  Future<void> update(EntryImage image) async {
    await EntryImageDao.update(image);
    final index = _images.indexWhere((x) => x.id == image.id);
    _images[index] = image;
    _rebuildIndex();
    await AppDatabase.instance.updateExternalDatabase();
    notifyListeners();
  }

  /// Get the images for a given entry
  ///
  /// Images are sorted by image rank where the highest number is first.
  List<EntryImage> getForEntry(Entry entry) {
    final entryId = entry.id;
    if (entryId == null) {
      return const [];
    }

    return getForEntryId(entryId);
  }

  List<EntryImage> getForEntryId(int entryId) {
    final imagesForEntry = _imagesByEntryId[entryId];
    if (imagesForEntry == null) {
      return const [];
    }

    return UnmodifiableListView(imagesForEntry);
  }

  EntryImage? getPrimaryForEntryId(int entryId) {
    final imagesForEntry = _imagesByEntryId[entryId];
    if (imagesForEntry == null || imagesForEntry.isEmpty) {
      return null;
    }

    return imagesForEntry.first;
  }

  void _rebuildIndex() {
    _imagesByEntryId.clear();
    for (final image in _images) {
      final entryId = image.entryId;
      if (entryId == null) {
        continue;
      }

      _imagesByEntryId.putIfAbsent(entryId, () => []).add(image);
    }

    for (final images in _imagesByEntryId.values) {
      images.sort((a, b) => b.imgRank.compareTo(a.imgRank));
    }
  }
}
