part of 'history_bloc.dart';

abstract class HistoryEvent {}

class HistoryAudioStateChanged extends HistoryEvent {
  final String? src;
  final Uint8List? audio;
  final String? audioName;
  final String? audioExtension;
  final bool? isAudioFromFilePicker;

  HistoryAudioStateChanged({
    this.src,
    this.audio,
    this.audioName,
    this.audioExtension,
    this.isAudioFromFilePicker,
  });
}

class AddImageButtonPressed extends HistoryEvent {
  AddImageButtonPressed();
}

class ImageEntryStateChanged extends HistoryEvent {
  final ImageEntryState imageEntryState;

  ImageEntryStateChanged({required this.imageEntryState});
}

class RemoveImageEntryButtonPressed extends HistoryEvent {
  final String id;

  RemoveImageEntryButtonPressed({required this.id});
}

class AddTextSegmentButtonPressed extends HistoryEvent {
  AddTextSegmentButtonPressed();
}

class TextSegmentStateChanged extends HistoryEvent {
  final TextSegmentState textSegmentState;

  TextSegmentStateChanged({required this.textSegmentState});
}

class RemoveTextEntryButtonPressed extends HistoryEvent {
  final String id;

  RemoveTextEntryButtonPressed({required this.id});
}

class VideoFromFilePickerAdded extends HistoryEvent {
  final Uint8List video;
  final String extension;
  final String name;

  VideoFromFilePickerAdded(
      {required this.video, required this.extension, required this.name});
}

class VideoFromUrlAdded extends HistoryEvent {
  final String url;
  final double width;
  final double height;

  VideoFromUrlAdded({
    required this.url,
    required this.width,
    required this.height,
  });
}

class RemoveVideoEntryButtonPressed extends HistoryEvent {
  final String id;

  RemoveVideoEntryButtonPressed({required this.id});
}

class HistoryStatusChanged extends HistoryEvent {
  final HistoryStatus historyStatus;

  HistoryStatusChanged({required this.historyStatus});
}

class HistoryNameChanged extends HistoryEvent {
  final String name;

  HistoryNameChanged({required this.name});
}
