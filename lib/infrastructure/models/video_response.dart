
class VideoResponse {
  final String id;
  final String videoUri;
  final bool needsUrlGen;
  final String historyId;

  VideoResponse({
    required this.id,
    required this.videoUri,
    required this.needsUrlGen,
    required this.historyId,
  });

  factory VideoResponse.fromJson(Map<String, dynamic> json) => VideoResponse(
        id: json["id"],
        videoUri: json["videoUri"],
        needsUrlGen: json["needsUrlGen"],
        historyId: json["historyId"],
      );
}
