import 'dart:typed_data';

abstract class ExternalRepository {
  Future<String?> uploadImage(String fileName, Uint8List image);
  Future<String?> uploadVideo(String fileName, Uint8List video);
  Future<String?> uploadAudio(String fileName, Uint8List audio);
}
