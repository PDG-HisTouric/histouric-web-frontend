part of 'sign_up_bloc.dart';

abstract class SignUpEvent {}

class SignUpEmailChanged extends SignUpEvent {
  final String email;

  SignUpEmailChanged({required this.email});
}

class SignUpPasswordChanged extends SignUpEvent {
  final String password;

  SignUpPasswordChanged({required this.password});
}

class SignUpConfirmPasswordChanged extends SignUpEvent {
  final String confirmPassword;

  SignUpConfirmPasswordChanged({required this.confirmPassword});
}

class SignUpNicknameChanged extends SignUpEvent {
  final String nickname;

  SignUpNicknameChanged({required this.nickname});
}

class SignUpSubmitted extends SignUpEvent {}

class SignUpTouchedEveryField extends SignUpEvent {}
