import 'dart:io';

import 'package:daily_you/config_provider.dart';
import 'package:daily_you/database/image_storage.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:daily_you/models/image.dart';
import 'package:daily_you/services/ios_live_photo_import_service.dart';
import 'package:ffmpeg_kit_flutter_new_min/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new_min/return_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart'
    show basename, basenameWithoutExtension, dirname, extension, join;
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class EntryImagePicker extends StatefulWidget {
  final ValueChanged<List<EntryImage>> onChangedImage;
  final bool openCamera;

  const EntryImagePicker({
    super.key,
    required this.onChangedImage,
    this.openCamera = false,
  });

  @override
  State<EntryImagePicker> createState() => _EntryImagePickerState();
}

class _EntryImagePickerState extends State<EntryImagePicker> {
  @override
  void initState() {
    super.initState();
    if (widget.openCamera) {
      _takePicture();
    }
  }

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final quality = ConfigProvider.instance.get(ConfigKey.imageQualityLevel);
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final media = await _buildImageMedia(pickedFile, quality);
      if (media != null) {
        widget.onChangedImage([media]);
      }
      // Delete picked file from cache
      if (Platform.isAndroid || Platform.isIOS) {
        await File(pickedFile.path).delete();
      }
    }
  }

  Future<void> _choosePicture() async {
    final quality = ConfigProvider.instance.get(ConfigKey.imageQualityLevel);

    final importLivePhoto =
        ConfigProvider.instance.get(ConfigKey.importLivePhotosAsVideo) ?? false;

    if (Platform.isIOS && importLivePhoto) {
      try {
        final imported =
            await IOSLivePhotoImportService.pickImagesWithMetadata();
        final newImages = <EntryImage>[];

        for (final photo in imported) {
          final file = XFile(
            photo.imagePath,
            name: basename(photo.imagePath),
          );
          final media = await _buildImageMedia(
            file,
            quality,
            metadataLivePhotoVideoPath: photo.pairedVideoPath,
            metadataSaysLivePhoto: photo.isLivePhoto,
            fromMetadataImport: true,
          );
          if (media != null) {
            newImages.add(media);
          }
          await _safeDeleteLocalFile(photo.imagePath);
          if (photo.pairedVideoPath != null) {
            await _safeDeleteLocalFile(photo.pairedVideoPath!);
          }
        }

        widget.onChangedImage(newImages);
        return;
      } on PlatformException {
        // Fall through to the regular picker if metadata import is unavailable.
      }
    }

    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    List<EntryImage> newImages = List.empty(growable: true);
    for (var file in pickedFiles) {
      final media = await _buildImageMedia(file, quality);
      if (media != null) {
        newImages.add(media);
      }
      // Delete picked file from cache
      await _safeDeleteLocalFile(file.path);
    }
    widget.onChangedImage(newImages);
  }

  Future<EntryImage?> _buildImageMedia(
    XFile file,
    String imageQuality, {
    String? metadataLivePhotoVideoPath,
    bool metadataSaysLivePhoto = false,
    bool fromMetadataImport = false,
  }) async {
    final imageName = await ImageStorage.instance.create(
      file.name,
      await _compressImage(file, imageQuality),
    );
    if (imageName == null) return null;

    final importLivePhoto =
        ConfigProvider.instance.get(ConfigKey.importLivePhotosAsVideo) ?? false;
    if (Platform.isIOS && importLivePhoto) {
      var motionPath = metadataLivePhotoVideoPath;
      final shouldUseHeuristicFallback =
          !fromMetadataImport || metadataSaysLivePhoto;
      if (motionPath == null && shouldUseHeuristicFallback) {
        motionPath = await _findLivePhotoVideoPath(file.path);
      }
      if (motionPath != null) {
        final motionName = await ImageStorage.instance.create(
          basename(motionPath),
          await File(motionPath).readAsBytes(),
        );
        if (motionName != null) {
          return EntryImage(
            entryId: null,
            imgPath: imageName,
            mediaType: 'live_photo',
            videoPath: motionName,
            imgRank: 0,
            timeCreate: DateTime.now(),
          );
        }
      }
    }

    return EntryImage(
      entryId: null,
      imgPath: imageName,
      imgRank: 0,
      timeCreate: DateTime.now(),
    );
  }

  Future<String?> _findLivePhotoVideoPath(String imagePath) async {
    final ext = extension(imagePath).toLowerCase();
    if (ext != '.heic' && ext != '.heif') return null;

    final baseDir = dirname(imagePath);
    final imageBase = basenameWithoutExtension(imagePath);
    final canonicalBase = imageBase.startsWith('IMG_E')
        ? imageBase.replaceFirst('IMG_E', 'IMG_')
        : imageBase;

    final candidates = <String>{
      join(baseDir, '$imageBase.mov'),
      join(baseDir, '$imageBase.MOV'),
      join(baseDir, '$canonicalBase.mov'),
      join(baseDir, '$canonicalBase.MOV'),
    };

    for (final candidate in candidates) {
      if (await File(candidate).exists()) {
        return candidate;
      }
    }

    return null;
  }

  Future<void> _chooseVideo() async {
    final picker = ImagePicker();
    final maxDurationSeconds =
        ConfigProvider.instance.get(ConfigKey.maxVideoDurationSeconds) ?? 3;
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final maxDuration = Duration(seconds: maxDurationSeconds);
    String workingVideoPath = pickedFile.path;
    bool createdTrimmedVideo = false;

    try {
      final videoDuration = await _getVideoDuration(pickedFile.path);

      if (videoDuration != null && videoDuration > maxDuration) {
        final trimmedPath = await _trimVideoToDuration(
          inputPath: pickedFile.path,
          maxDuration: maxDuration,
        );

        if (trimmedPath == null) {
          if (mounted) {
            final l10n = AppLocalizations.of(context)!;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.mediaVideoTrimFailed)),
            );
          }
          return;
        }

        workingVideoPath = trimmedPath;
        createdTrimmedVideo = true;

        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(l10n.mediaVideoTrimmedToDuration(maxDurationSeconds)),
            ),
          );
        }
      }

      final thumbnailBytes = await VideoThumbnail.thumbnailData(
        video: workingVideoPath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 720,
        quality: 75,
      );
      if (thumbnailBytes == null) return;

      final thumbnailName = await ImageStorage.instance.create(
        '${basenameWithoutExtension(pickedFile.name)}.jpg',
        thumbnailBytes,
      );
      if (thumbnailName == null) return;

      final videoName = await ImageStorage.instance.create(
        '${basenameWithoutExtension(pickedFile.name)}.mp4',
        await File(workingVideoPath).readAsBytes(),
      );
      if (videoName == null) {
        await ImageStorage.instance.delete(thumbnailName);
        return;
      }

      widget.onChangedImage([
        EntryImage(
          entryId: null,
          imgPath: thumbnailName,
          mediaType: 'video',
          videoPath: videoName,
          imgRank: 0,
          timeCreate: DateTime.now(),
        ),
      ]);
    } finally {
      await _safeDeleteLocalFile(pickedFile.path);
      if (createdTrimmedVideo) {
        await _safeDeleteLocalFile(workingVideoPath);
      }
    }
  }

  Future<String?> _trimVideoToDuration({
    required String inputPath,
    required Duration maxDuration,
  }) async {
    final temporaryDir = await getTemporaryDirectory();
    final outputPath = join(
      temporaryDir.path,
      'daily_you_trim_${DateTime.now().millisecondsSinceEpoch}.mp4',
    );
    final seconds = (maxDuration.inMilliseconds / 1000).toStringAsFixed(3);

    final command = '-y -i ${_quote(inputPath)} -t $seconds '
        '-c:v libx264 -preset veryfast -crf 23 -c:a aac '
        '-movflags +faststart ${_quote(outputPath)}';

    final session = await FFmpegKit.execute(command);
    final returnCode = await session.getReturnCode();
    if (!ReturnCode.isSuccess(returnCode)) {
      return null;
    }

    if (await File(outputPath).exists()) {
      return outputPath;
    }
    return null;
  }

  String _quote(String path) {
    return '"${path.replaceAll('"', '\\"')}"';
  }

  Future<void> _safeDeleteLocalFile(String path) async {
    if (!(Platform.isAndroid || Platform.isIOS)) return;

    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // Ignore cleanup failures for temporary picker files.
    }
  }

  Future<Duration?> _getVideoDuration(String path) async {
    final controller = VideoPlayerController.file(File(path));
    try {
      await controller.initialize();
      return controller.value.duration;
    } catch (_) {
      return null;
    } finally {
      await controller.dispose();
    }
  }

  Future<Uint8List> _compressImage(XFile image, String imageQuality) async {
    final width =
        (ConfigProvider.imageQualityMaxSizeMapping[imageQuality] ?? 1600)
            .toInt();
    final quality =
        ConfigProvider.imageQualityCompressionMapping[imageQuality] ?? 100;

    // Return raw bytes if compression is disabled or if the image is a GIF
    if ((extension(image.path).toLowerCase() == ".gif") ||
        (imageQuality == ImageQuality.noCompression)) {
      return await image.readAsBytes();
    } else {
      if (Platform.isAndroid || Platform.isIOS) {
        return await FlutterImageCompress.compressWithFile(
              image.path,
              quality: quality,
              minWidth: width,
              minHeight: width,
            ) ??
            await image.readAsBytes();
      } else {
        final cmd = img.Command()
          ..decodeJpgFile(image.path)
          ..copyResize(width: width, interpolation: img.Interpolation.average)
          ..encodeJpgFile(image.path, quality: quality);
        await cmd.executeThread();
        return await image.readAsBytes();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: _choosePicture,
          icon: Icon(
            Icons.photo,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
        IconButton(
          onPressed: _chooseVideo,
          icon: Icon(
            Icons.videocam_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
        if (Platform.isAndroid || Platform.isIOS)
          IconButton(
            onPressed: _takePicture,
            icon: Icon(
              Icons.photo_camera_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
      ],
    );
  }
}
