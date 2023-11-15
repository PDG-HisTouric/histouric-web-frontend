part of 'alert_bloc.dart';

class AlertState {
  final bool isAlertOpen;
  final bool animationControllerInitiated;
  final Widget? child;
  late final AnimationController animationController;

  AlertState({
    this.isAlertOpen = false,
    this.animationControllerInitiated = false,
    this.child,
  });

  AlertState copyWith({
    bool? isAlertOpen,
    bool? animationControllerInitiated,
    AnimationController? animationController,
    Widget? child,
  }) {
    return AlertState(
      isAlertOpen: isAlertOpen ?? this.isAlertOpen,
      animationControllerInitiated:
          animationControllerInitiated ?? this.animationControllerInitiated,
      child: child ?? this.child,
    ).._updateAnimationController(
        animationController ?? this.animationController);
  }

  void _updateAnimationController(AnimationController animationController) {
    this.animationController = animationController;
  }

  Animation<double> movement(double height) {
    double centerHeight =
        height / 2 - CardWithAcceptAndCancelButtons.maxHeight / 2;
    return Tween<double>(begin: -centerHeight, end: centerHeight).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
  }

  Animation<double> opacity() {
    return Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
  }
}
