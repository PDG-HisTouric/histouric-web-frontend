import 'package:google_maps_flutter_platform_interface/src/types/location.dart';

import '../../domain/domain.dart';
import '../models/models.dart';

class RouteRepositoryImpl extends RouteRepository {
  final RouteDatasource routeDatasource;

  RouteRepositoryImpl({required this.routeDatasource});

  @override
  void configureToken(String token) {
    routeDatasource.configureToken(token);
  }

  @override
  Future<HistouricRoute> createRoute(RouteCreation route) {
    return routeDatasource.createRoute(route);
  }

  @override
  Future<String> getEncodedPolyline(
      LatLng origin, LatLng destination, List<LatLng> waypoint) {
    return routeDatasource.getEncodedPolyline(origin, destination, waypoint);
  }
}
