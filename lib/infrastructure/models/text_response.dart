class TextResponse {
  final String id;
  final String content;
  final int startTime;
  final String historyId;

  TextResponse({
    required this.id,
    required this.content,
    required this.startTime,
    required this.historyId,
  });

  factory TextResponse.fromJson(Map<String, dynamic> json) => TextResponse(
        id: json["id"],
        content: json["content"],
        startTime: json["startTime"],
        historyId: json["historyId"],
      );
}
