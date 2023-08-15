import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sidemenu_event.dart';
part 'sidemenu_state.dart';

class SidemenuBloc extends Bloc<SidemenuEvent, SidemenuState> {
  SidemenuBloc() : super(SidemenuState()) {
    on<MenuOpened>(_onMenuOpened);
    on<MenuClosed>(_onMenuClosed);
    on<MenuToggled>(_onMenuToggled);
    on<MenuControllerUpdated>(_onMenuControllerUpdated);
    on<AnimationControllerDisposed>(_onAnimationControllerDisposed);
  }

  void _onMenuOpened(MenuOpened event, Emitter<SidemenuState> emit) {
    state.menuController.forward();
    emit(state.copyWith(isMenuOpen: true));
  }

  void _onMenuClosed(MenuClosed event, Emitter<SidemenuState> emit) {
    state.menuController.reverse();
    emit(state.copyWith(isMenuOpen: false));
  }

  void _onMenuToggled(MenuToggled event, Emitter<SidemenuState> emit) {
    emit(state.copyWith(isMenuOpen: !state.isMenuOpen));

    (state.isMenuOpen)
        ? state.menuController.reverse()
        : state.menuController.forward();
  }

  void _onMenuControllerUpdated(
    MenuControllerUpdated event,
    Emitter<SidemenuState> emit,
  ) {
    emit(state.copyWith(
        menuController: event.menuController, menuInitiated: true));
  }

  void _onAnimationControllerDisposed(
    AnimationControllerDisposed event,
    Emitter<SidemenuState> emit,
  ) {
    state.menuController.dispose();
    emit(state.copyWith(menuInitiated: false));
  }

  void updateMenuController(AnimationController menuController) {
    add(MenuControllerUpdated(menuController: menuController));
  }

  void disposeMenuController() {
    add(AnimationControllerDisposed());
  }

  void closeMenu() {
    add(MenuClosed());
  }

  void openMenu() {
    add(MenuOpened());
  }

  void toggleMenu() {
    add(MenuToggled());
  }
}
