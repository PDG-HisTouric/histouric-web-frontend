class HistoryImage {
  final String id;
  final String imageUri;
  final int startTime;
  final bool needsUrlGen;
  final String historyId;

  HistoryImage({
    required this.id,
    required this.imageUri,
    required this.startTime,
    required this.needsUrlGen,
    required this.historyId,
  });
}
