import 'role.dart';

class HistouricUser {
  final String id;
  final String nickname;
  final String email;
  final List<Role> roles;
  final String? token;

  HistouricUser({
    required this.id,
    required this.nickname,
    required this.email,
    required this.roles,
    this.token,
  });
}
