part of 'login_bloc.dart';

enum FormStatus { invalid, valid, validating, posting }

final class LoginFormState {
  final FormStatus formStatus;
  final bool isValid;
  final Nickname nickname;
  final Email email;
  final Password password;

  LoginFormState(
      {this.formStatus = FormStatus.invalid,
      this.isValid = false,
      this.nickname = const Nickname.pure(),
      this.email = const Email.pure(),
      this.password = const Password.pure()});

  LoginFormState copyWith(
      {FormStatus? formStatus,
      bool? isValid,
      Nickname? nickname,
      Email? email,
      Password? password}) {
    return LoginFormState(
        formStatus: formStatus ?? this.formStatus,
        isValid: isValid ?? this.isValid,
        nickname: nickname ?? this.nickname,
        email: email ?? this.email,
        password: password ?? this.password);
  }
}
