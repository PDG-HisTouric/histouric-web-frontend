import '../entities/entities.dart';

abstract class AuthRepository {
  Future<Token> signIn(String email, String password);

  Future<HistouricUser> signUp(
    String email,
    String password,
    String nickname,
  );
}
