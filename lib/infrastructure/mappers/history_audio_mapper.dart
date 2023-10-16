import 'package:dio/dio.dart';

import '../../domain/entities/entities.dart';
import '../models/models.dart';

class HistoryAudioMapper {
  static Map<String, dynamic> fromAudioCreationToMap(
      AudioCreation audioCreation) {
    if (audioCreation.needsUrlGen) {
      final multiPartFile = MultipartFile.fromBytes(
        audioCreation.audioFile!,
        filename: audioCreation.audioName!,
      );
      return {
        'audioUri': null,
        'audioFile': multiPartFile,
        'needsUrlGen': audioCreation.needsUrlGen,
      };
    } else {
      return {
        'audioUri': audioCreation.audioUri!,
        'audioFile': null,
        'needsUrlGen': audioCreation.needsUrlGen,
      };
    }
  }

  static HistoryAudio fromAudioResponseToHistoryAudio(
      AudioResponse audioResponse) {
    return HistoryAudio(
      id: audioResponse.id,
      audioUri: audioResponse.audioUri,
      needsUrlGen: audioResponse.needsUrlGen,
      historyId: audioResponse.historyId,
    );
  }
}
