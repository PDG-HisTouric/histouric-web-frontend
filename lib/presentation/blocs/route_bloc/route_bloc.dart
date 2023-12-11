import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:histouric_web/presentation/blocs/alert_bloc/alert_bloc.dart';

import '../../../domain/domain.dart';
import '../../../infrastructure/models/models.dart';
import '../../widgets/widgets.dart';

part 'route_event.dart';
part 'route_state.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  final AlertBloc alertBloc;
  final BICRepository bicRepository;
  final RouteRepository routeRepository;
  final String token;
  final String ownerId;

  late final double _bicSelectedHeight;
  late final double _bicSearchedHeight;
  late final double _heightOfTheWidgetFixedInTheTopOfTheScrollBar;
  late final double _heightOfTheWidgetFixedInTheBottomOfTheScrollBar;
  late final double _minHeightOfTheRouteForm;
  late final double _sideMenuWidth;

  Completer<void> _changeBICCompleter = Completer<void>();
  Completer<BIC> _newBICCompleter = Completer<BIC>();
  Completer<void> _deleteBICCompleter = Completer<void>();
  Completer<HistouricRoute> _saveRouteCompleter = Completer<HistouricRoute>();

  RouteBloc({
    required this.alertBloc,
    required this.routeRepository,
    required this.bicRepository,
    required this.ownerId,
    required this.token,
  }) : super(RouteState()) {
    bicRepository.configureToken(token);
    state.initSearchController();
    state.initNameController();
    state.initDescriptionController();
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
    on<ShowBICWithRouteStateButtonPressed>(
        _onShowBICWithRouteStateButtonPressed);
    on<ShowBICWithSearchStateButtonPressed>(
        _onShowBICWithSearchStateButtonPressed);
    on<CloseBICWithRouteStateButtonPressed>(
        _onCloseBICWithRouteStateButtonPressed);
    on<CloseBICWithSearchStateButtonPressed>(
        _onCloseBICWithSearchStateButtonPressed);
    on<SaveRouteButtonPressed>(_onSaveRouteButtonPressed);
    routeRepository.configureToken(token);
  }

  void _onRouteNameChanged(RouteNameChanged event, Emitter<RouteState> emit) {
    emit(state.copyWith(name: event.name));
  }

  void changeName(String name) {
    add(RouteNameChanged(name: name));
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
    BICForRouteState newBICState = BICForRouteState(bic: newBIC);
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
    List<BICForSearchState> bicForSearchList = bicList
        .map((bic) => BICForSearchState(
              bic: bic,
              isTheUserViewingThisBIC: false,
            ))
        .toList();
    emit(
      state.copyWith(
        searchTextField: event.searchTextField,
        bicsForSearch: bicForSearchList,
        isTheUserViewingABICOfTheSearch: false,
      ),
    );
  }

  void _onBICsOrderChanged(
      BICsOrderChanged event, Emitter<RouteState> emit) async {
    int newIndex = event.newIndex;
    if (event.oldIndex < event.newIndex) newIndex--;
    List<BICForRouteState> bicsForRoute = state.bicsForRoute;
    final BICForRouteState bic = bicsForRoute.removeAt(event.oldIndex);
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
    if (state.isTheUserSelectingHistories) {
      closeSelectedHistoryView();
    }
    if (state.isTheUserViewingABICOfTheRoute) {
      closeBICWithRouteState();
    }
    add(BICDeleted(index: index));
    await _deleteBICCompleter.future;
    _deleteBICCompleter = Completer<void>();
  }

  void changeSearchTextField(String searchTextField) {
    if (state.isTheUserSelectingHistories) {
      saveHistorySelected();
    }
    if (state.isTheUserViewingABICOfTheRoute) {
      closeBICWithRouteState();
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
    if (state.isTheUserViewingABICOfTheRoute) {
      closeBICWithRouteState();
    }
    add(ShowHistoriesButtonPressed(bic: bic));
  }

  Story? getSelectedHistoryById(String bicId) {
    for (BICForRouteState bicState in state.bicsForRoute) {
      if (bicState.bic.bicId == bicId) {
        return bicState.selectedHistory;
      }
    }
    return null;
  }

  void _onHistorySelected(HistorySelected event, Emitter<RouteState> emit) {
    final BICForRouteState bicState = state.bicsForRoute
        .firstWhere((bicState) => bicState.bic.bicId == event.bicId);
    final Story history = bicState.bic.histories
        .firstWhere((history) => history.id == event.historyId);
    BICForRouteState newBICState;
    if (bicState.selectedHistory?.id == event.historyId) {
      newBICState = bicState.copyWith(selectedHistory: null);
    } else {
      newBICState = bicState.copyWith(selectedHistory: history);
    }

    List<BICForRouteState> newBicForRoute = state.bicsForRoute.map((bicState) {
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

  double _getRouteFormHeightForSelectedBICView(BuildContext context) {
    final int bicsForRouteLength = state.bicsForRoute.length;
    const int overFlowInTheSecondBIC = 25;
    if (bicsForRouteLength <= 1) {
      return _getOriginalRouteFormHeight(context);
    } else if (bicsForRouteLength == 2) {
      return _getFormHeight(context) +
          overFlowInTheSecondBIC -
          _heightOfTheWidgetFixedInTheTopOfTheScrollBar -
          _heightOfTheWidgetFixedInTheBottomOfTheScrollBar;
    } else {
      return _getFormHeight(context) +
          _bicSelectedHeight * (bicsForRouteLength - 2) +
          overFlowInTheSecondBIC -
          12 -
          _heightOfTheWidgetFixedInTheTopOfTheScrollBar -
          _heightOfTheWidgetFixedInTheBottomOfTheScrollBar;
    }
  }

  double _getRouteFormHeightForSearchedBICView(BuildContext context) {
    final int bicsForSearchLength = state.bicsForSearch.length;
    if (bicsForSearchLength <= 3) {
      return _getOriginalRouteFormHeight(context);
    } else {
      return _getFormHeight(context) +
          _bicSearchedHeight * (bicsForSearchLength - 3) -
          23 -
          _heightOfTheWidgetFixedInTheTopOfTheScrollBar -
          _heightOfTheWidgetFixedInTheBottomOfTheScrollBar;
    }
  }

  double getRouteFormHeightWithoutTopAndBottomFixedWidgets(
      BuildContext context) {
    if (state.searchTextField.isEmpty) {
      return _getRouteFormHeightForSelectedBICView(context);
    } else {
      return _getRouteFormHeightForSearchedBICView(context);
    }
  }

  double _getOriginalRouteFormHeight(BuildContext context) {
    return _getFormHeight(context) -
        _heightOfTheWidgetFixedInTheTopOfTheScrollBar -
        _heightOfTheWidgetFixedInTheBottomOfTheScrollBar;
  }

  double _getFormHeight(BuildContext context) {
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
        ((state.isTheUserSelectingHistories ||
                state.isTheUserViewingABICOfTheSearch ||
                state.isTheUserViewingABICOfTheRoute)
            ? _sideMenuWidth
            : 0);
    return (widthOfTheMap < 0) ? 0 : widthOfTheMap;
  }

  double getWidthOfTheSideMenu() {
    return _sideMenuWidth;
  }

  void _onSaveHistorySelectedButtonPressed(
      SaveHistorySelectedButtonPressed event, Emitter<RouteState> emit) {
    List<BICForRouteState> newBicsForRoute = state.bicsForRoute
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

  void _onShowBICWithRouteStateButtonPressed(
      ShowBICWithRouteStateButtonPressed event, Emitter<RouteState> emit) {
    emit(
      state.copyWith(
          bicsForRoute: state.bicsForRoute
              .map(
                (bicState) => bicState.bic.bicId == event.bic.bicId
                    ? bicState.copyWith(
                        selectedHistory: bicState.selectedHistory,
                        isTheUserViewingThisBIC: true)
                    : bicState.copyWith(
                        selectedHistory: bicState.selectedHistory,
                        isTheUserViewingThisBIC: false),
              )
              .toList(),
          isTheUserViewingABICOfTheRoute: true),
    );
  }

  void showBICWithRouteState(BIC bic) {
    if (state.isTheUserSelectingHistories) {
      saveHistorySelected();
    }
    add(ShowBICWithRouteStateButtonPressed(bic: bic));
  }

  void _onShowBICWithSearchStateButtonPressed(
      ShowBICWithSearchStateButtonPressed event, Emitter<RouteState> emit) {
    emit(
      state.copyWith(
          bicsForSearch: state.bicsForSearch
              .map(
                (bicState) => bicState.bic.bicId == event.bic.bicId
                    ? bicState.copyWith(isTheUserViewingThisBIC: true)
                    : bicState.copyWith(isTheUserViewingThisBIC: false),
              )
              .toList(),
          isTheUserViewingABICOfTheSearch: true),
    );
  }

  void showBICWithSearchState(BIC bic) {
    add(ShowBICWithSearchStateButtonPressed(bic: bic));
  }

  void _onCloseBICWithRouteStateButtonPressed(
      CloseBICWithRouteStateButtonPressed event, Emitter<RouteState> emit) {
    emit(
      state.copyWith(
          bicsForRoute: state.bicsForRoute
              .map(
                (bicState) => bicState.copyWith(
                    selectedHistory: bicState.selectedHistory,
                    isTheUserViewingThisBIC: false),
              )
              .toList(),
          isTheUserViewingABICOfTheRoute: false),
    );
  }

  void closeBICWithRouteState() {
    add(CloseBICWithRouteStateButtonPressed());
  }

  void _onCloseBICWithSearchStateButtonPressed(
      CloseBICWithSearchStateButtonPressed event, Emitter<RouteState> emit) {
    emit(
      state.copyWith(
          bicsForSearch: state.bicsForSearch
              .map(
                (bicState) => bicState.copyWith(isTheUserViewingThisBIC: false),
              )
              .toList(),
          isTheUserViewingABICOfTheSearch: false),
    );
  }

  void closeBICWithSearchState() {
    add(CloseBICWithSearchStateButtonPressed());
  }

  Future<void> _onSaveRouteButtonPressed(
      SaveRouteButtonPressed event, Emitter<RouteState> emit) async {
    changeSearchTextField("");
    _openLoadingAlert();

    if (state.bicsForRoute.length < 2) {
      _openErrorAlert("La ruta debe tener al menos 2 BICs");
      return;
    }

    List<BicAndHistory> bics = [];
    for (BICForRouteState bicState in state.bicsForRoute) {
      if (bicState.selectedHistory != null) {
        bics.add(BicAndHistory(
          bicId:
              bicState.bic.bicId!.substring(0, bicState.bic.bicId!.length - 1),
          historyId: bicState.selectedHistory!.id,
        ));
      }
    }

    if (_allTheBicsHaveAHistory() != null) {
      _openErrorAlert(
          "El BIC ${_allTheBicsHaveAHistory()!.name} no tiene una historia seleccionada");
      return;
    }

    RouteCreation routeCreation = RouteCreation(
      name: state.name,
      description: state.description,
      ownerId: ownerId,
      bicList: bics,
    );
    HistouricRoute histouricRoute;
    try {
      histouricRoute = await routeRepository.createRoute(routeCreation);
    } catch (e) {
      _openErrorAlert("Ocurrió un error al crear la ruta");
      return;
    }
    emit(state.clearState());
    _saveRouteCompleter.complete(histouricRoute);
  }

  Future<HistouricRoute> saveRoute() async {
    add(SaveRouteButtonPressed());
    HistouricRoute histouricRoute = await _saveRouteCompleter.future;
    _openRouteSuccessfullyCreatedAlert();
    _saveRouteCompleter = Completer<HistouricRoute>();
    return histouricRoute;
  }

  void _openRouteSuccessfullyCreatedAlert() {
    alertBloc.changeChild(CardWithMessageAndIcon(
      onPressed: () => alertBloc.closeAlert(),
      message: "La ruta fue creada exitosamente",
      icon: Icons.check,
    ));
    alertBloc.openAlert();
  }

  void _openLoadingAlert() {
    alertBloc.changeChild(const LoadingCard(
      loadingText: 'La ruta se está creando...',
    ));
    alertBloc.openAlert();
  }

  void _openErrorAlert(String message) {
    alertBloc.changeChild(CardWithMessageAndIcon(
      onPressed: () => alertBloc.closeAlert(),
      message: message,
      icon: Icons.error,
    ));
    alertBloc.openAlert();
  }

  BIC? _allTheBicsHaveAHistory() {
    for (BICForRouteState bicState in state.bicsForRoute) {
      if (bicState.selectedHistory == null) {
        return bicState.bic;
      }
    }
    return null;
  }
}
