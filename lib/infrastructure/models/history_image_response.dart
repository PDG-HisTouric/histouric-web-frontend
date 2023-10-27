
class HistoryImageResponse {
  final String id;
  final String imageUri;
  final int startTime;
  final bool needsUrlGen;
  final String historyId;

  HistoryImageResponse({
    required this.id,
    required this.imageUri,
    required this.startTime,
    required this.needsUrlGen,
    required this.historyId,
  });

  factory HistoryImageResponse.fromJson(Map<String, dynamic> json) =>
      HistoryImageResponse(
        id: json["id"],
        imageUri: json["imageUri"],
        startTime: json["startTime"],
        needsUrlGen: json["needsUrlGen"],
        historyId: json["historyId"],
      );
}
