import 'dart:io';

import 'package:daily_you/database/app_database.dart';
import 'package:daily_you/database/image_storage.dart';
import 'package:daily_you/file_layer.dart';
import 'package:daily_you/utils/zip_utils.dart';
import 'package:flutter/material.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class BackupRestoreUtils {
  static Future<bool> backupToZip(
      BuildContext context, void Function(String) updateStatus) async {
    final l10n = AppLocalizations.of(context)!;
    String? savePath;
    try {
      savePath = await FileLayer.pickDirectory();
    } catch (e) {
      updateStatus("$e");
      await Future.delayed(Duration(seconds: 5));
      return false;
    }
    if (savePath == null) return false;

    var tempDir = await getTemporaryDirectory();

    final exportedZipName =
        "daily_you_backup_${DateTime.now().toIso8601String().replaceAll(':', '-')}.zip";

    // Create archive
    updateStatus(l10n.creatingBackupStatus("0"));
    await ZipUtils.compress(join(tempDir.path, exportedZipName), [
      await AppDatabase.instance.getInternalPath()
    ], [
      await ImageStorage.instance.getInternalFolder()
    ], onProgress: (percent) {
      updateStatus(l10n.creatingBackupStatus("${percent.round()}"));
    });

    // Save archive
    updateStatus(l10n.tranferStatus("0"));
    await FileLayer.copyToExternalLocation(
        join(tempDir.path, exportedZipName), savePath, exportedZipName,
        onProgress: (percent) {
      updateStatus(l10n.tranferStatus("${percent.round()}"));
    });

    // Delete temp files
    updateStatus(l10n.cleanUpStatus);
    await File(join(tempDir.path, exportedZipName)).delete();

    return true;
  }

  static Future<bool> restoreFromZip(
      BuildContext context, void Function(String) updateStatus) async {
    final l10n = AppLocalizations.of(context)!;
    var importSuccessful = true;

    String? archive = await FileLayer.pickFile(
        allowedExtensions: ['zip'], mimeTypes: ['application/zip']);

    if (archive == null) return false;

    var tempDir = await getTemporaryDirectory();

    final tempZipName = "temp_backup.zip";

    // Import archive
    updateStatus(l10n.tranferStatus("0"));
    await FileLayer.copyFromExternalLocation(archive, tempDir.path, tempZipName,
        onProgress: (percent) {
      updateStatus(l10n.tranferStatus("${percent.round()}"));
    });

    // Restore archive
    updateStatus(l10n.restoringBackupStatus("0"));
    final restoreFolder = Directory(join(tempDir.path, "Restore"));
    await restoreFolder.create(recursive: true);

    await ZipUtils.extract(join(tempDir.path, tempZipName), restoreFolder.path,
        onProgress: (percent) {
      updateStatus(l10n.restoringBackupStatus("${percent.round()}"));
    });

    final tempDb = File(join(restoreFolder.path, 'daily_you.db'));
    if (await tempDb.exists()) {
      // Import database
      await AppDatabase.instance.close();
      await File(await AppDatabase.instance.getInternalPath())
          .writeAsBytes(await tempDb.readAsBytes());
      await AppDatabase.instance.open();
      await AppDatabase.instance.updateExternalDatabase();

      // Import images. These will be garbage collected after import
      if (await Directory(join(restoreFolder.path, "Images")).exists()) {
        // Also show cleanup status here since images may take awhile
        updateStatus(l10n.cleanUpStatus);
        var files = Directory(join(restoreFolder.path, "Images")).list();
        final internalImagePath =
            await ImageStorage.instance.getInternalFolder();
        await for (FileSystemEntity fileEntity in files) {
          if (fileEntity is File) {
            await File(join(internalImagePath, basename(fileEntity.path)))
                .writeAsBytes(await fileEntity.readAsBytes());
          }
        }
        if (ImageStorage.instance.usingExternalLocation()) {
          await ImageStorage.instance.syncImageFolder(true);
        }
      }
    } else {
      importSuccessful = false;
    }

    // Delete temp files
    updateStatus(l10n.cleanUpStatus);
    await File(join(tempDir.path, tempZipName)).delete();
    if (await restoreFolder.exists()) {
      await restoreFolder.delete(recursive: true);
    }

    return importSuccessful;
  }

  static void showLoadingStatus(
      BuildContext context, ValueNotifier<String> statusNotifier) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: Dialog(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  ValueListenableBuilder<String>(
                    valueListenable: statusNotifier,
                    builder: (context, message, child) {
                      return Text(message, textAlign: TextAlign.center);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
