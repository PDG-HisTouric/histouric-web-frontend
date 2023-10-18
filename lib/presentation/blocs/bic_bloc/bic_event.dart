part of 'bic_bloc.dart';

abstract class BicEvent {}

class BicNameChanged extends BicEvent {
  final String name;

  BicNameChanged({required this.name});
}

class BicDescriptionChanged extends BicEvent {
  final String description;

  BicDescriptionChanged({required this.description});
}

class BicExistsChanged extends BicEvent {
  final bool exists;

  BicExistsChanged({required this.exists});
}

class BicDriveImageInfoAdded extends BicEvent {
  final HistouricImageInfo driveImageInfo;

  BicDriveImageInfoAdded({required this.driveImageInfo});
}

class BicSubmitted extends BicEvent {}

class BicTouchedEveryField extends BicEvent {}

class TitleForSearchQueryChanged extends BicEvent {
  final String titleForSearchQuery;

  TitleForSearchQueryChanged({required this.titleForSearchQuery});
}

class HistoriesAfterSearchChanged extends BicEvent {
  final List<History> historiesAfterSearch;

  HistoriesAfterSearchChanged({required this.historiesAfterSearch});
}

class HistorySelected extends BicEvent {
  final String historyId;

  HistorySelected({required this.historyId});
}
