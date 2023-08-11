import 'package:dio/dio.dart';
import 'package:histouric_web/domain/datasources/datasources.dart';
import 'package:histouric_web/domain/entities/histouric_user.dart';
import 'package:histouric_web/infrastructure/mapper/histouric_user_mapper.dart';
import 'package:histouric_web/infrastructure/models/histouric_user_response.dart';

class SpringBootUserDatasource extends UserDatasource {
  late final Dio dio;

  SpringBootUserDatasource() {
    dio = Dio(BaseOptions(
      baseUrl: 'http://localhost:8080/api/v1/users',
      contentType: 'application/json',
    ));
  }

  @override
  void configureToken(String token) {
    dio.options.headers = {'Authorization': 'Bearer $token'};
  }

  @override
  Future<void> deleteUserById(String id) {
    // TODO: implement deleteUserById
    throw UnimplementedError();
  }

  @override
  Future<HistouricUser> getUserByNickname(String nickname) async {
    final response = await dio.get('/$nickname');
    HistouricUserResponse histouricUserResponse =
        HistouricUserResponse.fromJson(response.data);
    return HistouricUserMapper.fromHistouricUserResponse(histouricUserResponse);
  }

  @override
  Future<List<HistouricUser>> getUsers() {
    // TODO: implement getUsers
    throw UnimplementedError();
  }

  @override
  Future<HistouricUser> updateUserById(String id, HistouricUser histouricUser) {
    // TODO: implement updateUserById
    throw UnimplementedError();
  }
}
