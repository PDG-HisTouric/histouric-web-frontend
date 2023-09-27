class HistoryVideo {
  final String? id;
  final String videoUrl;
  final int startTime;
  final String? historyId;

  HistoryVideo({
    this.id,
    required this.videoUrl,
    required this.startTime,
    this.historyId,
  });
}
