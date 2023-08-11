import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:histouric_web/domain/entities/entities.dart';
import 'package:histouric_web/domain/entities/token.dart';
import 'package:histouric_web/domain/repositories/repositories.dart';

import '../../../config/helpers/dialogs.dart';
import '../../../config/navigation/navigation_service.dart';
import '../../../config/navigation/router.dart';
import '../../../infrastructure/services/services.dart';

part 'logged_user_event.dart';
part 'logged_user_state.dart';

class LoggedUserBloc extends Bloc<LoggedUserEvent, LoggedUserState> {
  final UserRepository userRepository;
  final KeyValueStorageService keyValueStorageService;
  final AuthRepository authRepository;
  final BuildContext context;

  LoggedUserBloc({
    required this.userRepository,
    required this.authRepository,
    required this.keyValueStorageService,
    required this.context,
  }) : super(LoggedUserState()) {
    on<CheckToken>(_onCheckToken);
  }

  void _onCheckToken(CheckToken event, Emitter<LoggedUserState> emit) async {
    emit(state.copyWith(authStatus: AuthStatus.checking));
    try {
      String tokenString =
          (await keyValueStorageService.getValue<String>("token"))!;
      userRepository.configureToken(tokenString);
      String nickname =
          (await keyValueStorageService.getValue<String>("nickname"))!;
      HistouricUser histouricUser =
          await userRepository.getUserByNickname(nickname);
      emit(state.copyWith(
          nickname: nickname,
          token: tokenString,
          authStatus: AuthStatus.authenticated,
          email: histouricUser.email,
          roles: histouricUser.roles.map((role) => role.name).toList()));
    } catch (e) {
      print("estoy entrando aqui");
      emit(state.copyWith(authStatus: AuthStatus.notAuthenticated));
    }
  }

  void checkToken() {
    add(CheckToken());
  }

  void login(String email, String password) async {
    await saveTokenAndNickname(email, password);
    add(CheckToken());
  }

  Future<void> saveTokenAndNickname(String email, String password) async {
    try {
      Token token = await authRepository.login(email, password);
      await keyValueStorageService.setKeyValue("token", token.token);
      await keyValueStorageService.setKeyValue("nickname", token.nickname);
    } catch (e) {
      Dialogs.showErrorDialog(
          context: context, content: "Credenciales inválidas");
    }
  }
}
