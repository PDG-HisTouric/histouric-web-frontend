import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:histouric_web/presentation/presentation.dart';

import '../../../domain/domain.dart';
import '../blocs.dart';

part 'users_table_event.dart';
part 'users_table_state.dart';

class UsersTableBloc extends Bloc<UsersTableEvent, UsersTableState> {
  final UserRepository userRepository;
  final String token;
  final AlertBloc alertBloc;

  UsersTableBloc({
    required this.userRepository,
    required this.token,
    required this.alertBloc,
  }) : super(UsersTableState()) {
    on<DataFetched>(_onDataFetched);
    on<NicknameSearched>(_onNicknameSearched);
    on<NicknameSearchStopped>(_onNicknameSearchStopped);
    on<UserDeleted>(_onUserDeleted);
    on<ControllersOfUserTableInitialized>(_onControllersInitialized);
    userRepository.configureToken(token);
    _initializeControllers();
  }

  void _onDataFetched(DataFetched event, Emitter<UsersTableState> emit) async {
    final List<HistouricUser> users = await userRepository.getUsers();
    emit(state.copyWith(users: users));
  }

  void fetchUsers() {
    add(DataFetched());
  }

  void _onNicknameSearched(
    NicknameSearched event,
    Emitter<UsersTableState> emit,
  ) async {
    List<HistouricUser> histouricUsers =
        await userRepository.getUsersByNickname(event.nickname);

    emit(state.copyWith(users: histouricUsers, isSearching: true));
  }

  void searchByNickname(String nickname) {
    if (nickname.isEmpty) _stopSearching();
    add(NicknameSearched(nickname: nickname));
  }

  void _onNicknameSearchStopped(
    NicknameSearchStopped event,
    Emitter<UsersTableState> emit,
  ) async {
    final List<HistouricUser> users = await userRepository.getUsers();
    emit(state.copyWith(users: users, isSearching: false));
  }

  void _stopSearching() {
    add(NicknameSearchStopped());
  }

  void _onUserDeleted(UserDeleted event, Emitter<UsersTableState> emit) async {
    await userRepository.deleteUserById(event.id);
    fetchUsers();
  }

  void deleteUser(String id) {
    alertBloc.changeChild(CardWithAcceptAndCancelButtons(
      title: "¿Está seguro que desea borrar este usuario?",
      subtitle: "Todas sus historias o rutas asociadas se borrarán también.",
      icon: Icons.warning,
      onAcceptPressed: () {
        add(UserDeleted(id: id));
        alertBloc.closeAlert();
      },
      onCancelPressed: () => alertBloc.closeAlert(),
    ));
    alertBloc.openAlert();
  }

  void _onControllersInitialized(
    ControllersOfUserTableInitialized event,
    Emitter<UsersTableState> emit,
  ) {
    emit(state.configureControllers());
  }

  void _initializeControllers() {
    add(ControllersOfUserTableInitialized());
  }
}
