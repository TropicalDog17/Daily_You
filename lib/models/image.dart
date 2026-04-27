const String imagesTable = 'entry_images';

class EntryImageFields {
  static const List<String> values = [
    id,
    entryId,
    imgPath,
    mediaType,
    livePhotoMode,
    videoPath,
    imgRank,
    timeCreate
  ];
  static const String id = 'id';
  static const String entryId = 'entry_id';
  static const String imgPath = 'img_path';
  static const String mediaType = 'media_type';
  static const String livePhotoMode = 'live_photo_mode';
  static const String videoPath = 'video_path';
  static const String imgRank = 'img_rank';
  static const String timeCreate = 'time_create';
}

class EntryImage {
  static const String mediaTypeImage = 'image';
  static const String mediaTypeVideo = 'video';
  static const String mediaTypeLivePhoto = 'live_photo';

  static const String livePhotoModeLive = 'live';
  static const String livePhotoModeStill = 'still';

  final int? id;
  int? entryId;
  final String imgPath;
  final String mediaType;
  final String livePhotoMode;
  final String? videoPath;
  int imgRank;
  final DateTime timeCreate;

  EntryImage({
    this.id,
    required this.entryId,
    required this.imgPath,
    this.mediaType = mediaTypeImage,
    this.livePhotoMode = livePhotoModeLive,
    this.videoPath,
    required this.imgRank,
    required this.timeCreate,
  });

  EntryImage copy({
    int? id,
    int? entryId,
    String? imgPath,
    String? mediaType,
    String? livePhotoMode,
    String? videoPath,
    int? imgRank,
    DateTime? timeCreate,
  }) =>
      EntryImage(
        id: id ?? this.id,
        entryId: entryId ?? this.entryId,
        imgPath: imgPath ?? this.imgPath,
        mediaType: mediaType ?? this.mediaType,
        livePhotoMode: livePhotoMode ?? this.livePhotoMode,
        videoPath: videoPath ?? this.videoPath,
        imgRank: imgRank ?? this.imgRank,
        timeCreate: timeCreate ?? this.timeCreate,
      );

  static EntryImage fromJson(Map<String, Object?> json) {
    final mediaType =
        (json[EntryImageFields.mediaType] as String?) ?? mediaTypeImage;

    return EntryImage(
      id: json[EntryImageFields.id] as int?,
      entryId: json[EntryImageFields.entryId] as int?,
      imgPath: json[EntryImageFields.imgPath] as String,
      mediaType: mediaType,
      livePhotoMode: (json[EntryImageFields.livePhotoMode] as String?) ??
          (mediaType == mediaTypeLivePhoto
              ? livePhotoModeLive
              : livePhotoModeStill),
      videoPath: json[EntryImageFields.videoPath] as String?,
      imgRank: json[EntryImageFields.imgRank] as int,
      timeCreate: DateTime.parse(json[EntryImageFields.timeCreate] as String),
    );
  }

  Map<String, Object?> toJson() => {
        EntryImageFields.id: id,
        EntryImageFields.entryId: entryId,
        EntryImageFields.imgPath: imgPath,
        EntryImageFields.mediaType: mediaType,
        EntryImageFields.livePhotoMode: livePhotoMode,
        EntryImageFields.videoPath: videoPath,
        EntryImageFields.imgRank: imgRank,
        EntryImageFields.timeCreate: timeCreate.toIso8601String(),
      };

  bool get isVideo => mediaType == mediaTypeVideo;

  bool get isLivePhoto => mediaType == mediaTypeLivePhoto;

  bool get hasMotionAsset => videoPath != null && (isVideo || isLivePhoto);

  bool get rendersMotion =>
      isVideo ||
      (isLivePhoto && hasMotionAsset && livePhotoMode == livePhotoModeLive);
}
