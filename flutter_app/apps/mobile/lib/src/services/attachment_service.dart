import 'package:image_picker/image_picker.dart';

class AttachmentService {
  AttachmentService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  /// Captures defect photos locally. If [fromCamera] is true, launches the camera;
  /// otherwise, opens the gallery to select multiple photos.
  /// Returns a list of absolute file paths to the captured images.
  Future<List<String>> capturePhotos({required bool fromCamera}) async {
    if (fromCamera) {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85, // Compress slightly to save offline storage and bandwidth
      );
      if (image != null) {
        return [image.path];
      }
    } else {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 85,
      );
      return images.map((file) => file.path).toList();
    }
    return [];
  }
}
