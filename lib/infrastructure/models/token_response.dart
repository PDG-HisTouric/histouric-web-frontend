class TokenResponse {
  final String token;
  final List<String> roles;
  final String userId;

  TokenResponse({
    required this.token,
    required this.roles,
    required this.userId,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) => TokenResponse(
        token: json["token"],
        roles: List<String>.from(json["roles"].map((x) => x)),
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "roles": List<dynamic>.from(roles.map((x) => x)),
        "userId": userId,
      };
}
