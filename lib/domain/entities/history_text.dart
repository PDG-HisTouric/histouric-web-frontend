class HistoryText {
  final String? id;
  final String content;
  final int startTime;
  final String? historyId;

  HistoryText({
    this.id,
    required this.content,
    required this.startTime,
    this.historyId,
  });
}
