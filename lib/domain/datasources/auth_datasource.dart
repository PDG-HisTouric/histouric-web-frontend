import '../entities/entities.dart';

abstract class AuthDatasource {
  Future<Token> login(String email, String password);

  Future<HistouricUser> signUp(
    String nickname,
    String email,
    String password,
  );
}
