import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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
    on<AddImageButtonPressed>(_onAddImageButtonPressed);
    on<RemoveImageEntryButtonPressed>(_onRemoveImageEntryButtonPressed);
    on<ImageEntryStateChanged>(_onImageEntryStateChanged);
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

  void _onAddImageButtonPressed(
      AddImageButtonPressed event, Emitter<HistoryState> emit) {
    const uuid = Uuid();
    final historyImageEntryState =
        ImageEntryState(id: uuid.v4()).configureControllers();
    final newImageEntryStates = [
      ...state.imageEntryStates,
      historyImageEntryState
    ];
    emit(state.copyWith(imageEntryStates: newImageEntryStates));
  }

  void addImageEntryState() {
    add(AddImageButtonPressed());
  }

  void _onRemoveImageEntryButtonPressed(
      RemoveImageEntryButtonPressed event, Emitter<HistoryState> emit) {
    final newImageEntryStates = state.imageEntryStates
        .where((element) => element.id != event.id)
        .toList();
    emit(state.copyWith(imageEntryStates: newImageEntryStates));
  }

  void removeImageEntryState(String id) {
    add(RemoveImageEntryButtonPressed(id: id));
  }

  void _onImageEntryStateChanged(
      ImageEntryStateChanged event, Emitter<HistoryState> emit) {
    final newImageEntryStates = state.imageEntryStates
        .map((element) => element.id == event.imageEntryState.id
            ? event.imageEntryState
            : element)
        .toList();
    emit(state.copyWith(imageEntryStates: newImageEntryStates));
  }

  void changeMinuteOfImageEntryState(String id, String minute) {
    final ImageEntryState newImageEntryState = state.imageEntryStates
        .firstWhere((element) => element.id == id)
        .copyWith(minute: minute);
    add(ImageEntryStateChanged(imageEntryState: newImageEntryState));
  }

  void changeImageEntryState({
    required String id,
    String? minute,
    bool? imageChosen,
    List<Uint8List>? images,
    List<String>? imagesNames,
    List<String>? imagesExtensions,
    bool? isImageFromFilePicker,
    List<HistouricImageInfo>? imagesInfo,
  }) {
    final ImageEntryState newImageEntryState = state.imageEntryStates
        .firstWhere((element) => element.id == id)
        .copyWith(
          minute: minute,
          imageChosen: imageChosen,
          images: images,
          imagesNames: imagesNames,
          imagesExtensions: imagesExtensions,
          isImageFromFilePicker: isImageFromFilePicker,
          imagesInfo: imagesInfo,
        );
    add(ImageEntryStateChanged(imageEntryState: newImageEntryState));
  }

  ImageEntryState getImageEntryStateById(String id) {
    return state.imageEntryStates.firstWhere((element) => element.id == id);
  }
}
