import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/repositories.dart';

part 'route_event.dart';
part 'route_state.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  final BICRepository bicRepository;
  final String token;
  Completer<void> changeBICCompleter = Completer<void>();

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

  void _onBICAdded(BICAdded event, Emitter<RouteState> emit) {
    emit(state.copyWith(bicsForRoute: [...state.bicsForRoute, event.bic]));
  }

  void _onBICDeleted(BICDeleted event, Emitter<RouteState> emit) {
    emit(state.copyWith(
        bicsForRoute: state.bicsForRoute..removeAt(event.index)));
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
    changeBICCompleter.complete();
  }

  void addBIC(BIC bic) {
    add(BICAdded(bic: bic));
    state.searchController.clear();
    changeSearchTextField("");
  }

  void deleteBIC(int index) {
    add(BICDeleted(index: index));
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
    await changeBICCompleter.future;
    changeBICCompleter = Completer<void>();
  }
}
