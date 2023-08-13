import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:histouric_web/domain/entities/entities.dart';
import 'package:histouric_web/domain/repositories/repositories.dart';
import 'package:histouric_web/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:meta/meta.dart';

part 'users_table_event.dart';
part 'users_table_state.dart';

class UsersTableBloc extends Bloc<UsersTableEvent, UsersTableState> {
  final UserRepository userRepository;
  final String token;

  UsersTableBloc({
    required this.userRepository,
    required this.token,
  }) : super(UsersTableState(users: [])) {
    userRepository.configureToken(token);
    on<DataFetched>(_onDataFetched);
    on<NicknameSearched>(_onNicknameSearched);
  }

  void _onDataFetched(DataFetched event, Emitter<UsersTableState> emit) async {
    final List<HistouricUser> users = await userRepository.getUsers();
    emit(state.copyWith(users: users));
  }

  void fetchUsers() {
    add(DataFetched());
  }

  void _onNicknameSearched(
      NicknameSearched event, Emitter<UsersTableState> emit) async {
    List<HistouricUser> histouricUsers =
        await userRepository.getUsersByNickname(event.nickname);
    emit(state.copyWith(users: histouricUsers));
  }

  void searchByNickname(String nickname) {
    if (nickname.isEmpty) return fetchUsers();
    add(NicknameSearched(nickname: nickname));
  }
}