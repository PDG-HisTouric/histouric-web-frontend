part of 'map_bloc.dart';

class MapState {
  final List<Marker> markers;
  final GoogleMapController? controller;
  final Map<PolylineId, Polyline> polylines;
  final String markerFroBICCreationId;

  MapState({
    this.markers = const [],
    this.controller,
    this.polylines = const {},
    required this.markerFroBICCreationId,
  });

  Set<Marker> get markersSet {
    return Set.from(markers);
  }

  MapState copyWith({
    List<Marker>? markers,
    GoogleMapController? controller,
    Map<PolylineId, Polyline>? polylines,
    String? markerFroBICCreationId,
  }) {
    return MapState(
      markers: markers ?? this.markers,
      controller: controller ?? this.controller,
      polylines: polylines ?? this.polylines,
      markerFroBICCreationId:
          markerFroBICCreationId ?? this.markerFroBICCreationId,
    );
  }
}
