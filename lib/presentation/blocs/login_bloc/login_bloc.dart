import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

import '../../../config/helpers/dialogs.dart';
import '../../../config/navigation/navigation_service.dart';
import '../../../config/navigation/router.dart';
import '../../../domain/entities/token.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../infrastructure/datasource/spring_boot_login_datasource.dart';
import '../../../infrastructure/inputs/email.dart';
import '../../../infrastructure/inputs/nickname.dart';
import '../../../infrastructure/inputs/password.dart';
import '../../../infrastructure/repositories/auth_repository_impl.dart';
import '../../../infrastructure/services/key_value_storage_service_impl.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginFormState> {
  final AuthRepository authRepository;
  final KeyValueStorageServiceImpl keyValueStorageService;

  LoginBloc({
    required this.authRepository,
    required this.keyValueStorageService,
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
    print(event.email);
  }

  void _onPasswordChanged(
      LoginPasswordChanged event, Emitter<LoginFormState> emit) {
    Password password = Password.dirty(event.password);
    emit(state.copyWith(
      password: password,
      isValid: Formz.validate([state.email, password]),
    ));
    print(event.password);
  }

  void _onSubmitted(LoginSubmitted event, Emitter<LoginFormState> emit) async {
    emit(state.copyWith());
    AuthRepository authRepository = AuthRepositoryImpl(
      authDatasource: SpringBootLoginDatasource(),
    );
    Token token =
        await authRepository.login(state.email.value, state.password.value);

    await keyValueStorageService.setKeyValue("token", token.token);
    await keyValueStorageService.setKeyValue("userId", token.userId);
    await keyValueStorageService.setKeyValue(
      "roles",
      token.roles.join(" "),
    );
    NavigationService.pushAndPop(FluroRouterWrapper.dashboardRoute);
  }

  void submitLogin(BuildContext context) {
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
