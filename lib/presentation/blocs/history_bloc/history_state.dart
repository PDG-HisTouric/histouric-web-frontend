part of 'history_bloc.dart';

class HistoryState {
  final String? historyId;
  final String? title;
  final String? audioUrl;
  final String owner;
  final List<HistoryVideo>? historyVideos;
  final List<HistoryText>? historyTexts;
  final List<HistoryImage>? historyImages;

  HistoryState({
    this.historyId,
    this.title,
    this.audioUrl,
    required this.owner,
    this.historyVideos,
    this.historyTexts,
    this.historyImages,
  });

  HistoryState copyWith({
    String? historyId,
    String? title,
    String? audioUrl,
    String? owner,
    List<HistoryVideo>? historyVideos,
    List<HistoryText>? historyTexts,
    List<HistoryImage>? historyImages,
  }) {
    return HistoryState(
      historyId: historyId ?? this.historyId,
      title: title ?? this.title,
      audioUrl: audioUrl ?? this.audioUrl,
      owner: owner ?? this.owner,
      historyVideos: historyVideos ?? this.historyVideos,
      historyTexts: historyTexts ?? this.historyTexts,
      historyImages: historyImages ?? this.historyImages,
    );
  }
}
