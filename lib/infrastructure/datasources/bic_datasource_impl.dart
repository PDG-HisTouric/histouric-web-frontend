import 'package:dio/dio.dart';
import 'package:histouric_web/domain/entities/bic.dart';
import 'package:histouric_web/infrastructure/infrastructure.dart';
import 'package:histouric_web/infrastructure/mappers/bic_mapper.dart';

import '../../config/constants/constants.dart';
import '../../domain/datasources/datasources.dart';

class BICDatasourceImpl implements BICDatasource {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: '${Environment.baseUrl}/api/v1/bics',
      contentType: 'application/json',
    ),
  );

  @override
  void configureToken(String token) {
    dio.options.headers = {'Authorization': 'Bearer $token'};
  }

  @override
  Future<BIC> createBIC(BIC bic) {
    return dio.post('', data: BICMapper.toMap(bic)).then(
          (response) =>
              BICMapper.fromBICResponse(BICResponse.fromJson(response.data)),
        );
  }

  @override
  Future<List<BIC>> getBICs() {
    return dio.get('').then((response) {
      List<BICResponse> bicResponses =
          (response.data as List).map((e) => BICResponse.fromJson(e)).toList();

      return bicResponses.map((e) => BICMapper.fromBICResponse(e)).toList();
    });
  }

  @override
  Future<List<BIC>> getBICsByNameOrNickname(String nameOrNickname) {
    return dio.get('/name/$nameOrNickname').then((response) {
      List<BICResponse> bicResponses =
          (response.data as List).map((e) => BICResponse.fromJson(e)).toList();

      return bicResponses.map((e) => BICMapper.fromBICResponse(e)).toList();
    });
  }
}
