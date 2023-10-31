import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../domain/domain.dart';
import '../../../infrastructure/infrastructure.dart';

part 'bic_event.dart';
part 'bic_state.dart';

class BicBloc extends Bloc<BicEvent, BicState> {
  final BICRepository bicRepository;
  final HistoryRepository historyRepository;
  final String token;
  final double latitude;
  final double longitude;
  final _submitCompleter = Completer<void>();
  final void Function() minimizeInfoWindow;
  final void Function() onClosePressed;
  final void Function() goToTheBeginningOfTheForm;
  final Future<void> Function() toggleBICCreation;
  late final void Function() _closeAddHistoriesToBIC;
  final void Function() openAddHistoriesToBIC;

  BicBloc({
    required this.bicRepository,
    required this.historyRepository,
    required this.token,
    required this.latitude,
    required this.longitude,
    required this.minimizeInfoWindow,
    required this.onClosePressed,
    required this.goToTheBeginningOfTheForm,
    required this.toggleBICCreation,
    required void Function() closeAddHistoriesToBIC,
    required this.openAddHistoriesToBIC,
  }) : super(BicState(historyTitleController: TextEditingController())) {
    on<BicNameChanged>(_onNameChanged);
    on<BicDescriptionChanged>(_onDescriptionChanged);
    on<BicExistsChanged>(_onExistsChanged);
    on<BicSubmitted>(_createBic);
    on<BicTouchedEveryField>(_touchedEveryField);
    on<BicDriveImageInfoAdded>(_driveImageInfoAdded);
    on<HistoriesAfterSearchChanged>(_onHistoriesAfterSearchChanged);
    on<TitleForSearchQueryChanged>(_onTitleForSearchQueryChanged);
    on<HistoryChecked>(_onHistoryChecked);
    on<HistoriesUnselected>(_onHistoriesUnselected);
    on<AddSelectedHistoriesButtonPressed>(_onAddSelectedHistoriesButtonPressed);
    on<RemoveSelectedHistoryButtonPressed>(
        _onRemoveSelectedHistoryButtonPressed);
    bicRepository.configureToken(token);
    _closeAddHistoriesToBIC = closeAddHistoriesToBIC;
  }

  void _onNameChanged(BicNameChanged event, Emitter<BicState> emit) {
    BICName name = BICName.dirty(event.name);

    emit(state.copyWith(
      bicName: name,
      isValid: Formz.validate([name, state.bicDescription]),
    ));
  }

  void _onDescriptionChanged(
      BicDescriptionChanged event, Emitter<BicState> emit) {
    BICDescription description = BICDescription.dirty(event.description);

    emit(state.copyWith(
      bicDescription: description,
      isValid: Formz.validate([state.bicName, description]),
    ));
  }

  void _onExistsChanged(BicExistsChanged event, Emitter<BicState> emit) {
    emit(state.copyWith(
      exists: event.exists,
    ));
  }

  Future<void> _createBic(BicSubmitted event, Emitter<BicState> emit) async {
    if (!isStateValid()) return;
    emit(state.copyWith(status: SubmissionStatus.submissionInProgress));
    while (state.status != SubmissionStatus.submissionInProgress) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    List<String> historiesIds =
        state.selectedHistories.map((e) => e.id).toList();
    try {
      BICCreation bic = BICCreation(
        name: state.bicName.value,
        description: state.bicDescription.value,
        exists: state.exists,
        latitude: latitude,
        longitude: longitude,
        nicknames: [],
        imagesUris: state.driveImagesInfo.map((e) => e.url).toList(),
        historiesIds: historiesIds,
      );
      await bicRepository.createBIC(bic);
      emit(state.copyWith(status: SubmissionStatus.submissionSuccess));
      while (state.status != SubmissionStatus.submissionSuccess) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
      _submitCompleter.complete();
    } catch (e) {
      emit(state.copyWith(status: SubmissionStatus.submissionFailure));
      while (state.status != SubmissionStatus.submissionFailure) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
      _submitCompleter.complete();
    }
  }

  void _touchedEveryField(BicTouchedEveryField event, Emitter<BicState> emit) {
    final newName = BICName.dirty(state.bicName.value);
    final newDescription = BICDescription.dirty(state.bicDescription.value);

    emit(state.copyWith(
      bicName: newName,
      bicDescription: newDescription,
      isValid: Formz.validate([newName, newDescription]),
    ));
  }

  void _driveImageInfoAdded(
      BicDriveImageInfoAdded event, Emitter<BicState> emit) {
    List<HistouricImageInfo> newDriveImagesInfo = [
      ...state.driveImagesInfo,
      event.driveImageInfo
    ];
    emit(state.copyWith(
      driveImagesInfo: newDriveImagesInfo,
    ));
  }

  bool isStateValid() {
    if (!state.isValid) {
      add(BicTouchedEveryField());
      return false;
    }
    return true;
  }

  void nameChanged(String name) {
    add(BicNameChanged(name: name));
  }

  void descriptionChanged(String description) {
    add(BicDescriptionChanged(description: description));
  }

  void existsChanged() {
    add(BicExistsChanged(exists: !state.exists));
  }

  Future<void> submit() async {
    add(BicSubmitted());
    await _submitCompleter.future;
  }

  void driveImageInfoAdded(HistouricImageInfo driveImageInfo) {
    add(BicDriveImageInfoAdded(driveImageInfo: driveImageInfo));
  }

  void _onHistoriesAfterSearchChanged(
      HistoriesAfterSearchChanged event, Emitter<BicState> emit) {
    emit(state.copyWith(
      historiesAfterSearch: event.historiesAfterSearch,
    ));
  }

  void historiesAfterSearchChanged(List<Story> historiesAfterSearch) {
    add(HistoriesAfterSearchChanged(
        historiesAfterSearch: historiesAfterSearch));
  }

  void _onTitleForSearchQueryChanged(
      TitleForSearchQueryChanged event, Emitter<BicState> emit) async {
    if (event.titleForSearchQuery.isNotEmpty) {
      emit(state.copyWith(isSearchingHistories: true));
      List<Story> historiesAfterSearch = await historyRepository
          .getHistoriesByTitle(event.titleForSearchQuery);
      emit(state.copyWith(
        historiesAfterSearch: historiesAfterSearch,
        isSearchingHistories: false,
      ));
    } else {
      emit(state.copyWith(historiesAfterSearch: state.selectedHistories));
    }
    emit(state.copyWith(titleForSearchQuery: event.titleForSearchQuery));
  }

  void changeTitleForSearchQuery(String titleForSearchQuery) {
    add(TitleForSearchQueryChanged(titleForSearchQuery: titleForSearchQuery));
  }

  void _onHistoryChecked(HistoryChecked event, Emitter<BicState> emit) {
    List<Story> newSelectedHistories =
        _getNewSelectedHistories(event.historyId);
    emit(state.copyWith(
      selectedHistories: newSelectedHistories,
    ));
  }

  void checkHistory(String historyId) {
    add(HistoryChecked(historyId: historyId));
  }

  List<Story> _getNewSelectedHistories(String historyId) {
    List<Story> newSelectedHistories = [...state.selectedHistories];
    for (int i = 0; i < newSelectedHistories.length; i++) {
      if (newSelectedHistories[i].id == historyId) {
        newSelectedHistories.removeAt(i);
        return newSelectedHistories;
      }
    }
    newSelectedHistories.add(state.historiesAfterSearch
        .firstWhere((element) => element.id == historyId));
    return newSelectedHistories;
  }

  void _onHistoriesUnselected(
      HistoriesUnselected event, Emitter<BicState> emit) {
    emit(state.copyWith(
      historiesAfterSearch: state.selectedHistories,
      historyTitleController: TextEditingController(),
      titleForSearchQuery: "",
    ));
  }

  void cancelHistoriesAddition() {
    //TODO: Pause all the audios that are playing
    add(HistoriesUnselected());
    _closeAddHistoriesToBIC();
  }

  void closeHistoriesAddition() {
    //TODO: Pause all the audios that are playing
    add(AddSelectedHistoriesButtonPressed());
    _closeAddHistoriesToBIC();
  }

  void addSelectedHistories() {
    //TODO: Pause all the audios that are playing
    add(AddSelectedHistoriesButtonPressed());
    _closeAddHistoriesToBIC();
  }

  void _onAddSelectedHistoriesButtonPressed(
      AddSelectedHistoriesButtonPressed event, Emitter<BicState> emit) {
    emit(state.copyWith(
      titleForSearchQuery: "",
      historyTitleController: TextEditingController(),
      historiesAfterSearch: state.selectedHistories,
    ));
  }

  void _onRemoveSelectedHistoryButtonPressed(
      RemoveSelectedHistoryButtonPressed event, Emitter<BicState> emit) {
    List<Story> newSelectedHistories = [...state.selectedHistories];
    for (int i = 0; i < newSelectedHistories.length; i++) {
      if (newSelectedHistories[i].id == event.historyId) {
        newSelectedHistories.removeAt(i);
        break;
      }
    }
    emit(state.copyWith(
      selectedHistories: newSelectedHistories,
      historiesAfterSearch: newSelectedHistories,
    ));
  }

  void removeHistory(String historyId) {
    //TODO: If the audio is playing, then pause the audio before removing
    add(RemoveSelectedHistoryButtonPressed(historyId: historyId));
  }
}
