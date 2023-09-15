import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repositories.dart';

part 'route_event.dart';
part 'route_state.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  final BICRepository bicRepository;
  final String token;
  Completer<void> _changeBICCompleter = Completer<void>();
  Completer<BIC> _newBICCompleter = Completer<BIC>();
  Completer<void> _deleteBICCompleter = Completer<void>();

  RouteBloc({required this.bicRepository, required this.token})
      : super(RouteState()) {
    bicRepository.configureToken(token);
    state.initSearchController();
    on<RouteNameChanged>(_onRouteNameChanged);
    on<BICAdded>(_onBICAdded);
    on<BICDeleted>(_onBICDeleted);
    on<SearchTextFieldChanged>(_onSearchTextFieldChanged);
    on<BICsOrderChanged>(_onBICsOrderChanged);
  }

  void _onRouteNameChanged(RouteNameChanged event, Emitter<RouteState> emit) {
    emit(state.copyWith(name: event.name));
  }

  void _onBICAdded(BICAdded event, Emitter<RouteState> emit) async {
    int previousLength = state.bicsForRoute.length;
    BIC bic = event.bic;
    BIC newBIC = BIC(
      bicId: '${bic.bicId}${state.counter}',
      name: bic.name,
      latitude: bic.latitude,
      longitude: bic.longitude,
      description: bic.description,
      exists: bic.exists,
      nicknames: bic.nicknames,
      imagesUris: bic.imagesUris,
      histories: bic.histories,
    );
    emit(state.copyWith(
        bicsForRoute: [...state.bicsForRoute, newBIC],
        counter: state.counter + 1));
    while (state.bicsForRoute.length != previousLength + 1) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    _newBICCompleter.complete(newBIC);
  }

  void _onBICDeleted(BICDeleted event, Emitter<RouteState> emit) async {
    int previousLength = state.bicsForRoute.length;
    emit(state.copyWith(
        bicsForRoute: state.bicsForRoute..removeAt(event.index)));
    while (state.bicsForRoute.length != previousLength - 1) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    _deleteBICCompleter.complete();
  }

  void _onSearchTextFieldChanged(
      SearchTextFieldChanged event, Emitter<RouteState> emit) async {
    List<BIC> bicList = [];
    if (event.searchTextField.isNotEmpty) {
      bicList =
          await bicRepository.getBICsByNameOrNickname(event.searchTextField);
    }
    emit(state.copyWith(
        searchTextField: event.searchTextField, bicsForSearch: bicList));
  }

  void _onBICsOrderChanged(
      BICsOrderChanged event, Emitter<RouteState> emit) async {
    int newIndex = event.newIndex;
    if (event.oldIndex < event.newIndex) newIndex--;
    List<BIC> bicsForRoute = state.bicsForRoute;
    final BIC bic = bicsForRoute.removeAt(event.oldIndex);
    bicsForRoute.insert(newIndex, bic);
    emit(state.copyWith(bicsForRoute: bicsForRoute));
    while (state.bicsForRoute != bicsForRoute) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    _changeBICCompleter.complete();
  }

  Future<BIC> addBIC(BIC bic) async {
    add(BICAdded(bic: bic));
    BIC bicCreated = await _newBICCompleter.future;
    _newBICCompleter = Completer<BIC>();
    state.searchController.clear();
    changeSearchTextField("");
    return bicCreated;
  }

  Future<void> deleteBIC(int index) async {
    add(BICDeleted(index: index));
    await _deleteBICCompleter.future;
    _deleteBICCompleter = Completer<void>();
  }

  void changeRouteName(String name) {
    add(RouteNameChanged(name: name));
  }

  void changeSearchTextField(String searchTextField) {
    add(SearchTextFieldChanged(searchTextField: searchTextField));
  }

  Future<void> changeBICsOrder(
      {required int oldIndex, required int newIndex}) async {
    add(BICsOrderChanged(oldIndex: oldIndex, newIndex: newIndex));
    await _changeBICCompleter.future;
    _changeBICCompleter = Completer<void>();
  }
}
