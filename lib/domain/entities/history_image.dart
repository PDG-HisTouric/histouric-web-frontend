class HistoryImage {
  final String? id;
  final String imageUri;
  final int startTime;
  final String? historyId;

  HistoryImage({
    this.id,
    required this.imageUri,
    required this.startTime,
    this.historyId,
  });
}
