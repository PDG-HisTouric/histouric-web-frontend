import 'history_image.dart';
import 'history_text.dart';
import 'history_video.dart';

class BICHistory {
  final String? historyId;
  final String title;
  final String audioUrl;
  final String owner;
  final List<HistoryVideo>? videos;
  final List<HistoryText> texts;
  final List<HistoryImage>? images;

  BICHistory({
    this.historyId,
    required this.title,
    required this.audioUrl,
    required this.owner,
    this.videos,
    required this.texts,
    this.images,
  });
}
