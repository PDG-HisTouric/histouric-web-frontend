import 'role_response.dart';

class HistouricUserResponse {
  final String id;
  final String? token;
  final String nickname;
  final String email;
  final List<RoleResponse> roles;

  HistouricUserResponse({
    required this.id,
    required this.token,
    required this.nickname,
    required this.email,
    required this.roles,
  });

  factory HistouricUserResponse.fromJson(Map<String, dynamic> json) =>
      HistouricUserResponse(
        id: json["id"],
        token: json["token"],
        nickname: json["nickname"],
        email: json["email"],
        roles: List<RoleResponse>.from(
          json["roles"].map((x) => RoleResponse.fromJson(x)),
        ),
      );
}
