import 'package:histouric_web/infrastructure/models/role_response.dart';

class HistouricUserResponse {
  final String id;
  final String nickname;
  final String email;
  final List<RoleResponse> roles;

  HistouricUserResponse({
    required this.id,
    required this.nickname,
    required this.email,
    required this.roles,
  });

  factory HistouricUserResponse.fromJson(Map<String, dynamic> json) =>
      HistouricUserResponse(
        id: json["id"],
        nickname: json["nickname"],
        email: json["email"],
        roles: List<RoleResponse>.from(
            json["roles"].map((x) => RoleResponse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nickname": nickname,
        "email": email,
        "roles": List<dynamic>.from(roles.map((x) => x.toJson())),
      };
}
