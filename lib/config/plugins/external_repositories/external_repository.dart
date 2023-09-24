import 'dart:typed_data';

abstract class ExternalRepository {
  Future<String?> uploadImage(String fileName, Uint8List image);
}
