import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class AttachmentService {
  AttachmentService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  /// Captures defect photos locally. If [fromCamera] is true, launches the camera;
  /// otherwise, opens the gallery to select multiple photos.
  /// Always saves a permanent copy into the app's local storage directory.
  Future<List<String>> capturePhotos({required bool fromCamera}) async {
    final List<String> savedPaths = [];
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final Directory attachmentsDir = Directory('${appDir.path}/argus_attachments');
      if (!await attachmentsDir.exists()) {
        await attachmentsDir.create(recursive: true);
      }

      if (fromCamera) {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
        );
        if (image != null) {
          final String localPath = await _saveToLocalStorage(image.path, attachmentsDir);
          savedPaths.add(localPath);
        }
      } else {
        final List<XFile> images = await _picker.pickMultiImage(
          imageQuality: 85,
        );
        for (final img in images) {
          final String localPath = await _saveToLocalStorage(img.path, attachmentsDir);
          savedPaths.add(localPath);
        }
      }
    } catch (e) {
      debugPrint('AttachmentService: Exception during image selection: $e');
    }

    return savedPaths;
  }

  Future<String> _saveToLocalStorage(String tempPath, Directory targetDir) async {
    try {
      final File tempFile = File(tempPath);
      if (await tempFile.exists()) {
        final String fileName = 'photo_${DateTime.now().millisecondsSinceEpoch}_${const Uuid().v4().substring(0, 6)}.jpg';
        final String targetPath = '${targetDir.path}/$fileName';
        final File permanentFile = await tempFile.copy(targetPath);
        debugPrint('AttachmentService: Saved attachment to local storage -> ${permanentFile.path}');
        return permanentFile.path;
      }
    } catch (e) {
      debugPrint('AttachmentService: Error copying file to permanent local storage: $e');
    }
    return tempPath;
  }
}
