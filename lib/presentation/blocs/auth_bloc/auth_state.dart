part of 'auth_bloc.dart';

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final String? token;
  final String? id;
  final AuthStatus authStatus;
  final String? nickname;
  final String? email;
  final List<String>? roles;

  AuthState({
    this.id,
    this.token,
    this.authStatus = AuthStatus.checking,
    this.nickname,
    this.email,
    this.roles,
  });

  AuthState copyWith({
    String? id,
    String? token,
    AuthStatus? authStatus,
    String? nickname,
    String? email,
    List<String>? roles,
  }) {
    return AuthState(
      id: id ?? this.id,
      token: token ?? this.token,
      authStatus: authStatus ?? this.authStatus,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      roles: roles ?? this.roles,
    );
  }
}
