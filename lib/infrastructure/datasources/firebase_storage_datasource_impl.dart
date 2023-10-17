import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../config/constants/constants.dart';
import '../../domain/datasources/datasources.dart';

class FirebaseStorageDatasourceImpl implements FirebaseStorageDatasource {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: '${Environment.baseUrl}/api/v1/firebase-storage',
      contentType: 'application/json',
    ),
  );

  @override
  void configureToken(String token) {
    dio.options.headers = {'Authorization': 'Bearer $token'};
  }

  @override
  Future<List<String>> uploadAudios(
    List<Uint8List> audios,
    List<String> names,
  ) {
    List<MultipartFile> multipartFiles = [];
    for (var i = 0; i < audios.length; i++) {
      multipartFiles
          .add(MultipartFile.fromBytes(audios[i], filename: names[i]));
    }
    FormData formData = FormData.fromMap({
      'files': multipartFiles,
    });
    return dio
        .post(
          '/audios',
          data: formData,
          options: Options(headers: {"Content-Type": "multipart/form-data"}),
        )
        .then((value) => List<String>.from(value.data));
  }

  @override
  Future<List<String>> uploadImages(
    List<Uint8List> images,
    List<String> names,
  ) {
    List<MultipartFile> multipartFiles = [];
    for (var i = 0; i < images.length; i++) {
      multipartFiles
          .add(MultipartFile.fromBytes(images[i], filename: names[i]));
    }
    FormData formData = FormData.fromMap({
      'files': multipartFiles,
    });
    return dio
        .post(
          '/images',
          data: formData,
          options: Options(headers: {"Content-Type": "multipart/form-data"}),
        )
        .then((value) => List<String>.from(value.data));
  }

  @override
  Future<List<String>> uploadVideos(
    List<Uint8List> videos,
    List<String> names,
  ) {
    List<MultipartFile> multipartFiles = [];
    for (var i = 0; i < videos.length; i++) {
      multipartFiles
          .add(MultipartFile.fromBytes(videos[i], filename: names[i]));
    }
    FormData formData = FormData.fromMap({
      'files': multipartFiles,
    });
    return dio
        .post(
          '/videos',
          data: formData,
          options: Options(headers: {"Content-Type": "multipart/form-data"}),
        )
        .then((value) => List<String>.from(value.data));
  }
}
