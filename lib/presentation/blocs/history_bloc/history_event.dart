part of 'history_bloc.dart';

abstract class HistoryEvent {}

class HistoryAudioUrlChanged extends HistoryEvent {
  final String audioUrl;

  HistoryAudioUrlChanged({required this.audioUrl});
}

class HistoryImageAdded extends HistoryEvent {
  final HistoryImage historyImage;

  HistoryImageAdded({required this.historyImage});
}

class HistoryImageRemoved extends HistoryEvent {
  final String historyImageId;

  HistoryImageRemoved({required this.historyImageId});
}

class ImageUriChanged extends HistoryEvent {
  final String imageUri;
  final String id;

  ImageUriChanged({required this.imageUri, required this.id});
}

class ImageStartTimeChanged extends HistoryEvent {
  final int startTime;
  final String id;

  ImageStartTimeChanged({required this.startTime, required this.id});
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
