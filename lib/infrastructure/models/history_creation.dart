import 'audio_creation.dart';
import 'history_image_creation.dart';
import 'text_creation.dart';
import 'video_creation.dart';

class HistoryCreation {
  final String title;
  final AudioCreation audio;
  final String owner;
  final List<VideoCreation> videos;
  final List<TextCreation> texts;
  final List<HistoryImageCreation> images;

  HistoryCreation({
    required this.title,
    required this.audio,
    required this.owner,
    this.videos = const [],
    required this.texts,
    this.images = const [],
  });

  HistoryCreation copyWith({
    String? title,
    AudioCreation? audio,
    String? owner,
    List<VideoCreation>? videos,
    List<TextCreation>? texts,
    List<HistoryImageCreation>? images,
  }) {
    return HistoryCreation(
      title: title ?? this.title,
      audio: audio ?? this.audio,
      owner: owner ?? this.owner,
      videos: videos ?? this.videos,
      texts: texts ?? this.texts,
      images: images ?? this.images,
    );
  }
}
