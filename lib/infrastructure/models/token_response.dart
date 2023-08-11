class TokenResponse {
  final String token;
  final String nickname;

  TokenResponse({
    required this.token,
    required this.nickname,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) => TokenResponse(
        token: json["token"],
        nickname: json["nickname"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "nickname": nickname,
      };
}
