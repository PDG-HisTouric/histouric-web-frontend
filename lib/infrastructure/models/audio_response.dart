import 'dart:typed_data';

class AudioResponse {
  final String id;
  final String audioUri;
  final bool needsUrlGen;
  final String historyId;

  AudioResponse({
    required this.id,
    required this.audioUri,
    required this.needsUrlGen,
    required this.historyId,
  });

  factory AudioResponse.fromJson(Map<String, dynamic> json) => AudioResponse(
        id: json["id"],
        audioUri: json["audioUri"],
        needsUrlGen: json["needsUrlGen"],
        historyId: json["historyId"],
      );
}
