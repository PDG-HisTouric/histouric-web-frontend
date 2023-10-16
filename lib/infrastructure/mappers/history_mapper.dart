import 'package:histouric_web/domain/entities/entities.dart';

import '../models/models.dart';
import 'history_audio_mapper.dart';
import 'history_image_mapper.dart';
import 'history_text_mapper.dart';
import 'history_video_mapper.dart';

class HistoryMapper {
  static Map<String, dynamic> fromHistoryCreatioToMap(
      HistoryCreation historyCreation) {
    return {
      'title': historyCreation.title,
      'audio': HistoryAudioMapper.fromAudioCreationToMap(historyCreation.audio),
      'owner': historyCreation.owner,
      'videos': historyCreation.videos
          ?.map((video) => {
                HistoryVideoMapper.fromVideoCreationToMap(video),
              })
          .toList(),
      'texts': historyCreation.texts
          .map((text) => {
                HistoryTextMapper.fromTextCreationToMap(text),
              })
          .toList(),
      'images': historyCreation.images
          ?.map((image) => {
                HistoryImageMapper.fromHistoryImageCreationToMap(image),
              })
          .toList(),
    };
  }

  static History fromHistoryResponseToHistory(HistoryResponse historyResponse) {
    return History(
      id: historyResponse.id,
      title: historyResponse.title,
      audio: HistoryAudioMapper.fromAudioResponseToHistoryAudio(
          historyResponse.audio),
      owner: historyResponse.owner,
      videos: historyResponse.videos
          ?.map((video) =>
              HistoryVideoMapper.fromVideoResponseToHistoryVideo(video))
          .toList(),
      texts: historyResponse.texts
          .map((text) => HistoryTextMapper.fromTextResponseToHistoryText(text))
          .toList(),
      images: historyResponse.images
          ?.map((image) =>
              HistoryImageMapper.fromHistoryImageResponseToHistoryImage(image))
          .toList(),
    );
  }
}
