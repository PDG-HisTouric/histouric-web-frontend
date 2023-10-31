import 'package:dio/dio.dart';

import '../../config/constants/constants.dart';
import '../../domain/domain.dart';
import '../mappers/mappers.dart';
import '../models/models.dart';

class RouteDatasourceImpl implements RouteDatasource {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: '${Environment.baseUrl}/api/v1/routes',
      contentType: 'application/json',
    ),
  );

  @override
  void configureToken(String token) {
    dio.options.headers = {'Authorization': 'Bearer $token'};
  }

  @override
  Future<HistouricRoute> createRoute(RouteCreation route) {
    final data = RouteMapper.fromRouteCreationToMap(route);
    return dio.post('', data: data).then((value) =>
        RouteMapper.fromRouteResponseToRoute(
            RouteResponse.fromJson(value.data)));
  }
}
