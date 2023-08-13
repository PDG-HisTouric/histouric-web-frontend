part of 'sidemenu_bloc.dart';

abstract class SidemenuEvent {}

class MenuOpened extends SidemenuEvent {}

class MenuClosed extends SidemenuEvent {}

class MenuToggled extends SidemenuEvent {}

class MenuControllerUpdated extends SidemenuEvent {
  final AnimationController menuController;

  MenuControllerUpdated({required this.menuController});
}

class AnimationControllerDisposed extends SidemenuEvent {}
