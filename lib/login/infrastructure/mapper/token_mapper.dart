import 'package:histouric_web/login/infrastructure/models/token_response.dart';

import '../../domain/entities/token.dart';

class TokenMapper {
  static Token fromTokenResponse(TokenResponse tokenResponse) {
    return Token(
      token: tokenResponse.token,
      roles: tokenResponse.roles,
      userId: tokenResponse.userId,
    );
  }
}
