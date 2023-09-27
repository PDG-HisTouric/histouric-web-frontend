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
