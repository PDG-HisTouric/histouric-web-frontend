part of 'route_bloc.dart';

class RouteState {
  final String name;
  final List<BIC> bicsForRoute;
  final List<BIC> bicsForSearch;
  final String searchTextField;
  late final TextEditingController searchController;

  RouteState({
    this.name = "",
    this.bicsForRoute = const [],
    this.bicsForSearch = const [],
    this.searchTextField = "",
  });

  RouteState copyWith({
    String? name,
    List<BIC>? bicsForRoute,
    List<BIC>? bicsForSearch,
    String? searchTextField,
  }) {
    return RouteState(
      name: name ?? this.name,
      bicsForRoute: bicsForRoute ?? this.bicsForRoute,
      bicsForSearch: bicsForSearch ?? this.bicsForSearch,
      searchTextField: searchTextField ?? this.searchTextField,
    )..searchController = searchController;
  }

  void initSearchController() {
    searchController = TextEditingController(text: searchTextField);
  }
}
