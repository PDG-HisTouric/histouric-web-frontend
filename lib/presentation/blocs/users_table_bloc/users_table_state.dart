part of 'users_table_bloc.dart';

class UsersTableState {
  final List<HistouricUser>? users;
  final bool isSearching;

  UsersTableState({this.users, this.isSearching = false});

  UsersTableState copyWith({
    List<HistouricUser>? users,
    bool? isSearching,
  }) {
    return UsersTableState(
      isSearching: isSearching ?? this.isSearching,
      users: users ?? this.users,
    );
  }
}
