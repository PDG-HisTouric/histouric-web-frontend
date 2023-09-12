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
    return dio.post('/', data: bic).then(
          (response) => BICMapper.fromBICResponse(response.data),
        );
  }

  @override
  Future<List<BIC>> getBICs() {
    return dio.get('').then((response) {
      var temp = response.data;
      List<BICResponse> bicResponses =
          (response.data as List).map((e) => BICResponse.fromJson(e)).toList();

      return bicResponses.map((e) => BICMapper.fromBICResponse(e)).toList();
    });
  }
}
