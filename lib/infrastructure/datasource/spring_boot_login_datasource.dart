import 'package:dio/dio.dart';

import '../../domain/datasources/auth_datasource.dart';
import '../../domain/entities/histouric_user.dart';
import '../../domain/entities/token.dart';
import '../mapper/token_mapper.dart';
import '../models/token_response.dart';

class SpringBootLoginDatasource implements AuthDatasource {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:8080/api/v1/auth',
      contentType: 'application/json',
    ),
  );

  @override
  Future<Token> login(String email, String password) async {
    final user = {
      'email': email,
      'password': password,
    };
    final response = await dio.post('/login', data: user);
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
