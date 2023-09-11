import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:histouric_web/domain/domain.dart';

import 'package:histouric_web/infrastructure/inputs/inputs.dart';

part 'bic_event.dart';
part 'bic_state.dart';

class BicBloc extends Bloc<BicEvent, BicState> {
  BicBloc() : super(BicState()) {
    on<BicNameChanged>(_onNameChanged);
    on<BicDescriptionChanged>(_onDescriptionChanged);
    on<BicExistsChanged>(_onExistsChanged);
    on<BicSubmitted>(_createBic);
    on<BicTouchedEveryField>(_touchedEveryField);
    on<BicDriveImageInfoAdded>(_driveImageInfoAdded);
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

  void _createBic(BicSubmitted event, Emitter<BicState> emit) {
    //TODO: CONECTAR CON EL BACKEND
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

  void submit() {
    add(BicSubmitted());
  }

  void driveImageInfoAdded(HistouricImageInfo driveImageInfo) {
    add(BicDriveImageInfoAdded(driveImageInfo: driveImageInfo));
  }
}
