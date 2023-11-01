class RouteCreation {
  final String name;
  final String description;
  final String ownerId;
  final String themeName;
  final List<BicAndHistory> bicList;

  RouteCreation({
    required this.name,
    required this.description,
    required this.ownerId,
    this.themeName =
        "Miedo", //TODO: Change this when the functionality of create a theme is ready
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
