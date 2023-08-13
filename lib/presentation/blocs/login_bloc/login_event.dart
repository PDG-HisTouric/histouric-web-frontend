part of 'login_bloc.dart';

abstract class LoginFormEvent {}

class LoginEmailChanged extends LoginFormEvent {
  final String email;

  LoginEmailChanged({required this.email});
}

class LoginPasswordChanged extends LoginFormEvent {
  final String password;

  LoginPasswordChanged({required this.password});
}

class LoginSubmitted extends LoginFormEvent {}
