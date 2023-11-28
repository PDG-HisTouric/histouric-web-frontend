import 'package:dio/dio.dart';
import 'package:flutter_polyline_points/src/PointLatLng.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';

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

  @override
  Future<String> getEncodedPolyline(
      LatLng origin, LatLng destination, List<LatLng> waypoint) {
    if (waypoint.isNotEmpty) {
      String waypointString = '';
      for (var i = 0; i < waypoint.length; i++) {
        waypointString += '${waypoint[i].latitude},${waypoint[i].longitude}';
        if (i != waypoint.length - 1 && waypoint.length != 1) {
          waypointString += '|';
        }
        return dio.get(
          queryParameters: {
            'origin': '${origin.latitude},${origin.longitude}',
            'destination': '${destination.latitude},${destination.longitude}',
            'waypoints': waypointString,
          },
          '/directions',
        ).then((value) => DirectionsResponse.fromJson(value.data).encodedPath);
      }
    }
    return dio.get(
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
      },
      '/directions',
    ).then((value) => DirectionsResponse.fromJson(value.data).encodedPath);
  }
}
