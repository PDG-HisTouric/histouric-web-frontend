import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../config/config.dart';
import '../../../infrastructure/infrastructure.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginFormBloc extends Bloc<LoginFormEvent, LoginFormState> {
  final BuildContext context;

  LoginFormBloc({
    required this.context,
  }) : super(LoginFormState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_touchedEveryField);
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginFormState> emit) {
    Email email = Email.dirty(event.email);

    emit(state.copyWith(
      email: email,
      isValid: Formz.validate([email, state.password]),
    ));
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginFormState> emit,
  ) {
    Password password = Password.dirty(event.password);

    emit(state.copyWith(
      password: password,
      isValid: Formz.validate([state.email, password]),
    ));
  }

  void _touchedEveryField(LoginSubmitted event, Emitter<LoginFormState> emit) {
    final newEmail = Email.dirty(state.email.value);
    final newPassword = Password.dirty(state.password.value);

    emit(state.copyWith(
      email: newEmail,
      password: newPassword,
      isValid: Formz.validate([newEmail, newPassword]),
    ));
  }

  bool isStateValid() {
    if (!state.isValid) {
      add(LoginSubmitted());
      Dialogs.showErrorDialog(
        context: context,
        content: "Por favor, diligencie de manera correcta todos los campos",
      );
      return false;
    }
    return true;
  }

  void emailChanged(String email) {
    add(LoginEmailChanged(email: email));
  }

  void passwordChanged(String password) {
    add(LoginPasswordChanged(password: password));
  }
}
