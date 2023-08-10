import '../../domain/entities/token.dart';
import '../models/token_response.dart';

class TokenMapper {
  static Token fromTokenResponse(TokenResponse tokenResponse) {
    return Token(
      token: tokenResponse.token,
      roles: tokenResponse.roles,
      userId: tokenResponse.userId,
    );
  }
}
