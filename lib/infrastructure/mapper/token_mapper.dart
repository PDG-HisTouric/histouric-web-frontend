import '../../domain/entities/token.dart';
import '../models/token_response.dart';

class TokenMapper {
  static Token fromTokenResponse(TokenResponse tokenResponse) {
    return Token(
      token: tokenResponse.token,
      nickname: tokenResponse.nickname,
    );
  }
}
