import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../config/helpers/dialogs.dart';
import '../../../config/navigation/navigation_service.dart';
import '../../../config/navigation/router.dart';
import '../../../domain/entities/token.dart';
import '../../../domain/repositories/auth_repository.dart';

import '../../../infrastructure/inputs/email.dart';
import '../../../infrastructure/inputs/nickname.dart';
import '../../../infrastructure/inputs/password.dart';
import '../../../infrastructure/services/services.dart';
import '../logged_user_bloc/logged_user_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginFormState> {
  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;
  final BuildContext context;

  LoginBloc({
    required this.authRepository,
    required this.keyValueStorageService,
    required this.context,
  }) : super(LoginFormState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginFormState> emit) {
    Email email = Email.dirty(event.email);
    emit(state.copyWith(
      email: email,
      isValid: Formz.validate([email, state.password]),
    ));
  }

  void _onPasswordChanged(
      LoginPasswordChanged event, Emitter<LoginFormState> emit) {
    Password password = Password.dirty(event.password);
    emit(state.copyWith(
      password: password,
      isValid: Formz.validate([state.email, password]),
    ));
  }

  void _onSubmitted(LoginSubmitted event, Emitter<LoginFormState> emit) {
    authRepository.login(state.email.value, state.password.value).then((token) {
      keyValueStorageService.setKeyValue("token", token.token).then((_) {
        keyValueStorageService
            .setKeyValue("nickname", token.nickname)
            .then((__) {
          context.read<LoggedUserBloc>().updateLoggedUser();
          NavigationService.pushAndPop(FluroRouterWrapper.dashboardRoute);
        });
      });
    });
  }

  void submitLogin() {
    if (!state.isValid) return;
    try {
      add(LoginSubmitted());
    } catch (e) {
      Dialogs.showErrorDialog(context: context, content: e.toString());
    }
  }

  void emailChanged(String email) {
    add(LoginEmailChanged(email: email));
  }

  void passwordChanged(String password) {
    add(LoginPasswordChanged(password: password));
  }
}
