import 'package:dio/dio.dart';
import 'package:histouric_web/domain/datasources/datasources.dart';
import 'package:histouric_web/domain/entities/history.dart';
import 'package:histouric_web/infrastructure/infrastructure.dart';
import 'package:histouric_web/infrastructure/models/history_creation.dart';

import '../../config/constants/environment.dart';

class HistoryDatasourceImpl implements HistoryDatasource {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: '${Environment.baseUrl}/api/v1/histories',
      contentType: 'application/json',
    ),
  );

  @override
  void configureToken(String token) {
    dio.options.headers = {'Authorization': 'Bearer $token'};
  }

  @override
  Future<History> createHistory(HistoryCreation historyCreation) {
    return dio
        .post('', data: HistoryMapper.fromHistoryCreatioToMap(historyCreation))
        .then((value) => HistoryMapper.fromHistoryResponseToHistory(
            HistoryResponse.fromJson(value.data)));
  }
}
