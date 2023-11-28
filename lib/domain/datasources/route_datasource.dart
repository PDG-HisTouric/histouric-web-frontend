import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../infrastructure/models/models.dart';
import '../entities/entities.dart';

abstract class RouteDatasource {
  Future<HistouricRoute> createRoute(RouteCreation route);
  Future<String> getEncodedPolyline(
    LatLng origin,
    LatLng destination,
    List<LatLng> waypoint,
  );
  void configureToken(String token);
}
