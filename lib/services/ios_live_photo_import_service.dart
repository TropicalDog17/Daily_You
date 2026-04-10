import 'package:flutter/services.dart';

class IOSImportedPhoto {
  IOSImportedPhoto({
    required this.imagePath,
    required this.isLivePhoto,
    this.pairedVideoPath,
  });

  final String imagePath;
  final bool isLivePhoto;
  final String? pairedVideoPath;

  factory IOSImportedPhoto.fromMap(Map<dynamic, dynamic> map) {
    return IOSImportedPhoto(
      imagePath: map['imagePath'] as String,
      isLivePhoto: (map['isLivePhoto'] as bool?) ?? false,
      pairedVideoPath: map['pairedVideoPath'] as String?,
    );
  }
}

class IOSLivePhotoImportService {
  static const MethodChannel _channel = MethodChannel('daily_you/media_import');

  static Future<List<IOSImportedPhoto>> pickImagesWithMetadata({
    int selectionLimit = 0,
  }) async {
    final response = await _channel.invokeMethod<List<dynamic>>(
      'pickImagesWithMetadata',
      {'selectionLimit': selectionLimit},
    );

    if (response == null) return [];

    return response
        .whereType<Map<dynamic, dynamic>>()
        .map(IOSImportedPhoto.fromMap)
        .toList();
  }
}
