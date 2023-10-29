part of 'route_bloc.dart';

class RouteState {
  final String name;
  final String description;
  final List<BICState> bicsForRoute;
  final List<BIC> bicsForSearch;
  final String searchTextField;
  final Map<PolylineId, Polyline> polylines;
  final int counter;
  final bool isTheUserSelectingHistories;
  final bool isTheScrollBarUp;
  final bool isTheScrollBarDown;
  final double widthOfTheMap;

  late final TextEditingController searchController;

  RouteState({
    this.name = "",
    this.description = "",
    this.bicsForRoute = const [],
    this.bicsForSearch = const [],
    this.searchTextField = "",
    this.polylines = const {},
    this.counter = 0,
    this.isTheUserSelectingHistories = false,
    this.isTheScrollBarUp = true,
    this.isTheScrollBarDown = true,
    required this.widthOfTheMap,
  });

  RouteState copyWith({
    String? name,
    String? description,
    List<BICState>? bicsForRoute,
    List<BIC>? bicsForSearch,
    String? searchTextField,
    Map<PolylineId, Polyline>? polylines,
    int? counter,
    bool? isTheUserSelectingHistories,
    bool? isTheScrollBarUp,
    bool? isTheScrollBarDown,
    double? widthOfTheMap,
  }) {
    return RouteState(
      name: name ?? this.name,
      description: description ?? this.description,
      bicsForRoute: bicsForRoute ?? this.bicsForRoute,
      bicsForSearch: bicsForSearch ?? this.bicsForSearch,
      searchTextField: searchTextField ?? this.searchTextField,
      polylines: polylines ?? this.polylines,
      counter: counter ?? this.counter,
      isTheUserSelectingHistories:
          isTheUserSelectingHistories ?? this.isTheUserSelectingHistories,
      isTheScrollBarUp: isTheScrollBarUp ?? this.isTheScrollBarUp,
      isTheScrollBarDown: isTheScrollBarDown ?? this.isTheScrollBarDown,
      widthOfTheMap: widthOfTheMap ?? this.widthOfTheMap,
    )..searchController = searchController;
  }

  void initSearchController() {
    searchController = TextEditingController(text: searchTextField);
  }
}

class BICState {
  final BIC bic;
  final bool isTheUserSelectingHistoriesForThisBIC;
  final Story? selectedHistory;

  BICState({
    required this.bic,
    this.isTheUserSelectingHistoriesForThisBIC = false,
    this.selectedHistory,
  });

  BICState copyWith({
    BIC? bic,
    bool? isTheUserSelectingHistoriesForThisBIC,
    Story? selectedHistory,
  }) {
    return BICState(
      bic: bic ?? this.bic,
      isTheUserSelectingHistoriesForThisBIC:
          isTheUserSelectingHistoriesForThisBIC ??
              this.isTheUserSelectingHistoriesForThisBIC,
      selectedHistory: selectedHistory ?? this.selectedHistory,
    );
  }
}
