import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:histouric_web/infrastructure/inputs/nickname.dart';
import 'package:histouric_web/infrastructure/inputs/password.dart';

import '../../../config/helpers/dialogs.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../infrastructure/inputs/email.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final BuildContext context;
  final AuthRepository authRepository;

  SignUpBloc({
    required this.context,
    required this.authRepository,
  }) : super(SignUpState()) {
    on<SignUpEmailChanged>(_onEmailChanged);
    on<SignUpPasswordChanged>(_onPasswordChanged);
    on<SignUpConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<SignUpNicknameChanged>(_onNicknameChanged);
    on<SignUpSubmitted>(_onFormSubmitted);
    on<SignUpTouchedEveryField>(_touchedEveryField);
  }

  bool signUp() {
    add(SignUpTouchedEveryField());
    if (!isStateValid()) return false;
    if (state.password.value != state.confirmPassword.value) {
      Dialogs.showErrorDialog(
        context: context,
        content: "Las contraseñas no coinciden",
      );
      return false;
    }
    add(SignUpSubmitted());
    return true;
  }

  void emailChanged(String email) {
    add(SignUpEmailChanged(email: email));
  }

  void passwordChanged(String password) {
    add(SignUpPasswordChanged(password: password));
  }

  void confirmPasswordChanged(String confirmPassword) {
    add(SignUpConfirmPasswordChanged(confirmPassword: confirmPassword));
  }

  void nicknameChanged(String nickname) {
    add(SignUpNicknameChanged(nickname: nickname));
  }

  void _onFormSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    await authRepository.register(
      state.email.value,
      state.password.value,
      state.nickname.value,
    );
  }

  _touchedEveryField(SignUpTouchedEveryField event, Emitter<SignUpState> emit) {
    final newEmail = Email.dirty(state.email.value);
    final newPassword = Password.dirty(state.password.value);
    final newNickname = Nickname.dirty(state.nickname.value);

    emit(state.copyWith(
      email: newEmail,
      password: newPassword,
      nickname: newNickname,
      isValid: Formz.validate([newEmail, newPassword, newNickname]),
    ));
  }

  bool isStateValid() {
    if (!state.isValid) {
      Dialogs.showErrorDialog(
        context: context,
        content: "Por favor, diligencie de manera correcta todos los campos",
      );
      return false;
    }
    return true;
  }

  void _onEmailChanged(SignUpEmailChanged event, Emitter<SignUpState> emit) {
    Email email = Email.dirty(event.email);
    emit(state.copyWith(
      email: email,
      isValid: Formz.validate([email, state.password, state.nickname]),
    ));
  }

  void _onPasswordChanged(
    SignUpPasswordChanged event,
    Emitter<SignUpState> emit,
  ) {
    Password password = Password.dirty(event.password);
    emit(state.copyWith(
      password: password,
      isValid: Formz.validate([state.email, password, state.nickname]),
    ));
  }

  void _onConfirmPasswordChanged(
    SignUpConfirmPasswordChanged event,
    Emitter<SignUpState> emit,
  ) {
    Password confirmPassword = Password.dirty(event.confirmPassword);
    emit(state.copyWith(
      confirmPassword: confirmPassword,
      isValid: Formz.validate([state.email, state.password, confirmPassword]),
    ));
  }

  void _onNicknameChanged(
    SignUpNicknameChanged event,
    Emitter<SignUpState> emit,
  ) {
    Nickname nickname = Nickname.dirty(event.nickname);
    emit(state.copyWith(
      nickname: nickname,
      isValid: Formz.validate([state.email, state.password, nickname]),
    ));
  }
}
