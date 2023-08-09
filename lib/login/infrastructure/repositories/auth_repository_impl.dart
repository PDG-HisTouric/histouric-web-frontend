import 'package:histouric_web/login/domain/datasources/auth_datasource.dart';
import 'package:histouric_web/login/domain/entities/histouric_user.dart';
import 'package:histouric_web/login/domain/entities/token.dart';
import 'package:histouric_web/login/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource authDatasource;

  AuthRepositoryImpl({
    required this.authDatasource,
  });

  @override
  Future<Token> login(String email, String password) {
    return authDatasource.login(email, password);
  }

  @override
  Future<HistouricUser> register(
      String nickname, String email, String password) {
    return authDatasource.register(nickname, email, password);
  }
}
