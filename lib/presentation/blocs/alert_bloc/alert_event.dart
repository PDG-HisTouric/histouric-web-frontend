part of 'alert_bloc.dart';

abstract class AlertEvent {}

class AlertOpened extends AlertEvent {}

class AlertClosed extends AlertEvent {}

class AnimationControllerForAlertUpdated extends AlertEvent {
  final AnimationController animationController;

  AnimationControllerForAlertUpdated({required this.animationController});
}

class AnimationControllerForAlertDisposed extends AlertEvent {}

class ChildChanged extends AlertEvent {
  final Widget child;

  ChildChanged({required this.child});
}
