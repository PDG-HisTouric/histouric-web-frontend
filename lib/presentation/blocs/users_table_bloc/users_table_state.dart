part of 'users_table_bloc.dart';

class UsersTableState {
  final List<HistouricUser> users;

  UsersTableState({required this.users});

  UsersTableState copyWith({
    List<HistouricUser>? users,
  }) {
    return UsersTableState(
      users: users ?? this.users,
    );
  }
}
