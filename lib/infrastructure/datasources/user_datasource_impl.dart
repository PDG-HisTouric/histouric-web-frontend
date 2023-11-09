import 'package:dio/dio.dart';

import '../../config/constants/constants.dart';
import '../../domain/domain.dart';
import '../mappers/mappers.dart';
import '../models/models.dart';

class UserDatasourceImpl extends UserDatasource {
  late final Dio dio;

  UserDatasourceImpl() {
    dio = Dio(BaseOptions(
      baseUrl: '${Environment.baseUrl}/api/v1/users',
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
  Future<List<HistouricUser>> getUsersByNickname(String nickname) async {
    if (nickname.isEmpty) return [];

    final response = await dio.get('/all/$nickname');

    List<HistouricUserResponse> histouricUserResponses = (response.data as List)
        .map((e) => HistouricUserResponse.fromJson(e))
        .toList();

    return histouricUserResponses
        .map((e) => HistouricUserMapper.fromHistouricUserResponse(e))
        .toList();
  }

  @override
  Future<List<HistouricUser>> getUsers() async {
    return await dio.get('').then((response) {
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
    String id,
    HistouricUserWithPassword histouricUserWithPassword,
  ) async {
    try {
      final data =
          HistouricUserWithPasswordMapper.toMap(histouricUserWithPassword);
      final response = await dio.put('/$id', data: data);

      HistouricUserResponse histouricUserResponse =
          HistouricUserResponse.fromJson(response.data);

      configureToken(histouricUserResponse.token!);

      return HistouricUserMapper.fromHistouricUserResponse(
        histouricUserResponse,
      );
    } on DioException catch (e) {
      String errorMessage = e.response!.data['message'];

      if (errorMessage.contains(
          "Key (user_nickname)=(${histouricUserWithPassword.nickname}) already exists")) {
        throw Exception('El nombre de usuario ya existe');
      }
      if (errorMessage.contains(
          "Key (user_email)=(${histouricUserWithPassword.email}) already exists")) {
        throw Exception('El correo electrónico ya existe');
      }
      if (errorMessage ==
          "Not enough permissions. You can't remove the last admin role") {
        throw Exception(
          'No tienes permisos. No puedes eliminar el ultimo rol de administrador',
        );
      }
      throw Exception('Ocurrió un error al guardar los cambios');
    }
  }

  @override
  Future<HistouricUser> registerUser(
    HistouricUserWithPassword histouricUserWithPassword,
  ) {
    return dio
        .post('',
            data: HistouricUserWithPasswordMapper.toMap(
                histouricUserWithPassword))
        .then(
          (response) => HistouricUserMapper.fromHistouricUserResponse(
            HistouricUserResponse.fromJson(response.data),
          ),
        )
        .catchError((e) => throw e);
  }
}
