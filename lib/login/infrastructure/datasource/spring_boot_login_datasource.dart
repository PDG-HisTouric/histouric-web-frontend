import 'package:dio/dio.dart';
import 'package:histouric_web/login/domain/datasources/auth_datasource.dart';
import 'package:histouric_web/login/domain/entities/histouric_user.dart';
import 'package:histouric_web/login/domain/entities/token.dart';
import 'package:histouric_web/login/infrastructure/mapper/token_mapper.dart';
import 'package:histouric_web/login/infrastructure/models/token_response.dart';

class SpringBootLoginDatasource implements AuthDatasource {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:8080/api/v1',
      contentType: 'application/json',
    ),
  );

  @override
  Future<Token> login(String email, String password) async {
    final user = {
      'email': email,
      'password': password,
    };
    final response = await dio.post('/auth/login', data: user);
    TokenResponse tokenResponse = TokenResponse.fromJson(response.data);
    return TokenMapper.fromTokenResponse(tokenResponse);
  }

  @override
  Future<HistouricUser> register(
      String nickname, String email, String password) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
