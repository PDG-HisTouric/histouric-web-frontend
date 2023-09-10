part of 'map_bloc.dart';

class MapState {
  final bool isControllerReady;
  final List<Marker> markers;
  final GoogleMapController? controller;
  final Map<PolylineId, Polyline> polylines;

  MapState({
    this.isControllerReady = false,
    this.markers = const [],
    this.controller,
    this.polylines = const {},
  });

  Set<Marker> get markersSet {
    return Set.from(markers);
  }

  MapState copyWith({
    bool? isControllerReady,
    List<Marker>? markers,
    GoogleMapController? controller,
    Map<PolylineId, Polyline>? polylines,
  }) {
    return MapState(
      isControllerReady: isControllerReady ?? this.isControllerReady,
      markers: markers ?? this.markers,
      controller: controller ?? this.controller,
      polylines: polylines ?? this.polylines,
    );
  }
}
