import '../entities/entities.dart';

abstract class AuthRepository {
  Future<Token> login(String email, String password);

  Future<HistouricUser> register(
    String email,
    String password,
    String nickname,
  );
}
