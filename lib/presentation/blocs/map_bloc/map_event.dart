part of 'map_bloc.dart';

abstract class MapEvent {}

class BICsLoaded extends MapEvent {}

class MarkersSetted extends MapEvent {
  final List<Marker> markers;

  MarkersSetted({required this.markers});
}

class PolylinesSetted extends MapEvent {
  final Map<PolylineId, Polyline> polylines;

  PolylinesSetted({required this.polylines});
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
