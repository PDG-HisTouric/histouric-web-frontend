part of 'route_bloc.dart';

abstract class RouteEvent {}

class RouteNameChanged extends RouteEvent {
  final String name;

  RouteNameChanged({required this.name});
}

class BICAdded extends RouteEvent {
  final BIC bic;

  BICAdded({required this.bic});
}

class BICDeleted extends RouteEvent {
  final int index;

  BICDeleted({required this.index});
}

class SearchTextFieldChanged extends RouteEvent {
  final String searchTextField;

  SearchTextFieldChanged({required this.searchTextField});
}

class BICsOrderChanged extends RouteEvent {
  final int oldIndex;
  final int newIndex;

  BICsOrderChanged({required this.oldIndex, required this.newIndex});
}

class ShowHistoriesButtonPressed extends RouteEvent {
  final BIC bic;

  ShowHistoriesButtonPressed({required this.bic});
}

class HistorySelected extends RouteEvent {
  final String historyId;
  final String bicId;

  HistorySelected({required this.historyId, required this.bicId});
}

class DescriptionChanged extends RouteEvent {
  final String description;

  DescriptionChanged({required this.description});
}

class SaveHistorySelectedButtonPressed extends RouteEvent {
  SaveHistorySelectedButtonPressed();
}

class ShowBICWithRouteStateButtonPressed extends RouteEvent {
  final BIC bic;

  ShowBICWithRouteStateButtonPressed({required this.bic});
}

class ShowBICWithSearchStateButtonPressed extends RouteEvent {
  final BIC bic;

  ShowBICWithSearchStateButtonPressed({required this.bic});
}

class CloseBICWithRouteStateButtonPressed extends RouteEvent {
  CloseBICWithRouteStateButtonPressed();
}

class CloseBICWithSearchStateButtonPressed extends RouteEvent {
  CloseBICWithSearchStateButtonPressed();
}

class SaveRouteButtonPressed extends RouteEvent {
  SaveRouteButtonPressed();
}
