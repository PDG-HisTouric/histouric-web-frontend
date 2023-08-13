part of 'auth_bloc.dart';

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final String? token;
  final AuthStatus authStatus;
  final String? nickname;
  final String? email;
  final List<String>? roles;

  AuthState({
    this.token,
    this.authStatus = AuthStatus.checking,
    this.nickname,
    this.email,
    this.roles,
  });

  AuthState copyWith({
    String? token,
    AuthStatus? authStatus,
    String? nickname,
    String? email,
    List<String>? roles,
  }) {
    return AuthState(
      token: token ?? this.token,
      authStatus: authStatus ?? this.authStatus,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      roles: roles ?? this.roles,
    );
  }
}
