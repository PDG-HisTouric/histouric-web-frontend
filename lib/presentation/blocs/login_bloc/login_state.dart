part of 'login_bloc.dart';

final class LoginFormState {
  final bool isValid;
  final Nickname nickname;
  final Email email;
  final Password password;
  final bool showMessageError;

  LoginFormState({
    this.isValid = false,
    this.nickname = const Nickname.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.showMessageError = false,
  });

  LoginFormState copyWith({
    bool? isValid,
    Nickname? nickname,
    Email? email,
    Password? password,
  }) {
    return LoginFormState(
      isValid: isValid ?? this.isValid,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
