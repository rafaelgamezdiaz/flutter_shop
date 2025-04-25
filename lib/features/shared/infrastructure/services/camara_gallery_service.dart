abstract class CamaraGalleryService {
  Future<String?> takePhoto();
  Future<String?> pickImageFromGallery();

  // Future<String?> pickVideoFromGallery();
  // Future<String?> takeVideo();
  // Future<String?> pickFileFromGallery();
  // Future<String?> takeFile();
  // Future<bool> deleteFile(String filePath);
  // Future<bool> deleteFiles(List<String> filePaths);
  // Future<bool> deleteAllFiles();
  // Future<List<String>> getAllFiles();
  // Future<List<String>> getAllImages();
  // Future<List<String>> getAllVideos();
  // Future<List<String>> getAllFilesByType(String type);
}
