import 'role.dart';

class Token {
  final String token;
  final String userId;
  final List<String> roles;

  Token({
    required this.token,
    required this.userId,
    required this.roles,
  });
}
