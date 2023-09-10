part of 'map_bloc.dart';

abstract class MapEvent {}

class BICsLoaded extends MapEvent {}

class LastMarkerChanged extends MapEvent {
  final double latitude;
  final double longitude;
  final String name;
  final String markerId;
  final String? snippet;

  LastMarkerChanged({
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.markerId,
    this.snippet,
  });
}

class MarkerAdded extends MapEvent {
  final double latitude;
  final double longitude;
  final String name;
  final String markerId;
  final String? snippet;

  MarkerAdded({
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.markerId,
    this.snippet,
  });
}

class PolylinesEstablished extends MapEvent {
  final Map<PolylineId, Polyline> polylines;

  PolylinesEstablished({required this.polylines});
}

class MapControllerUpdated extends MapEvent {
  final GoogleMapController mapController;

  MapControllerUpdated({required this.mapController});
}

class FocusLocationChanged extends MapEvent {
  final double latitude;
  final double longitude;

  FocusLocationChanged({required this.latitude, required this.longitude});
}
