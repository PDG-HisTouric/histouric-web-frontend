import 'package:dio/dio.dart';

import '../../domain/entities/entities.dart';
import '../models/models.dart';

class HistoryVideoMapper {
  static Map<String, dynamic> fromVideoCreationToMap(
      VideoCreation videoCreation) {
    if (videoCreation.needsUrlGen) {
      final multiPartFile = MultipartFile.fromBytes(
        videoCreation.videoFile!,
        filename: videoCreation.videoName!,
      );
      return {
        'videoUri': null,
        'videoFile': multiPartFile,
        'needsUrlGen': videoCreation.needsUrlGen,
      };
    } else {
      return {
        'videoUri': videoCreation.videoUri!,
        'videoFile': null,
        'needsUrlGen': videoCreation.needsUrlGen,
      };
    }
  }

  static HistoryVideo fromVideoResponseToHistoryVideo(
      VideoResponse videoResponse) {
    return HistoryVideo(
      id: videoResponse.id,
      videoUri: videoResponse.videoUri,
      needsUrlGen: videoResponse.needsUrlGen,
      historyId: videoResponse.historyId,
    );
  }
}
