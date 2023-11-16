part of 'route_bloc.dart';

class RouteState {
  final String name;
  final String description;
  final List<BICForRouteState> bicsForRoute;
  final List<BICForSearchState> bicsForSearch;
  final String searchTextField;
  final Map<PolylineId, Polyline> polylines;
  final int counter;
  final bool isTheUserSelectingHistories;
  final bool isTheUserViewingABICOfTheRoute;
  final bool isTheUserViewingABICOfTheSearch;

  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
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
    this.isTheUserViewingABICOfTheRoute = false,
    this.isTheUserViewingABICOfTheSearch = false,
  });

  RouteState copyWith({
    String? name,
    String? description,
    List<BICForRouteState>? bicsForRoute,
    List<BICForSearchState>? bicsForSearch,
    String? searchTextField,
    Map<PolylineId, Polyline>? polylines,
    int? counter,
    bool? isTheUserSelectingHistories,
    bool? isTheUserViewingABICOfTheRoute,
    bool? isTheUserViewingABICOfTheSearch,
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
      isTheUserViewingABICOfTheRoute:
          isTheUserViewingABICOfTheRoute ?? this.isTheUserViewingABICOfTheRoute,
      isTheUserViewingABICOfTheSearch: isTheUserViewingABICOfTheSearch ??
          this.isTheUserViewingABICOfTheSearch,
    )
      ..searchController = searchController
      ..nameController = nameController
      ..descriptionController = descriptionController;
  }

  void initSearchController() {
    searchController = TextEditingController();
  }

  void initDescriptionController() {
    descriptionController = TextEditingController();
  }

  void initNameController() {
    nameController = TextEditingController(text: searchTextField);
  }

  RouteState clearState() {
    return RouteState(
        name: "",
        description: "",
        bicsForRoute: [],
        bicsForSearch: [],
        searchTextField: "",
        polylines: {},
        counter: 0,
        isTheUserSelectingHistories: false,
        isTheUserViewingABICOfTheRoute: false,
        isTheUserViewingABICOfTheSearch: false)
      ..searchController = TextEditingController()
      ..nameController = TextEditingController()
      ..descriptionController = TextEditingController();
  }
}

class BICForRouteState {
  final BIC bic;
  final bool isTheUserSelectingHistoriesForThisBIC;
  final bool isTheUserViewingThisBIC;
  final Story? selectedHistory;

  BICForRouteState({
    required this.bic,
    this.isTheUserSelectingHistoriesForThisBIC = false,
    this.isTheUserViewingThisBIC = false,
    this.selectedHistory,
  });

  BICForRouteState copyWith({
    BIC? bic,
    bool? isTheUserSelectingHistoriesForThisBIC,
    bool? isTheUserViewingThisBIC,
    Story? selectedHistory,
  }) {
    return BICForRouteState(
      bic: bic ?? this.bic,
      isTheUserViewingThisBIC:
          isTheUserViewingThisBIC ?? this.isTheUserViewingThisBIC,
      isTheUserSelectingHistoriesForThisBIC:
          isTheUserSelectingHistoriesForThisBIC ??
              this.isTheUserSelectingHistoriesForThisBIC,
      selectedHistory: selectedHistory,
    );
  }
}

class BICForSearchState {
  final BIC bic;
  final bool isTheUserViewingThisBIC;

  BICForSearchState({
    required this.bic,
    this.isTheUserViewingThisBIC = false,
  });

  BICForSearchState copyWith({
    BIC? bic,
    bool? isTheUserViewingThisBIC,
  }) {
    return BICForSearchState(
      bic: bic ?? this.bic,
      isTheUserViewingThisBIC:
          isTheUserViewingThisBIC ?? this.isTheUserViewingThisBIC,
    );
  }
}
