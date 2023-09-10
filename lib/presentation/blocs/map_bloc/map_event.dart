part of 'map_bloc.dart';

abstract class MapEvent {}

class BICsLoaded extends MapEvent {}

class MarkersEstablished extends MapEvent {
  final List<Marker> markers;

  MarkersEstablished({required this.markers});
}

class MarkerEstablished extends MapEvent {
  final double latitude;
  final double longitude;
  final String name;
  final String bicId;
  final String? snippet;

  MarkerEstablished({
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.bicId,
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
