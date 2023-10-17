import 'dart:collection';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repositories.dart';
import '../../../infrastructure/models/models.dart';
import '../../widgets/history/history_widgets.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final String owner;
  final HistoryRepository historyRepository;
  HistoryBloc({required this.owner, required this.historyRepository})
      : super(
          HistoryState(
            owner: owner,
            audioState: AudioState(audio: Uint8List(0)),
          ),
        ) {
    on<HistoryAudioStateChanged>(_onHistoryAudioStateChanged);
    on<AddImageButtonPressed>(_onAddImageButtonPressed);
    on<RemoveImageEntryButtonPressed>(_onRemoveImageEntryButtonPressed);
    on<ImageEntryStateChanged>(_onImageEntryStateChanged);
    on<AddTextSegmentButtonPressed>(_onAddTextSegmentButtonPressed);
    on<TextSegmentStateChanged>(_onTextSegmentStateChanged);
    on<RemoveTextEntryButtonPressed>(_onRemoveTextEntryButtonPressed);
    on<VideoFromFilePickerAdded>(_onVideoFromFilePickerAdded);
    on<VideoFromUrlAdded>(_onVideoFromUrlAdded);
    on<RemoveVideoEntryButtonPressed>(_onRemoveVideoEntryButtonPressed);
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

  void _onAddTextSegmentButtonPressed(
      AddTextSegmentButtonPressed event, Emitter<HistoryState> emit) {
    const uuid = Uuid();
    final newTextSegmentState =
        TextSegmentState(id: uuid.v4()).configureControllers();
    final newTextSegmentStates = [
      ...state.textSegmentStates,
      newTextSegmentState
    ];
    emit(state.copyWith(textSegmentStates: newTextSegmentStates));
  }

  void addTextSegment() {
    add(AddTextSegmentButtonPressed());
  }

  void _onTextSegmentStateChanged(
      TextSegmentStateChanged event, Emitter<HistoryState> emit) {
    final newTextSegmentStates = state.textSegmentStates
        .map((element) => element.id == event.textSegmentState.id
            ? event.textSegmentState
            : element)
        .toList();
    emit(state.copyWith(textSegmentStates: newTextSegmentStates));
  }

  void changeMinuteOfTextSegmentState(String id, String minute) {
    final TextSegmentState newTextSegmentState = state.textSegmentStates
        .firstWhere((element) => element.id == id)
        .copyWith(minute: minute);
    add(TextSegmentStateChanged(textSegmentState: newTextSegmentState));
  }

  void changeTextOfTextSegmentState(String id, String text) {
    final TextSegmentState newTextSegmentState = state.textSegmentStates
        .firstWhere((element) => element.id == id)
        .copyWith(text: text);
    add(TextSegmentStateChanged(textSegmentState: newTextSegmentState));
  }

  TextSegmentState getTextSegmentStateById(String id) {
    return state.textSegmentStates.firstWhere((element) => element.id == id);
  }

  void _onRemoveTextEntryButtonPressed(
      RemoveTextEntryButtonPressed event, Emitter<HistoryState> emit) {
    final newTextSegmentStates = state.textSegmentStates
        .where((element) => element.id != event.id)
        .toList();
    emit(state.copyWith(textSegmentStates: newTextSegmentStates));
  }

  void removeTextSegment(String id) {
    add(RemoveTextEntryButtonPressed(id: id));
  }

  void _onVideoFromFilePickerAdded(
      VideoFromFilePickerAdded event, Emitter<HistoryState> emit) {
    const uuid = Uuid();
    final historyVideoEntry = VideoEntry(
      id: uuid.v4(),
      video: event.video,
      extension: event.extension,
      isVideoFromFilePicker: true,
      name: event.name,
    );
    final newVideoEntries = [...state.videoEntries, historyVideoEntry];
    emit(state.copyWith(videoEntries: newVideoEntries));
  }

  void addVideoFromFilePicker(Uint8List video, String extension, String name) {
    add(VideoFromFilePickerAdded(
        video: video, extension: extension, name: name));
  }

  void _onVideoFromUrlAdded(
      VideoFromUrlAdded event, Emitter<HistoryState> emit) {
    const uuid = Uuid();
    final historyVideoEntry = VideoEntry(
      id: uuid.v4(),
      url: event.url,
      width: event.width,
      height: event.height,
      isVideoFromFilePicker: false,
    );
    final newVideoEntries = [...state.videoEntries, historyVideoEntry];
    emit(state.copyWith(videoEntries: newVideoEntries));
  }

  void addVideoFromUrl({
    required String url,
    required double width,
    required double height,
  }) {
    add(VideoFromUrlAdded(url: url, width: width, height: height));
  }

  void _onRemoveVideoEntryButtonPressed(
      RemoveVideoEntryButtonPressed event, Emitter<HistoryState> emit) {
    final newVideoEntries =
        state.videoEntries.where((element) => element.id != event.id).toList();
    emit(state.copyWith(videoEntries: newVideoEntries));
  }

  void removeVideoEntry(String id) {
    add(RemoveVideoEntryButtonPressed(id: id));
  }

  void createHistory() {
    final AudioCreation audio;
    final temp = state.audioState.audio!;
    if (state.audioState.isAudioFromFilePicker) {
      audio = AudioCreation(
        audioFile: state.audioState.audio!,
        audioName: state.audioState.audioName!,
        needsUrlGen: true,
      );
    } else {
      audio = AudioCreation(
        needsUrlGen: false,
        audioUri: state.audioState.src,
      );
    }

    final List<TextCreation> texts = state.textSegmentStates
        .map((textSegment) => TextCreation(
              content: textSegment.text,
              startTime: textSegment.getSeconds(),
            ))
        .toList();

    final List<HistoryImageCreation> images =
        state.imageEntryStates.map((imageEntry) {
      if (imageEntry.isImageFromFilePicker) {
        return HistoryImageCreation(
          imageFile: imageEntry.images.first,
          imageName: imageEntry.imagesNames.first,
          needsUrlGen: true,
          startTime: imageEntry.getSeconds(),
        );
      } else {
        return HistoryImageCreation(
          needsUrlGen: false,
          imageUri: imageEntry.imagesInfo.first.url,
          startTime: imageEntry.getSeconds(),
        );
      }
    }).toList();

    final List<VideoCreation> videos = state.videoEntries.map((videoEntry) {
      if (videoEntry.isVideoFromFilePicker) {
        return VideoCreation(
          videoFile: videoEntry.video!,
          videoName: videoEntry.name!,
          needsUrlGen: true,
        );
      } else {
        return VideoCreation(
          needsUrlGen: false,
          videoUri: videoEntry.url,
        );
      }
    }).toList();

    final HistoryCreation historyCreation = HistoryCreation(
      title: state.title,
      audio: audio,
      owner: owner,
      texts: texts,
      images: images,
      videos: videos,
    );

    historyRepository.createHistory(historyCreation).then((value) {
      print(value);
    });
  }
}
