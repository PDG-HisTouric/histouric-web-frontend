import 'package:dio/dio.dart';
import 'package:histouric_web/domain/domain.dart';
import 'package:histouric_web/infrastructure/infrastructure.dart';

import '../../config/constants/environment.dart';

class HistoryDatasourceImpl implements HistoryDatasource {
  final FirebaseStorageRepository? firebaseStorageRepository;

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: '${Environment.baseUrl}/api/v1/histories',
      contentType: 'application/json',
    ),
  );

  HistoryDatasourceImpl({this.firebaseStorageRepository});

  @override
  void configureToken(String token) {
    dio.options.headers = {'Authorization': 'Bearer $token'};
    firebaseStorageRepository?.configureToken(token);
  }

  @override
  Future<History> createHistory(HistoryCreation historyCreation) async {
    HistoryCreation historyCreationWithDataSavedInFirebaseStorage =
        await _saveHistoryDataInFirebaseStorage(historyCreation);
    final data = HistoryMapper.fromHistoryCreationToMap(
      historyCreationWithDataSavedInFirebaseStorage,
    );
    return dio.post('', data: data).then((value) =>
        HistoryMapper.fromHistoryResponseToHistory(
            HistoryResponse.fromJson(value.data)));
  }

  Future<HistoryCreation> _saveHistoryDataInFirebaseStorage(
      HistoryCreation historyCreation) async {
    List<HistoryImageCreation> imagesToUpload = [];
    for (int i = 0; i < historyCreation.images.length; i++) {
      var image = historyCreation.images[i];
      if (!image.needsUrlGen) continue;
      imagesToUpload.add(image);
    }

    List<VideoCreation> videosToUpload = [];
    for (int i = 0; i < historyCreation.videos.length; i++) {
      var video = historyCreation.videos[i];
      if (!video.needsUrlGen) continue;
      videosToUpload.add(video);
    }

    List<AudioCreation> audiosToUpload = [];
    if (historyCreation.audio.needsUrlGen) {
      audiosToUpload.add(historyCreation.audio);
    }

    List<String> newImagesUris = [];
    if (imagesToUpload.isNotEmpty) {
      newImagesUris = await firebaseStorageRepository!.uploadImages(
        imagesToUpload.map((e) => e.imageFile!).toList(),
        imagesToUpload.map((e) => e.imageName!).toList(),
      );
    }

    List<String> newVideosUris = [];
    if (videosToUpload.isNotEmpty) {
      newVideosUris = await firebaseStorageRepository!.uploadVideos(
        videosToUpload.map((e) => e.videoFile!).toList(),
        videosToUpload.map((e) => e.videoName!).toList(),
      );
    }

    List<String> newAudiosUris = [];
    if (audiosToUpload.isNotEmpty) {
      newAudiosUris = await firebaseStorageRepository!.uploadAudios(
        audiosToUpload.map((e) => e.audioFile!).toList(),
        audiosToUpload.map((e) => e.audioName!).toList(),
      );
    }

    List<HistoryImageCreation> newImages = historyCreation.images;
    for (int i = 0; i < newImages.length; i++) {
      var image = newImages[i];
      if (!image.needsUrlGen) continue;
      newImages[i] = image.copyWith(imageUri: newImagesUris.removeAt(0));
    }

    List<VideoCreation> newVideos = historyCreation.videos;
    for (int i = 0; i < newVideos.length; i++) {
      var video = newVideos[i];
      if (!video.needsUrlGen) continue;
      newVideos[i] = video.copyWith(videoUri: newVideosUris.removeAt(0));
    }

    AudioCreation newAudio = historyCreation.audio;
    if (newAudio.needsUrlGen) {
      newAudio = newAudio.copyWith(audioUri: newAudiosUris.removeAt(0));
    }

    return historyCreation.copyWith(
      images: newImages,
      videos: newVideos,
      audio: newAudio,
    );
  }

  @override
  Future<List<History>> getHistoriesByTitle(String title) {
    return dio.get('/title/$title').then((value) => value.data
        .map<History>(
            (history) => HistoryMapper.fromHistoryResponseToHistory(history))
        .toList());
  }
}
