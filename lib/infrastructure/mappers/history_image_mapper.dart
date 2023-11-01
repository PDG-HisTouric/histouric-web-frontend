import '../../domain/entities/entities.dart';
import '../models/models.dart';

class HistoryImageMapper {
  static Map<String, dynamic> fromHistoryImageCreationToMap(
      HistoryImageCreation historyImageCreation) {
    return {
      'imageUri': historyImageCreation.imageUri!,
      'startTime': historyImageCreation.startTime,
      'needsUrlGen': historyImageCreation.needsUrlGen,
    };
  }

  static HistoryImage fromHistoryImageResponseToHistoryImage(
      HistoryImageResponse historyImageResponse) {
    return HistoryImage(
      id: historyImageResponse.id,
      imageUri: historyImageResponse.imageUri,
      startTime: historyImageResponse.startTime,
      historyId: historyImageResponse.historyId,
    );
  }
}
