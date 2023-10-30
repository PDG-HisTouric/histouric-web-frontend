import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../domain/domain.dart';

part 'route_event.dart';
part 'route_state.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  final BICRepository bicRepository;
  final String token;
  late final double _bicSelectedHeight;
  late final double _bicSearchedHeight;
  late final double _heightOfTheWidgetFixedInTheTopOfTheScrollBar;
  late final double _heightOfTheWidgetFixedInTheBottomOfTheScrollBar;
  late final double _minHeightOfTheRouteForm;
  late final double _sideMenuWidth;
  Completer<void> _changeBICCompleter = Completer<void>();
  Completer<BIC> _newBICCompleter = Completer<BIC>();
  Completer<void> _deleteBICCompleter = Completer<void>();

  RouteBloc({required this.bicRepository, required this.token})
      : super(RouteState()) {
    bicRepository.configureToken(token);
    state.initSearchController();
    _bicSelectedHeight = 180;
    _bicSearchedHeight = 120;
    _heightOfTheWidgetFixedInTheTopOfTheScrollBar = 45;
    _heightOfTheWidgetFixedInTheBottomOfTheScrollBar = 55;
    _minHeightOfTheRouteForm = 747.2000122070312;
    _sideMenuWidth = 400;
    on<RouteNameChanged>(_onRouteNameChanged);
    on<BICAdded>(_onBICAdded);
    on<BICDeleted>(_onBICDeleted);
    on<SearchTextFieldChanged>(_onSearchTextFieldChanged);
    on<BICsOrderChanged>(_onBICsOrderChanged);
    on<ShowHistoriesButtonPressed>(_onShowHistoriesButtonPressed);
    on<HistorySelected>(_onHistorySelected);
    on<DescriptionChanged>(_onDescriptionChanged);
    on<SaveHistorySelectedButtonPressed>(_onSaveHistorySelectedButtonPressed);
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
    BICState newBICState = BICState(bic: newBIC);
    emit(state.copyWith(
        bicsForRoute: [...state.bicsForRoute, newBICState],
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
    emit(
      state.copyWith(
        searchTextField: event.searchTextField,
        bicsForSearch: bicList,
      ),
    );
  }

  void _onBICsOrderChanged(
      BICsOrderChanged event, Emitter<RouteState> emit) async {
    int newIndex = event.newIndex;
    if (event.oldIndex < event.newIndex) newIndex--;
    List<BICState> bicsForRoute = state.bicsForRoute;
    final BICState bic = bicsForRoute.removeAt(event.oldIndex);
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
    if (state.isTheUserSelectingHistories) {
      saveHistorySelected();
    }
    add(SearchTextFieldChanged(searchTextField: searchTextField));
  }

  Future<void> changeBICsOrder(
      {required int oldIndex, required int newIndex}) async {
    add(BICsOrderChanged(oldIndex: oldIndex, newIndex: newIndex));
    await _changeBICCompleter.future;
    _changeBICCompleter = Completer<void>();
  }

  void _onShowHistoriesButtonPressed(
      ShowHistoriesButtonPressed event, Emitter<RouteState> emit) {
    emit(
      state.copyWith(
          bicsForRoute: state.bicsForRoute
              .map(
                (bicState) => bicState.bic.bicId == event.bic.bicId
                    ? bicState.copyWith(
                        selectedHistory: bicState.selectedHistory,
                        isTheUserSelectingHistoriesForThisBIC: true)
                    : bicState.copyWith(
                        selectedHistory: bicState.selectedHistory,
                        isTheUserSelectingHistoriesForThisBIC: false),
              )
              .toList(),
          isTheUserSelectingHistories: true),
    );
  }

  void showHistoriesOfABic(BIC bic) {
    add(ShowHistoriesButtonPressed(bic: bic));
  }

  Story? getSelectedHistoryById(String bicId) {
    return state.bicsForRoute
        .firstWhere((bicState) => bicState.bic.bicId == bicId)
        .selectedHistory;
  }

  void _onHistorySelected(HistorySelected event, Emitter<RouteState> emit) {
    final BICState bicState = state.bicsForRoute
        .firstWhere((bicState) => bicState.bic.bicId == event.bicId);
    final Story history = bicState.bic.histories
        .firstWhere((history) => history.id == event.historyId);
    BICState newBICState;
    if (bicState.selectedHistory?.id == event.historyId) {
      newBICState = bicState.copyWith(selectedHistory: null);
    } else {
      newBICState = bicState.copyWith(selectedHistory: history);
    }

    List<BICState> newBicForRoute = state.bicsForRoute.map((bicState) {
      if (bicState.bic.bicId == event.bicId) {
        return newBICState;
      } else {
        return bicState;
      }
    }).toList();

    emit(
      state.copyWith(bicsForRoute: newBicForRoute),
    );
  }

  void selectHistory(String historyId, String bicId) {
    add(HistorySelected(historyId: historyId, bicId: bicId));
  }

  void _onDescriptionChanged(
      DescriptionChanged event, Emitter<RouteState> emit) {
    emit(state.copyWith(description: event.description));
  }

  void changeDescription(String description) {
    add(DescriptionChanged(description: description));
  }

  double getRouteFormHeightForSelectedBICView(BuildContext context) {
    final int bicsForRouteLength = state.bicsForRoute.length;
    const int overFlowInTheSecondBIC = 25;
    if (bicsForRouteLength <= 1) {
      return getOriginalRouteFormHeight(context);
    } else if (bicsForRouteLength == 2) {
      return getFormHeight(context) +
          overFlowInTheSecondBIC -
          _heightOfTheWidgetFixedInTheTopOfTheScrollBar -
          _heightOfTheWidgetFixedInTheBottomOfTheScrollBar;
    } else {
      return getFormHeight(context) +
          _bicSelectedHeight * (bicsForRouteLength - 2) +
          overFlowInTheSecondBIC -
          12 -
          _heightOfTheWidgetFixedInTheTopOfTheScrollBar -
          _heightOfTheWidgetFixedInTheBottomOfTheScrollBar;
    }
  }

  double getRouteFormHeightForSearchedBICView(BuildContext context) {
    final int bicsForSearchLength = state.bicsForSearch.length;
    if (bicsForSearchLength <= 3) {
      return getOriginalRouteFormHeight(context);
    } else {
      return getFormHeight(context) +
          _bicSearchedHeight * (bicsForSearchLength - 3) -
          23 -
          _heightOfTheWidgetFixedInTheTopOfTheScrollBar -
          _heightOfTheWidgetFixedInTheBottomOfTheScrollBar;
    }
  }

  double getRouteFormHeightWithoutTopAndBottomFixedWidgets(
      BuildContext context) {
    if (state.searchTextField.isEmpty) {
      return getRouteFormHeightForSelectedBICView(context);
    } else {
      return getRouteFormHeightForSearchedBICView(context);
    }
  }

  double getBicSelectedHeight() {
    return _bicSelectedHeight;
  }

  double getOriginalRouteFormHeight(BuildContext context) {
    return getFormHeight(context) -
        _heightOfTheWidgetFixedInTheTopOfTheScrollBar -
        _heightOfTheWidgetFixedInTheBottomOfTheScrollBar;
  }

  double getFormHeight(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    if (screenHeight < _minHeightOfTheRouteForm) {
      return _minHeightOfTheRouteForm;
    } else {
      return screenHeight;
    }
  }

  double getWidthOfTheMap(BuildContext context) {
    double widthOfTheMap = MediaQuery.of(context).size.width - _sideMenuWidth;
    widthOfTheMap = widthOfTheMap -
        (state.isTheUserSelectingHistories ? _sideMenuWidth : 0);
    return (widthOfTheMap < 0) ? 0 : widthOfTheMap;
  }

  double getWidthOfTheSideMenu() {
    return _sideMenuWidth;
  }

  void _onSaveHistorySelectedButtonPressed(
      SaveHistorySelectedButtonPressed event, Emitter<RouteState> emit) {
    List<BICState> newBicsForRoute = state.bicsForRoute
        .map(
          (bicState) => bicState.copyWith(
            isTheUserSelectingHistoriesForThisBIC: false,
            selectedHistory: bicState.selectedHistory,
          ),
        )
        .toList();
    emit(
      state.copyWith(
          bicsForRoute: newBicsForRoute, isTheUserSelectingHistories: false),
    );
  }

  void saveHistorySelected() {
    add(SaveHistorySelectedButtonPressed());
  }

  void closeSelectedHistoryView() {
    saveHistorySelected();
  }
}
