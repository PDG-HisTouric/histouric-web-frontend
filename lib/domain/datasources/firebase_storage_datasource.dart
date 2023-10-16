import 'dart:typed_data';

abstract class FirebaseStorageDatasource {
  Future<List<String>> uploadImages(List<Uint8List> images, List<String> names);
  Future<List<String>> uploadAudios(List<Uint8List> audios, List<String> names);
  Future<List<String>> uploadVideos(List<Uint8List> videos, List<String> names);
  void configureToken(String token);
}
