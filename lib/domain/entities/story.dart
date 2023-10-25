import 'history_audio.dart';
import 'history_image.dart';
import 'history_text.dart';
import 'history_video.dart';

class Story {
  final String id;
  final String title;
  final HistoryAudio audio;
  final String owner;
  final List<HistoryVideo>? videos;
  final List<HistoryText> texts;
  final List<HistoryImage>? images;

  Story({
    required this.id,
    required this.title,
    required this.audio,
    required this.owner,
    this.videos,
    required this.texts,
    this.images,
  });
}
