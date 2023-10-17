import '../../domain/entities/entities.dart';
import '../models/models.dart';

class HistoryAudioMapper {
  static Map<String, dynamic> fromAudioCreationToMap(
      AudioCreation audioCreation) {
    return {
      'audioUri': audioCreation.audioUri,
      'needsUrlGen': audioCreation.needsUrlGen,
    };
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
