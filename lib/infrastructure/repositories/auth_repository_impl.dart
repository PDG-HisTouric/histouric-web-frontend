import '../../domain/domain.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource authDatasource;

  AuthRepositoryImpl({required this.authDatasource});

  @override
  Future<Token> signIn(String email, String password) {
    return authDatasource.login(email, password);
  }

  @override
  Future<HistouricUser> signUp(
    String nickname,
    String email,
    String password,
  ) {
    return authDatasource.signUp(nickname, email, password);
  }
}
