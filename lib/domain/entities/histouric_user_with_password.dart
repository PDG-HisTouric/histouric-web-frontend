import 'role.dart';

class HistouricUserWithPassword {
  final String id;
  final String? nickname;
  final String? email;
  final String? password;
  final List<String>? roles;

  HistouricUserWithPassword({
    required this.id,
    required this.nickname,
    required this.email,
    this.password,
    this.roles,
  });
}
