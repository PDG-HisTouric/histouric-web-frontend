part of 'route_bloc.dart';

class RouteState {
  final String name;
  final List<BIC> bicsForRoute;
  final List<BIC> bicsForSearch;
  final String searchTextField;
  final Map<PolylineId, Polyline> polylines;

  late final TextEditingController searchController;

  RouteState({
    this.name = "",
    this.bicsForRoute = const [],
    this.bicsForSearch = const [],
    this.searchTextField = "",
    this.polylines = const {},
  });

  RouteState copyWith({
    String? name,
    List<BIC>? bicsForRoute,
    List<BIC>? bicsForSearch,
    String? searchTextField,
    Map<PolylineId, Polyline>? polylines,
  }) {
    return RouteState(
      name: name ?? this.name,
      bicsForRoute: bicsForRoute ?? this.bicsForRoute,
      bicsForSearch: bicsForSearch ?? this.bicsForSearch,
      searchTextField: searchTextField ?? this.searchTextField,
      polylines: polylines ?? this.polylines,
    )..searchController = searchController;
  }

  void initSearchController() {
    searchController = TextEditingController(text: searchTextField);
  }
}
