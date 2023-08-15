import '../../domain/domain.dart';
import '../models/models.dart';

class TokenMapper {
  static Token fromTokenResponse(TokenResponse tokenResponse) {
    return Token(token: tokenResponse.token, nickname: tokenResponse.nickname);
  }
}
