part of 'logged_user_bloc.dart';

abstract class LoggedUserEvent {}

class ChangeAuthStatus extends LoggedUserEvent {
  final AuthStatus authStatus;

  ChangeAuthStatus({required this.authStatus});
}

class ChangeToken extends LoggedUserEvent {
  final Token token;

  ChangeToken({required this.token});
}

class CheckToken extends LoggedUserEvent {}
