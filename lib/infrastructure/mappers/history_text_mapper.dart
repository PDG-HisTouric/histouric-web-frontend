import '../../domain/entities/entities.dart';
import '../models/models.dart';

class HistoryTextMapper {
  static Map<String, dynamic> fromTextCreationToMap(TextCreation textCreation) {
    return {
      'content': textCreation.content,
      'startTime': textCreation.startTime,
    };
  }

  static HistoryText fromTextResponseToHistoryText(TextResponse textResponse) {
    return HistoryText(
      id: textResponse.id,
      content: textResponse.content,
      startTime: textResponse.startTime,
      historyId: textResponse.historyId,
    );
  }
}
