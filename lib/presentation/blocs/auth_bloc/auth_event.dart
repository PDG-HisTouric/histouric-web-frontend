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

class UserChanged extends AuthEvent {
  final String id;
  final String nickname;
  final String email;
  final List<String> roles;
  final String? token;

  UserChanged({
    required this.id,
    required this.nickname,
    required this.email,
    required this.roles,
    this.token,
  });
}

class UserLoadedFromAdmin extends AuthEvent {
  String nickname;

  UserLoadedFromAdmin({
    required this.nickname,
  });
}

class TokenChanged extends AuthEvent {
  final String token;

  TokenChanged({required this.token});
}
