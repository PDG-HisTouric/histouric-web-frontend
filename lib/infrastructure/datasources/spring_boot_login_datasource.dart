import 'package:dio/dio.dart';

import '../../domain/domain.dart';
import '../mappers/mappers.dart';
import '../models/models.dart';

class SpringBootLoginDatasource implements AuthDatasource {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://histouric-backend.azurewebsites.net/api/v1',
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
