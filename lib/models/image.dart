const String imagesTable = 'entry_images';

class EntryMediaType {
  static const String image = 'image';
  static const String video = 'video';
  static const String livePhoto = 'live_photo';

  static bool isValid(String value) {
    return value == image || value == video || value == livePhoto;
  }
}

class EntryImageFields {
  static const List<String> values = [
    id,
    entryId,
    imgPath,
    mediaType,
    videoPath,
    imgRank,
    timeCreate
  ];
  static const String id = 'id';
  static const String entryId = 'entry_id';
  static const String imgPath = 'img_path';
  static const String mediaType = 'media_type';
  static const String videoPath = 'video_path';
  static const String imgRank = 'img_rank';
  static const String timeCreate = 'time_create';
}

class EntryImage {
  final int? id;
  int? entryId;
  final String imgPath;
  final String mediaType;
  final String? videoPath;
  int imgRank;
  final DateTime timeCreate;

  EntryImage({
    this.id,
    required this.entryId,
    required this.imgPath,
    this.mediaType = EntryMediaType.image,
    this.videoPath,
    required this.imgRank,
    required this.timeCreate,
  });

  bool get hasVideoPath => videoPath != null && videoPath!.isNotEmpty;
  bool get isVideo => mediaType == EntryMediaType.video;
  bool get isLivePhoto => mediaType == EntryMediaType.livePhoto;
  bool get hasMotion =>
      isVideo ||
      isLivePhoto ||
      (hasVideoPath && mediaType != EntryMediaType.image);

  EntryImage copy({
    int? id,
    int? entryId,
    String? imgPath,
    String? mediaType,
    String? videoPath,
    bool clearVideoPath = false,
    int? imgRank,
    DateTime? timeCreate,
  }) =>
      EntryImage(
        id: id ?? this.id,
        entryId: entryId ?? this.entryId,
        imgPath: imgPath ?? this.imgPath,
        mediaType: mediaType ?? this.mediaType,
        videoPath: clearVideoPath ? null : (videoPath ?? this.videoPath),
        imgRank: imgRank ?? this.imgRank,
        timeCreate: timeCreate ?? this.timeCreate,
      );

  static EntryImage fromJson(Map<String, Object?> json) => EntryImage(
        id: json[EntryImageFields.id] as int?,
        entryId: json[EntryImageFields.entryId] as int?,
        imgPath: json[EntryImageFields.imgPath] as String,
        mediaType: _parseMediaType(json[EntryImageFields.mediaType] as String?),
        videoPath: json[EntryImageFields.videoPath] as String?,
        imgRank: json[EntryImageFields.imgRank] as int,
        timeCreate: DateTime.parse(json[EntryImageFields.timeCreate] as String),
      );

  Map<String, Object?> toJson() => {
        EntryImageFields.id: id,
        EntryImageFields.entryId: entryId,
        EntryImageFields.imgPath: imgPath,
        EntryImageFields.mediaType: mediaType,
        EntryImageFields.videoPath: videoPath,
        EntryImageFields.imgRank: imgRank,
        EntryImageFields.timeCreate: timeCreate.toIso8601String(),
      };

  static String _parseMediaType(String? value) {
    if (value != null && EntryMediaType.isValid(value)) {
      return value;
    }
    return EntryMediaType.image;
  }
}

class PickedEntryMedia {
  final String imgPath;
  final String mediaType;
  final String? videoPath;

  const PickedEntryMedia({
    required this.imgPath,
    required this.mediaType,
    this.videoPath,
  });
}
