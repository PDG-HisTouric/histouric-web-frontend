import '../../domain/domain.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource authDatasource;

  AuthRepositoryImpl({required this.authDatasource});

  @override
  Future<Token> login(String email, String password) {
    return authDatasource.login(email, password);
  }

  @override
  Future<HistouricUser> register(
    String nickname,
    String email,
    String password,
  ) {
    return authDatasource.register(nickname, email, password);
  }
}
