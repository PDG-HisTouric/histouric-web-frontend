import 'package:bloc/bloc.dart';
import 'package:histouric_web/login/domain/repositories/auth_repository.dart';
import 'package:histouric_web/login/infrastructure/datasource/spring_boot_login_datasource.dart';
import 'package:histouric_web/login/infrastructure/inputs/nickname.dart';
import 'package:histouric_web/login/infrastructure/repositories/auth_repository_impl.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/token.dart';
import '../../../infrastructure/inputs/email.dart';
import '../../../infrastructure/inputs/password.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginFormState> {
  LoginBloc() : super(LoginFormState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginFormState> emit) {
    emit(state.copyWith(
      email: Email.dirty(event.email),
    ));
    print(event.email);
  }

  void _onPasswordChanged(
      LoginPasswordChanged event, Emitter<LoginFormState> emit) {
    emit(state.copyWith(
      password: Password.dirty(event.password),
    ));
    print(event.password);
  }

  void _onSubmitted(LoginSubmitted event, Emitter<LoginFormState> emit) async {
    emit(state.copyWith(
      formStatus: FormStatus.validating,
    ));
    AuthRepository authRepository = AuthRepositoryImpl(
      authDatasource: SpringBootLoginDatasource(),
    );
    Token temp =
        await authRepository.login(state.email.value, state.password.value);
    print(temp);
    print("undi");
  }

  void submitLogin() {
    add(LoginSubmitted());
  }

  void emailChanged(String email) {
    add(LoginEmailChanged(email: email));
  }

  void passwordChanged(String password) {
    add(LoginPasswordChanged(password: password));
  }
}
