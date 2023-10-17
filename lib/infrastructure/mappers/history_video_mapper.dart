import '../../domain/entities/entities.dart';
import '../models/models.dart';

class HistoryVideoMapper {
  static Map<String, dynamic> fromVideoCreationToMap(
      VideoCreation videoCreation) {
    return {
      'videoUri': videoCreation.videoUri!,
      'needsUrlGen': videoCreation.needsUrlGen,
    };
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
