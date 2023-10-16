part of 'history_bloc.dart';

class HistoryState {
  final String? historyId;
  final String title;
  final AudioState audioState;
  final String owner;
  final List<ImageEntryState> imageEntryStates;
  final List<TextSegmentState> textSegmentStates;
  final List<VideoEntry> videoEntries;

  HistoryState({
    this.historyId,
    this.title = '',
    required this.audioState,
    required this.owner,
    this.imageEntryStates = const [],
    this.textSegmentStates = const [],
    this.videoEntries = const [],
  });

  HistoryState copyWith({
    String? historyId,
    String? title,
    AudioState? audioState,
    String? owner,
    List<VideoEntry>? videoEntries,
    List<TextSegmentState>? textSegmentStates,
    List<ImageEntryState>? imageEntryStates,
  }) {
    return HistoryState(
      historyId: historyId ?? this.historyId,
      title: title ?? this.title,
      audioState: audioState ?? this.audioState,
      owner: owner ?? this.owner,
      videoEntries: videoEntries ?? this.videoEntries,
      textSegmentStates: textSegmentStates ?? this.textSegmentStates,
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
    this.src = '',
    this.audio,
    this.audioName,
    this.audioExtension,
    this.isAudioFromFilePicker = false,
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

  int getSeconds() {
    if (minute.isNotEmpty) {
      List<String> parts = minute.split(':');
      int minutes = int.parse(parts[0]);
      int seconds = int.parse(parts[1]);
      return minutes * 60 + seconds;
    }
    return 0;
  }
}

class TextSegmentState {
  final String id;
  final String text;
  final String minute;
  late final TextEditingController textController;
  late final TextEditingController minuteController;

  TextSegmentState({
    required this.id,
    this.text = '',
    this.minute = '',
  });

  TextSegmentState copyWith({
    String? text,
    String? minute,
  }) {
    return TextSegmentState(
      id: id,
      text: text ?? this.text,
      minute: minute ?? this.minute,
    )
      ..textController = textController
      ..minuteController = minuteController;
  }

  TextSegmentState configureControllers({
    String? text,
    String? minute,
  }) {
    return TextSegmentState(
      id: id,
      text: text ?? this.text,
      minute: minute ?? this.minute,
    )
      ..textController = TextEditingController(text: text ?? this.text)
      ..minuteController = TextEditingController(text: minute ?? this.minute);
  }

  int getSeconds() {
    if (minute.isNotEmpty) {
      List<String> parts = minute.split(':');
      int minutes = int.parse(parts[0]);
      int seconds = int.parse(parts[1]);
      return minutes * 60 + seconds;
    }
    return 0;
  }
}
