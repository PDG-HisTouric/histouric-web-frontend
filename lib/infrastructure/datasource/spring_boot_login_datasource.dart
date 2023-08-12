import 'package:dio/dio.dart';
import 'package:histouric_web/infrastructure/models/histouric_user_response.dart';

import '../../domain/datasources/auth_datasource.dart';
import '../../domain/entities/histouric_user.dart';
import '../../domain/entities/token.dart';
import '../mapper/histouric_user_mapper.dart';
import '../mapper/token_mapper.dart';
import '../models/token_response.dart';

class SpringBootLoginDatasource implements AuthDatasource {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:8080/api/v1',
      contentType: 'application/json',
    ),
  );

  @override
  Future<Token> login(String email, String password) async {
    return await dio
        .post('/auth/login', data: {'email': email, 'password': password})
        .then(
          (response) => TokenMapper.fromTokenResponse(
            TokenResponse.fromJson(response.data),
          ),
        )
        .catchError((e) => throw e);
  }

  @override
  Future<HistouricUser> register(
    String email,
    String password,
    String nickname,
  ) async {
    return await dio
        .post('/users', data: {
          'nickname': nickname,
          'email': email,
          'password': password,
        })
        .then(
          (response) => HistouricUserMapper.fromHistouricUserResponse(
            HistouricUserResponse.fromJson(response.data),
          ),
        )
        .catchError((e) => throw e);
  }
}
