part of 'route_bloc.dart';

class RouteState {
  final String name;
  final List<BIC> bicsForRoute;
  final List<BIC> bicsForSearch;
  final String searchTextField;
  final Map<PolylineId, Polyline> polylines;
  final int counter;

  late final TextEditingController searchController;

  RouteState({
    this.name = "",
    this.bicsForRoute = const [],
    this.bicsForSearch = const [],
    this.searchTextField = "",
    this.polylines = const {},
    this.counter = 0,
  });

  RouteState copyWith({
    String? name,
    List<BIC>? bicsForRoute,
    List<BIC>? bicsForSearch,
    String? searchTextField,
    Map<PolylineId, Polyline>? polylines,
    int? counter,
  }) {
    return RouteState(
      name: name ?? this.name,
      bicsForRoute: bicsForRoute ?? this.bicsForRoute,
      bicsForSearch: bicsForSearch ?? this.bicsForSearch,
      searchTextField: searchTextField ?? this.searchTextField,
      polylines: polylines ?? this.polylines,
      counter: counter ?? this.counter,
    )..searchController = searchController;
  }

  void initSearchController() {
    searchController = TextEditingController(text: searchTextField);
  }
}
