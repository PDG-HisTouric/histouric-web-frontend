part of 'users_table_bloc.dart';

class UsersTableState {
  final List<HistouricUser>? users;
  final bool isSearching;
  final bool initializingControllers;
  late final TextEditingController nicknameController;

  UsersTableState({
    this.users,
    this.isSearching = false,
    this.initializingControllers = true,
  });

  UsersTableState copyWith({
    List<HistouricUser>? users,
    bool? isSearching,
    bool? initializingControllers,
  }) {
    return UsersTableState(
      isSearching: isSearching ?? this.isSearching,
      users: users ?? this.users,
      initializingControllers:
          initializingControllers ?? this.initializingControllers,
    )..nicknameController = nicknameController;
  }

  UsersTableState configureControllers() {
    return UsersTableState(
      isSearching: isSearching,
      users: users,
      initializingControllers: false,
    )..nicknameController = TextEditingController();
  }

  UsersTableState clearController() {
    return UsersTableState(
      isSearching: isSearching,
      users: users,
    )..nicknameController.clear();
  }
}
