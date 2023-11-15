class RouteCreation {
  final String name;
  final String description;
  final String ownerId;
  final List<BicAndHistory> bicList;

  RouteCreation({
    required this.name,
    required this.description,
    required this.ownerId,
    required this.bicList,
  });
}

class BicAndHistory {
  final String bicId;
  final String historyId;

  BicAndHistory({
    required this.bicId,
    required this.historyId,
  });
}
