import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:histouric_web/domain/entities/entities.dart';
import 'package:histouric_web/domain/entities/token.dart';
import 'package:histouric_web/domain/repositories/repositories.dart';

import '../../../config/helpers/dialogs.dart';
import '../../../infrastructure/services/services.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository;
  final KeyValueStorageService keyValueStorageService;
  final AuthRepository authRepository;
  final BuildContext context;

  AuthBloc({
    required this.userRepository,
    required this.authRepository,
    required this.keyValueStorageService,
    required this.context,
  }) : super(AuthState()) {
    on<CheckToken>(_onCheckToken);
    on<UserLoggedOut>(_onUserLoggedOut);
  }

  void _onCheckToken(CheckToken event, Emitter<AuthState> emit) async {
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
      emit(state.copyWith(authStatus: AuthStatus.notAuthenticated));
    }
  }

  void checkToken() {
    add(CheckToken());
  }

  Future<bool> login(String email, String password) async {
    if (!await saveTokenAndNickname(email, password)) return false;
    add(CheckToken());
    return true;
  }

  Future<bool> saveTokenAndNickname(String email, String password) async {
    try {
      Token token = await authRepository.login(email, password);
      await keyValueStorageService.setKeyValue("token", token.token);
      await keyValueStorageService.setKeyValue("nickname", token.nickname);
      return true;
    } catch (e) {
      return false;
    }
  }

  void _onUserLoggedOut(UserLoggedOut event, Emitter<AuthState> emit) async {
    emit(state.copyWith(
      authStatus: AuthStatus.checking,
      email: null,
      nickname: null,
      roles: null,
      token: null,
    ));
    await keyValueStorageService.removeKey("token");
    await keyValueStorageService.removeKey("nickname");
    emit(state.copyWith(authStatus: AuthStatus.notAuthenticated));
  }

  void logout() {
    add(UserLoggedOut());
  }
}
