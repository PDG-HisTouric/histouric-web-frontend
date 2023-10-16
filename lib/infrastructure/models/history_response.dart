import 'package:histouric_web/infrastructure/models/audio_response.dart';
import 'package:histouric_web/infrastructure/models/video_response.dart';

import 'history_image_response.dart';
import 'text_response.dart';

class HistoryResponse {
  final String id;
  final String title;
  final AudioResponse audio;
  final String owner;
  final List<VideoResponse>? videos;
  final List<TextResponse> texts;
  final List<HistoryImageResponse>? images;

  HistoryResponse({
    required this.id,
    required this.title,
    required this.audio,
    required this.owner,
    this.videos,
    required this.texts,
    this.images,
  });

  factory HistoryResponse.fromJson(Map<String, dynamic> json) =>
      HistoryResponse(
        id: json["id"],
        title: json["title"],
        audio: AudioResponse.fromJson(json["audio"]),
        owner: json["owner"],
        videos: json["videos"] != null
            ? (json["videos"] as List)
                .map((video) => VideoResponse.fromJson(video))
                .toList()
            : null,
        texts: (json["texts"] as List)
            .map((text) => TextResponse.fromJson(text))
            .toList(),
        images: json["images"] != null
            ? (json["images"] as List)
                .map((image) => HistoryImageResponse.fromJson(image))
                .toList()
            : null,
      );
}
