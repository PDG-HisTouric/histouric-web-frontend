part of 'sidemenu_bloc.dart';

class SidemenuState {
  late final AnimationController menuController;
  final bool isMenuOpen;
  final String currentPage;
  final bool menuInitiated;

  SidemenuState({
    this.isMenuOpen = false,
    this.currentPage = '',
    this.menuInitiated = false,
  });

  SidemenuState copyWith({
    bool? isMenuOpen,
    String? currentPage,
    AnimationController? menuController,
    bool? menuInitiated,
  }) {
    return SidemenuState(
      isMenuOpen: isMenuOpen ?? this.isMenuOpen,
      currentPage: currentPage ?? this.currentPage,
      menuInitiated: menuInitiated ?? this.menuInitiated,
    ).._updateMenuController(menuController ?? this.menuController);
  }

  Animation<double> movement() {
    return Tween<double>(begin: -230, end: 0).animate(
        CurvedAnimation(parent: menuController, curve: Curves.easeInOut));
  }

  Animation<double> opacity() {
    return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: menuController, curve: Curves.easeInOut));
  }

  void _updateMenuController(AnimationController menuController) {
    this.menuController = menuController;
  }
}
