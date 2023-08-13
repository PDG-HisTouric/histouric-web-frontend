import 'package:dio/dio.dart';
import 'package:histouric_web/domain/datasources/datasources.dart';
import 'package:histouric_web/domain/entities/entities.dart';
import 'package:histouric_web/infrastructure/mapper/mappers.dart';
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
  Future<void> deleteUserById(String id) async {
    await dio.delete('/$id');
  }

  @override
  Future<HistouricUser> getUserByNickname(String nickname) async {
    final response = await dio.get('/$nickname');
    HistouricUserResponse histouricUserResponse =
        HistouricUserResponse.fromJson(response.data);
    return HistouricUserMapper.fromHistouricUserResponse(histouricUserResponse);
  }

  @override
  Future<List<HistouricUser>> getUsers() async {
    return await dio.get('/').then((response) {
      List<HistouricUserResponse> histouricUserResponses =
          (response.data as List)
              .map((e) => HistouricUserResponse.fromJson(e))
              .toList();
      return histouricUserResponses
          .map((e) => HistouricUserMapper.fromHistouricUserResponse(e))
          .toList();
    }).catchError((e) => throw e);
  }

  @override
  Future<HistouricUser> updateUserById(
      String id, HistouricUserWithPassword histouricUser) async {
    try {
      final data = HistouricUserWithPasswordMapper.toMap(histouricUser);
      final response = await dio.put('/$id', data: data);
      HistouricUserResponse histouricUserResponse =
          HistouricUserResponse.fromJson(response.data);
      configureToken(histouricUserResponse.token!);
      return HistouricUserMapper.fromHistouricUserResponse(
          histouricUserResponse);
    } on DioException catch (e) {
      String errorMessage = e.response!.data['message'];
      if (errorMessage.contains("user_nickname") &&
          errorMessage.contains("already exists")) {
        throw Exception('El nombre de usuario ya existe');
      }
      throw Exception('Ocurrió un error al guardar los cambios');
    }
  }
}
