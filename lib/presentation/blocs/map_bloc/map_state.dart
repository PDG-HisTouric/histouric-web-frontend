part of 'map_bloc.dart';

class MapState {
  final List<Marker> markers;
  final GoogleMapController? controller;
  final Map<PolylineId, Polyline> polylines;

  MapState({
    this.markers = const [],
    this.controller,
    this.polylines = const {},
  });

  Set<Marker> get markersSet {
    return Set.from(markers);
  }

  MapState copyWith({
    List<Marker>? markers,
    GoogleMapController? controller,
    Map<PolylineId, Polyline>? polylines,
  }) {
    return MapState(
      markers: markers ?? this.markers,
      controller: controller ?? this.controller,
      polylines: polylines ?? this.polylines,
    );
  }
}
