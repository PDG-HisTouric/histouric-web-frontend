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

class HistoryVideoAdded extends HistoryEvent {
  final HistoryVideo video;

  HistoryVideoAdded({required this.video});
}

class HistoryVideoRemoved extends HistoryEvent {
  final HistoryVideo video;

  HistoryVideoRemoved({required this.video});
}

class VideoUrlChanged extends HistoryEvent {
  final String videoUrl;
  final String id;

  VideoUrlChanged({required this.videoUrl, required this.id});
}

class HistoryTextAdded extends HistoryEvent {
  final HistoryText text;

  HistoryTextAdded({required this.text});
}

class HistoryTextRemoved extends HistoryEvent {
  final HistoryText text;

  HistoryTextRemoved({required this.text});
}

class TextContentChanged extends HistoryEvent {
  final String content;
  final String id;

  TextContentChanged({required this.content, required this.id});
}

class TextStartTimeChanged extends HistoryEvent {
  final int startTime;
  final String id;

  TextStartTimeChanged({required this.startTime, required this.id});
}
