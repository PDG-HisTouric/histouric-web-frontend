import '../entities/histouric_user.dart';
import '../entities/token.dart';

abstract class AuthRepository {
  Future<Token> login(String email, String password);

  Future<HistouricUser> register(
    String email,
    String password,
    String nickname,
  );
}
