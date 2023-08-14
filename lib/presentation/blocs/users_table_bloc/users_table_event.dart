part of 'users_table_bloc.dart';

abstract class UsersTableEvent {}

class DataFetched extends UsersTableEvent {}

class NicknameSearched extends UsersTableEvent {
  final String nickname;

  NicknameSearched({required this.nickname});
}

class NicknameSearchStopped extends UsersTableEvent {}
