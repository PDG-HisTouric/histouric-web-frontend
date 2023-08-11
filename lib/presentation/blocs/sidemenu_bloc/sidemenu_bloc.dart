import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'sidemenu_event.dart';
part 'sidemenu_state.dart';

class SidemenuBloc extends Bloc<SidemenuEvent, SidemenuState> {
  SidemenuBloc() : super(SidemenuState()) {
    on<MenuOpened>(_onMenuOpened);
    on<MenuClosed>(_onMenuClosed);
    on<MenuToggled>(_onMenuToggled);
    on<MenuControllerUpdated>(_onMenuControllerUpdated);
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

  void updateMenuController(AnimationController menuController) {
    add(MenuControllerUpdated(menuController: menuController));
  }

  void closeMenu() {
    add(MenuClosed());
  }

  void openMenu() {
    add(MenuOpened());
  }
}
