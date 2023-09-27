import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

import '../../../domain/entities/entities.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final String owner;
  HistoryBloc({required this.owner}) : super(HistoryState(owner: owner)) {
    on<HistoryAudioUrlChanged>(_onAudioUrlChanged);
    on<HistoryImageAdded>(_onHistoryImageAdded);
    on<HistoryImageRemoved>(_onHistoryImageRemoved);
  }

  void _onAudioUrlChanged(
      HistoryAudioUrlChanged event, Emitter<HistoryState> emit) {
    emit(state.copyWith(audioUrl: event.audioUrl));
  }

  void changeAudioUrl(String audioUrl) {
    add(HistoryAudioUrlChanged(audioUrl: audioUrl));
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
