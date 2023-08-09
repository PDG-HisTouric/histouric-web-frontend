import 'package:histouric_web/login/domain/entities/histouric_user.dart';
import 'package:histouric_web/login/domain/entities/token.dart';

abstract class AuthDatasource {
  Future<Token> login(String email, String password);
  Future<HistouricUser> register(
      String nickname, String email, String password);
}
