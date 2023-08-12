import '../entities/histouric_user.dart';
import '../entities/token.dart';

abstract class AuthDatasource {
  Future<Token> login(String email, String password);

  Future<HistouricUser> register(
    String nickname,
    String email,
    String password,
  );
}
