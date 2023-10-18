import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../domain/domain.dart';
import '../../../infrastructure/infrastructure.dart';

part 'bic_event.dart';
part 'bic_state.dart';

class BicBloc extends Bloc<BicEvent, BicState> {
  final BICRepository bicRepository;
  final String token;
  final double latitude;
  final double longitude;
  final _submitCompleter = Completer<void>();
  final void Function() minimizeInfoWindow;
  final void Function() onClosePressed;
  final void Function() goToTheBeginningOfTheForm;
  final Future<void> Function() toggleBICCreation;
  final void Function() closeAddHistoriesToBIC;
  final void Function() openAddHistoriesToBIC;

  BicBloc({
    required this.bicRepository,
    required this.token,
    required this.latitude,
    required this.longitude,
    required this.minimizeInfoWindow,
    required this.onClosePressed,
    required this.goToTheBeginningOfTheForm,
    required this.toggleBICCreation,
    required this.closeAddHistoriesToBIC,
    required this.openAddHistoriesToBIC,
  }) : super(BicState()) {
    on<BicNameChanged>(_onNameChanged);
    on<BicDescriptionChanged>(_onDescriptionChanged);
    on<BicExistsChanged>(_onExistsChanged);
    on<BicSubmitted>(_createBic);
    on<BicTouchedEveryField>(_touchedEveryField);
    on<BicDriveImageInfoAdded>(_driveImageInfoAdded);
    bicRepository.configureToken(token);
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
    try {
      await bicRepository.createBIC(
        BIC(
          name: state.bicName.value,
          description: state.bicDescription.value,
          exists: state.exists,
          latitude: latitude,
          longitude: longitude,
          nicknames: [],
          histories: [],
          imagesUris: state.driveImagesInfo.map((e) => e.url).toList(),
        ),
      );
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
}
