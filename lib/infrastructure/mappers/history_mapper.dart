import 'package:histouric_web/domain/entities/entities.dart';

import '../models/models.dart';
import 'history_audio_mapper.dart';
import 'history_image_mapper.dart';
import 'history_text_mapper.dart';
import 'history_video_mapper.dart';

class HistoryMapper {
  static Map<String, dynamic> fromHistoryCreationToMap(
      HistoryCreation historyCreation) {
    List<Map<String, dynamic>> texts = [];
    for (int i = 0; i < historyCreation.texts.length; i++) {
      var text = historyCreation.texts[i];
      texts.add(HistoryTextMapper.fromTextCreationToMap(text));
    }

    List<Map<String, dynamic>> images = [];
    for (int i = 0; i < historyCreation.images.length; i++) {
      var image = historyCreation.images[i];
      images.add(HistoryImageMapper.fromHistoryImageCreationToMap(image));
    }

    List<Map<String, dynamic>> videos = [];
    for (int i = 0; i < historyCreation.videos.length; i++) {
      var video = historyCreation.videos[i];
      videos.add(HistoryVideoMapper.fromVideoCreationToMap(video));
    }
    return {
      'title': historyCreation.title,
      'audio': HistoryAudioMapper.fromAudioCreationToMap(historyCreation.audio),
      'owner': historyCreation.owner,
      'videos': videos,
      'texts': texts,
      'images': images,
    };
  }

  static Story fromHistoryResponseToHistory(HistoryResponse historyResponse) {
    return Story(
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
