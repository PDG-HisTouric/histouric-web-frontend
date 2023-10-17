import 'dart:typed_data';

import 'package:histouric_web/domain/domain.dart';

class FirebaseStorageRepositoryImpl implements FirebaseStorageRepository {
  final FirebaseStorageDatasource firebaseStorageDataSource;

  FirebaseStorageRepositoryImpl({required this.firebaseStorageDataSource});

  @override
  void configureToken(String token) {
    firebaseStorageDataSource.configureToken(token);
  }

  @override
  Future<List<String>> uploadAudios(
    List<Uint8List> audios,
    List<String> names,
  ) {
    return firebaseStorageDataSource.uploadAudios(audios, names);
  }

  @override
  Future<List<String>> uploadImages(
    List<Uint8List> images,
    List<String> names,
  ) {
    return firebaseStorageDataSource.uploadImages(images, names);
  }

  @override
  Future<List<String>> uploadVideos(
    List<Uint8List> videos,
    List<String> names,
  ) {
    return firebaseStorageDataSource.uploadVideos(videos, names);
  }
}
