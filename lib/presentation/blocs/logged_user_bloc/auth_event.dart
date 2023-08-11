part of 'auth_bloc.dart';

abstract class AuthEvent {}

class ChangeAuthStatus extends AuthEvent {
  final AuthStatus authStatus;

  ChangeAuthStatus({required this.authStatus});
}

class ChangeToken extends AuthEvent {
  final Token token;

  ChangeToken({required this.token});
}

class CheckToken extends AuthEvent {}

class UserLoggedOut extends AuthEvent {}
