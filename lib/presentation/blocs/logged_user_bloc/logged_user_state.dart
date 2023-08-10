part of 'logged_user_bloc.dart';

enum AuthStatus { checking, authenticated, notAuthenticated }

class LoggedUserState {
  final String? token;
  final AuthStatus authStatus;
  final String? nickname;
  final String? email;
  final List<String>? roles;

  LoggedUserState({
    this.token,
    this.authStatus = AuthStatus.checking,
    this.nickname,
    this.email,
    this.roles,
  });

  LoggedUserState copyWith({
    String? token,
    AuthStatus? authStatus,
    String? nickname,
    String? email,
    List<String>? roles,
  }) {
    return LoggedUserState(
      token: token ?? this.token,
      authStatus: authStatus ?? this.authStatus,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      roles: roles ?? this.roles,
    );
  }
}
