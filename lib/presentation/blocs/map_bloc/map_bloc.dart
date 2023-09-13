import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../domain/repositories/repositories.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final BICRepository bicRepository;
  final String token;
  late final int initialLengthOfMarkerId;
  Completer<void> _newMarkerIdCompleter = Completer<void>();
  Completer<void> _markerDeleteCompleter = Completer<void>();

  MapBloc({required this.bicRepository, required this.token})
      : super(MapState(markerFroBICCreationId: 'new-bic-0')) {
    initialLengthOfMarkerId = state.markerFroBICCreationId.length - 1;
    bicRepository.configureToken(token);
    on<MarkerAdded>(_onMarkerAdded);
    on<LastMarkerChanged>(_onLastMarkerChanged);
    on<MapControllerUpdated>(_onMapControllerUpdated);
    on<MarkerIdForBICCreationChanged>(_onMarkerIdForBICCreationChanged);
    on<MarkerDeleted>(_onMarkerDeleted);
  }

  void _onMarkerAdded(
    MarkerAdded event,
    Emitter<MapState> emit,
  ) {
    final marker = Marker(
      markerId: MarkerId(event.markerId),
      position: LatLng(event.latitude, event.longitude),
      infoWindow: InfoWindow(
        title: event.name,
        snippet: event.snippet,
        onTap: event.onInfoWindowTap,
      ),
    );

    emit(state.copyWith(
      markers: [...state.markers, marker],
    ));
  }

  void _onLastMarkerChanged(
    LastMarkerChanged event,
    Emitter<MapState> emit,
  ) {
    final marker = Marker(
      markerId: MarkerId(event.markerId),
      position: LatLng(event.latitude, event.longitude),
      infoWindow: InfoWindow(
        title: event.name,
        snippet: event.snippet,
        onTap: event.onInfoWindowTap,
      ),
    );

    List<Marker> markersWithoutLastMarker =
        state.markers.sublist(0, state.markers.length - 1);
    emit(state.copyWith(
      markers: [...markersWithoutLastMarker, marker],
    ));
  }

  void _onMapControllerUpdated(
    MapControllerUpdated event,
    Emitter<MapState> emit,
  ) {
    emit(state.copyWith(
      controller: event.mapController,
    ));
  }

  Future<void> _onMarkerIdForBICCreationChanged(
    MarkerIdForBICCreationChanged event,
    Emitter<MapState> emit,
  ) async {
    String previousMarkerId = state.markerFroBICCreationId;
    String id = state.markerFroBICCreationId
        .substring(state.markerFroBICCreationId.length - 1);
    String newMarkerId = 'new-bic-${int.parse(id) + 1}';
    emit(state.copyWith(
      markerFroBICCreationId: newMarkerId,
    ));
    while (state.markerFroBICCreationId == previousMarkerId) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    _newMarkerIdCompleter.complete();
  }

  void _onMarkerDeleted(
    MarkerDeleted event,
    Emitter<MapState> emit,
  ) async {
    List<Marker> markersWithoutDeletedMarker = state.markers
        .where((marker) => marker.markerId.value != event.markerId)
        .toList();
    emit(state.copyWith(
      markers: markersWithoutDeletedMarker,
    ));

    while (state.markers.length != markersWithoutDeletedMarker.length) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    _markerDeleteCompleter.complete();
  }

  Future<void> setLastMarker({
    required double latitude,
    required double longitude,
    required String name,
    required String markerId,
    String? snippet,
    void Function()? onInfoWindowTap,
  }) async {
    Marker lastMarker = state.markers.last;
    add(LastMarkerChanged(
      latitude: latitude,
      longitude: longitude,
      name: name,
      markerId: markerId,
      snippet: snippet,
      onInfoWindowTap: onInfoWindowTap,
    ));
    while (state.markers.last == lastMarker) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  void loadBICsFromBICRepository() async {
    final bics = await bicRepository.getBICs();

    for (var bic in bics) {
      add(MarkerAdded(
        latitude: bic.latitude,
        longitude: bic.longitude,
        name: bic.name,
        markerId: bic.bicId!,
        snippet: bic.description,
      ));
    }

    while (state.markers.length != bics.length) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  void setMapController(GoogleMapController controller) async {
    add(MapControllerUpdated(mapController: controller));

    while (controller != state.controller) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  Future<void> addMarker(
      {required double latitude,
      required double longitude,
      required String name,
      required String markerId,
      String? snippet,
      void Function()? onInfoWindowTap}) async {
    int currentNumberOfMarkers = state.markers.length;
    add(MarkerAdded(
      latitude: latitude,
      longitude: longitude,
      name: name,
      markerId: markerId,
      snippet: snippet,
      onInfoWindowTap: onInfoWindowTap,
    ));
    while (state.markers.length != currentNumberOfMarkers + 1) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  Future<void> changeMarkerIdForBICCreation() async {
    add(MarkerIdForBICCreationChanged());
    await _newMarkerIdCompleter.future;
    _newMarkerIdCompleter = Completer<void>();
  }

  Future<void> deleteMarker(String markerId) async {
    add(MarkerDeleted(markerId: markerId));
    await _markerDeleteCompleter.future;
    _markerDeleteCompleter = Completer<void>();
  }
}
