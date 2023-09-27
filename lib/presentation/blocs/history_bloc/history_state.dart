part of 'history_bloc.dart';

class HistoryState {
  final String? historyId;
  final String? title;
  final AudioState audioState;
  final String owner;
  final List<HistoryVideo>? historyVideos;
  final List<HistoryText>? historyTexts;
  final List<HistoryImage>? historyImages;

  HistoryState({
    this.historyId,
    this.title,
    required this.audioState,
    required this.owner,
    this.historyVideos,
    this.historyTexts,
    this.historyImages,
  });

  HistoryState copyWith({
    String? historyId,
    String? title,
    AudioState? audioState,
    String? owner,
    List<HistoryVideo>? historyVideos,
    List<HistoryText>? historyTexts,
    List<HistoryImage>? historyImages,
  }) {
    return HistoryState(
      historyId: historyId ?? this.historyId,
      title: title ?? this.title,
      audioState: audioState ?? this.audioState,
      owner: owner ?? this.owner,
      historyVideos: historyVideos ?? this.historyVideos,
      historyTexts: historyTexts ?? this.historyTexts,
      historyImages: historyImages ?? this.historyImages,
    );
  }
}

class AudioState {
  final String src;
  final Uint8List? audio;
  final String? audioName;
  final String? audioExtension;
  final bool isAudioFromFilePicker;

  AudioState({
    required this.src,
    this.audio,
    this.audioName,
    this.audioExtension,
    required this.isAudioFromFilePicker,
  });

  AudioState copyWith({
    String? src,
    Uint8List? audio,
    String? audioName,
    String? audioExtension,
    bool? isAudioFromFilePicker,
  }) {
    return AudioState(
      src: src ?? this.src,
      audio: audio ?? this.audio,
      audioName: audioName ?? this.audioName,
      audioExtension: audioExtension ?? this.audioExtension,
      isAudioFromFilePicker:
          isAudioFromFilePicker ?? this.isAudioFromFilePicker,
    );
  }
}
