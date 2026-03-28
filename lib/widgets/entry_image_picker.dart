import 'dart:io';

import 'package:daily_you/config_provider.dart';
import 'package:daily_you/database/image_storage.dart';
import 'package:daily_you/models/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' show basenameWithoutExtension, extension;
import 'package:video_thumbnail/video_thumbnail.dart';

class EntryImagePicker extends StatefulWidget {
  final ValueChanged<List<PickedEntryMedia>> onChangedImage;
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
  static const Set<String> _videoExtensions = {
    '.mp4',
    '.mov',
    '.m4v',
    '.avi',
    '.3gp',
    '.webm',
    '.mkv',
  };

  static const Set<String> _imageExtensions = {
    '.jpg',
    '.jpeg',
    '.png',
    '.heic',
    '.heif',
    '.webp',
    '.gif',
  };

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
      final media = await _persistImage(pickedFile, quality);
      if (media == null) return;
      setState(() {
        widget.onChangedImage([media]);
      });
      await _cleanupPickedFile(pickedFile);
    }
  }

  Future<void> _choosePicture() async {
    final picker = ImagePicker();
    final quality = ConfigProvider.instance.get(ConfigKey.imageQualityLevel);
    List<XFile> pickedFiles;
    if (Platform.isAndroid || Platform.isIOS) {
      pickedFiles = await picker.pickMultipleMedia();
    } else {
      pickedFiles = await picker.pickMultiImage();
    }

    final newImages = await _processPickedMedia(pickedFiles, quality);
    setState(() {
      widget.onChangedImage(newImages);
    });
  }

  Future<List<PickedEntryMedia>> _processPickedMedia(
    List<XFile> pickedFiles,
    String imageQuality,
  ) async {
    final output = <PickedEntryMedia>[];
    final imageFiles = <XFile>[];
    final videoFiles = <XFile>[];

    for (final file in pickedFiles) {
      if (_isVideoPath(file.path)) {
        videoFiles.add(file);
      } else if (_isImagePath(file.path)) {
        imageFiles.add(file);
      } else {
        // Try to handle odd iOS filenames without extension as images.
        imageFiles.add(file);
      }
    }

    final liveVideoByBaseName = <String, XFile>{};
    for (final video in videoFiles) {
      if (_isLikelyLivePhotoVideo(video.path)) {
        liveVideoByBaseName[
            basenameWithoutExtension(video.name).toLowerCase()] = video;
      }
    }

    final consumedVideoPaths = <String>{};
    for (final image in imageFiles) {
      if (_isLikelyLivePhotoStill(image.path)) {
        final key = basenameWithoutExtension(image.name).toLowerCase();
        final pairedVideo = liveVideoByBaseName[key];
        if (pairedVideo != null) {
          final stillMedia = await _persistImage(image, imageQuality);
          final videoPath = await _persistRawMedia(pairedVideo);
          if (stillMedia != null && videoPath != null) {
            output.add(
              PickedEntryMedia(
                imgPath: stillMedia.imgPath,
                mediaType: EntryMediaType.livePhoto,
                videoPath: videoPath,
              ),
            );
            consumedVideoPaths.add(pairedVideo.path);
          }
          continue;
        }
      }

      final media = await _persistImage(image, imageQuality);
      if (media != null) {
        output.add(media);
      }
    }

    for (final video in videoFiles) {
      if (consumedVideoPaths.contains(video.path)) {
        continue;
      }
      final media = await _persistVideo(video);
      if (media != null) {
        output.add(media);
      }
    }

    for (final file in pickedFiles) {
      await _cleanupPickedFile(file);
    }

    return output;
  }

  Future<PickedEntryMedia?> _persistImage(XFile file, String quality) async {
    final imageName = await ImageStorage.instance.create(
      file.name,
      await _compressImage(file, quality),
    );
    if (imageName == null) return null;
    return PickedEntryMedia(
      imgPath: imageName,
      mediaType: EntryMediaType.image,
    );
  }

  Future<PickedEntryMedia?> _persistVideo(XFile file) async {
    final videoPath = await _persistRawMedia(file);
    if (videoPath == null) {
      return null;
    }
    final thumbnailPath = await _persistVideoThumbnail(file) ?? videoPath;

    return PickedEntryMedia(
      imgPath: thumbnailPath,
      mediaType: EntryMediaType.video,
      videoPath: videoPath,
    );
  }

  Future<String?> _persistRawMedia(XFile file) async {
    return ImageStorage.instance.create(file.name, await file.readAsBytes());
  }

  Future<String?> _persistVideoThumbnail(XFile file) async {
    final bytes = await VideoThumbnail.thumbnailData(
      video: file.path,
      imageFormat: ImageFormat.JPEG,
      quality: 70,
      maxWidth: 800,
    );
    if (bytes == null) {
      return null;
    }
    return ImageStorage.instance.create(
      '${basenameWithoutExtension(file.name)}_thumb.jpg',
      bytes,
    );
  }

  Future<void> _cleanupPickedFile(XFile file) async {
    if (!(Platform.isAndroid || Platform.isIOS)) {
      return;
    }
    final tmpFile = File(file.path);
    if (await tmpFile.exists()) {
      await tmpFile.delete();
    }
  }

  bool _isVideoPath(String path) =>
      _videoExtensions.contains(extension(path).toLowerCase());

  bool _isImagePath(String path) =>
      _imageExtensions.contains(extension(path).toLowerCase());

  bool _isLikelyLivePhotoStill(String path) =>
      Platform.isIOS &&
      const {'.heic', '.heif', '.jpg', '.jpeg'}
          .contains(extension(path).toLowerCase());

  bool _isLikelyLivePhotoVideo(String path) =>
      Platform.isIOS && extension(path).toLowerCase() == '.mov';

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
