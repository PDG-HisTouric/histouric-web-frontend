part of 'history_bloc.dart';

class HistoryState {
  final String? historyId;
  final String? title;
  final AudioState audioState;
  final String owner;
  final List<ImageEntryState> imageEntryStates;
  final List<HistoryVideo>? historyVideos;
  final List<HistoryText>? historyTexts;

  HistoryState({
    this.historyId,
    this.title,
    required this.audioState,
    required this.owner,
    this.historyVideos,
    this.historyTexts,
    this.imageEntryStates = const [],
  });

  HistoryState copyWith({
    String? historyId,
    String? title,
    AudioState? audioState,
    String? owner,
    List<HistoryVideo>? historyVideos,
    List<HistoryText>? historyTexts,
    List<ImageEntryState>? imageEntryStates,
  }) {
    return HistoryState(
      historyId: historyId ?? this.historyId,
      title: title ?? this.title,
      audioState: audioState ?? this.audioState,
      owner: owner ?? this.owner,
      historyVideos: historyVideos ?? this.historyVideos,
      historyTexts: historyTexts ?? this.historyTexts,
      imageEntryStates: imageEntryStates ?? this.imageEntryStates,
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

class ImageEntryState {
  final String id;
  final String minute;
  final bool imageChosen;
  final List<Uint8List> images;
  final List<String> imagesNames;
  final List<String> imagesExtensions;
  final bool isImageFromFilePicker;
  final List<HistouricImageInfo> imagesInfo;
  late final TextEditingController minuteController;

  ImageEntryState({
    required this.id,
    this.minute = '',
    this.imageChosen = false,
    this.images = const [],
    this.imagesNames = const [],
    this.imagesExtensions = const [],
    this.isImageFromFilePicker = false,
    this.imagesInfo = const [],
  });

  ImageEntryState copyWith({
    String? minute,
    bool? imageChosen,
    List<Uint8List>? images,
    List<String>? imagesNames,
    List<String>? imagesExtensions,
    bool? isImageFromFilePicker,
    List<HistouricImageInfo>? imagesInfo,
  }) {
    return ImageEntryState(
      id: id,
      minute: minute ?? this.minute,
      imageChosen: imageChosen ?? this.imageChosen,
      images: images ?? this.images,
      imagesNames: imagesNames ?? this.imagesNames,
      imagesExtensions: imagesExtensions ?? this.imagesExtensions,
      isImageFromFilePicker:
          isImageFromFilePicker ?? this.isImageFromFilePicker,
      imagesInfo: imagesInfo ?? this.imagesInfo,
    )..minuteController = minuteController;
  }

  ImageEntryState configureControllers({
    String? minuteText,
  }) {
    return ImageEntryState(
      id: id,
      minute: minute,
      imageChosen: imageChosen,
      images: images,
      imagesNames: imagesNames,
      imagesExtensions: imagesExtensions,
      isImageFromFilePicker: isImageFromFilePicker,
      imagesInfo: imagesInfo,
    )..minuteController = TextEditingController(text: minuteText ?? minute);
  }
}
