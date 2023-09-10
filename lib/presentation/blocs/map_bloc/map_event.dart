part of 'map_bloc.dart';

abstract class MapEvent {}

class BICsLoaded extends MapEvent {}

class LastMarkerChanged extends MapEvent {
  final double latitude;
  final double longitude;
  final String name;
  final String markerId;
  final String? snippet;
  final void Function()? onInfoWindowTap;

  LastMarkerChanged({
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.markerId,
    this.snippet,
    this.onInfoWindowTap,
  });
}

class MarkerAdded extends MapEvent {
  final double latitude;
  final double longitude;
  final String name;
  final String markerId;
  final String? snippet;
  final void Function()? onInfoWindowTap;

  MarkerAdded({
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.markerId,
    this.snippet,
    this.onInfoWindowTap,
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
