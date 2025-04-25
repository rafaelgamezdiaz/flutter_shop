import 'package:image_picker/image_picker.dart';
import 'camara_gallery_service.dart';

class CamaraGalleryServiceImplementation extends CamaraGalleryService {
  Future<String?> _imageFunction({
    ImageSource source = ImageSource.gallery,
    int quality = 80,
    CameraDevice cameraDevice = CameraDevice.rear,
  }) async {
    final ImagePicker picker = ImagePicker();

    final XFile? photo = await picker.pickImage(
      source: source,
      imageQuality: quality,
      preferredCameraDevice: cameraDevice,
    );

    if (photo == null) return null;

    return photo.path;
  }

  @override
  Future<String?> pickImageFromGallery() async {
    return await _imageFunction(
      source: ImageSource.gallery,
      quality: 80,
      cameraDevice: CameraDevice.rear,
    );
  }

  @override
  Future<String?> takePhoto() async {
    return await _imageFunction(
      source: ImageSource.camera,
      quality: 80,
      cameraDevice: CameraDevice.rear,
    );
  }
}
