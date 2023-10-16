import 'audio_creation.dart';
import 'history_image_creation.dart';
import 'text_creation.dart';
import 'video_creation.dart';

class HistoryCreation {
  final String title;
  final AudioCreation audio;
  final String owner;
  final List<VideoCreation>? videos;
  final List<TextCreation> texts;
  final List<HistoryImageCreation>? images;

  HistoryCreation({
    required this.title,
    required this.audio,
    required this.owner,
    this.videos,
    required this.texts,
    this.images,
  });
}
