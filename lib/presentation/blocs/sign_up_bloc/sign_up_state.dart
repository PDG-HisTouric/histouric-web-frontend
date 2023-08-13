part of 'sign_up_bloc.dart';

class SignUpState {
  final Email email;
  final Password password;
  final Password confirmPassword;
  final Nickname nickname;
  final bool isValid;

  SignUpState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = const Password.pure(),
    this.nickname = const Nickname.pure(),
    this.isValid = false,
  });

  SignUpState copyWith({
    Email? email,
    Password? password,
    Password? confirmPassword,
    Nickname? nickname,
    bool? isValid,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      nickname: nickname ?? this.nickname,
      isValid: isValid ?? this.isValid,
    );
  }
}
