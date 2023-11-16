import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';

part 'alert_event.dart';
part 'alert_state.dart';

class AlertBloc extends Bloc<AlertEvent, AlertState> {
  AlertBloc() : super(AlertState()) {
    on<AlertOpened>(_onAlertOpened);
    on<AlertClosed>(_onAlertClosed);
    on<AnimationControllerForAlertUpdated>(_onAnimationControllerInitialized);
    on<AnimationControllerForAlertDisposed>(_onAnimationControllerDisposed);
    on<ChildChanged>(_onChildChanged);
  }

  void _onAlertOpened(AlertOpened event, Emitter<AlertState> emit) {
    state.animationController.forward();
    emit(state.copyWith(isAlertOpen: true));
  }

  void openAlert() {
    add(AlertOpened());
  }

  void _onAlertClosed(AlertClosed event, Emitter<AlertState> emit) {
    state.animationController.reverse();
    emit(state.copyWith(isAlertOpen: false));
  }

  void closeAlert() {
    add(AlertClosed());
  }

  void _onAnimationControllerInitialized(
    AnimationControllerForAlertUpdated event,
    Emitter<AlertState> emit,
  ) {
    if (state.animationControllerInitiated) {
      state.animationController.dispose();
    }
    emit(state.copyWith(
        animationController: event.animationController,
        animationControllerInitiated: true));
  }

  void updateAnimationController(AnimationController animationController) {
    add(AnimationControllerForAlertUpdated(
        animationController: animationController));
  }

  void _onAnimationControllerDisposed(
    AnimationControllerForAlertDisposed event,
    Emitter<AlertState> emit,
  ) {
    state.animationController.dispose();
    emit(state.copyWith(animationControllerInitiated: false));
  }

  void disposeAnimationController() {
    add(AnimationControllerForAlertDisposed());
  }

  void _onChildChanged(ChildChanged event, Emitter<AlertState> emit) {
    emit(state.copyWith(child: event.child));
  }

  void changeChild(Widget child) {
    add(ChildChanged(child: child));
  }
}
