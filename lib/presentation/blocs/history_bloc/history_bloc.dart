import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

import '../../../domain/entities/entities.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final String owner;
  HistoryBloc({required this.owner})
      : super(HistoryState(
            owner: owner,
            audioState: AudioState(src: '', isAudioFromFilePicker: false))) {
    on<HistoryAudioStateChanged>(_onHistoryAudioStateChanged);
    on<HistoryImageAdded>(_onHistoryImageAdded);
    on<HistoryImageRemoved>(_onHistoryImageRemoved);
  }

  void _onHistoryAudioStateChanged(
      HistoryAudioStateChanged event, Emitter<HistoryState> emit) {
    final newAudioState = state.audioState.copyWith(
      src: event.src,
      audio: event.audio,
      audioName: event.audioName,
      audioExtension: event.audioExtension,
      isAudioFromFilePicker: event.isAudioFromFilePicker,
    );
    emit(state.copyWith(audioState: newAudioState));
  }

  void changeAudioState({
    String? src,
    Uint8List? audio,
    String? audioName,
    String? audioExtension,
    bool? isAudioFromFilePicker,
  }) {
    add(HistoryAudioStateChanged(
      src: src,
      audio: audio,
      audioName: audioName,
      audioExtension: audioExtension,
      isAudioFromFilePicker: isAudioFromFilePicker,
    ));
  }

  void _onHistoryImageAdded(
      HistoryImageAdded event, Emitter<HistoryState> emit) {
    final List<HistoryImage> historyImages = state.historyImages!;
    historyImages.add(event.historyImage);
    emit(state.copyWith(historyImages: historyImages));
  }

  void addImage(String id) {
    final HistoryImage historyImage = HistoryImage(
      imageUri: '',
      startTime: -1,
    );
    add(HistoryImageAdded(historyImage: historyImage));
  }

  void _onHistoryImageRemoved(
      HistoryImageRemoved event, Emitter<HistoryState> emit) {
    final List<HistoryImage> historyImages = state.historyImages!;
    historyImages.removeWhere((element) => element.id == event.historyImageId);
    emit(state.copyWith(historyImages: historyImages));
  }

  void removeImage(String id) {
    add(HistoryImageRemoved(historyImageId: id));
  }
}
