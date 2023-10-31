import 'package:histouric_web/infrastructure/infrastructure.dart';

import '../../domain/entities/entities.dart';

class RouteResponse {
  final String id;
  final String name;
  final String description;
  final HistouricUserResponse owner;
  final String
      themeName; //TODO: Change when the functionality of creating a theme is implemented
  final List<BICResponse> bics;

  RouteResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.owner,
    required this.themeName,
    required this.bics,
  });

  factory RouteResponse.fromJson(Map<String, dynamic> json) => RouteResponse(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        owner: HistouricUserResponse.fromJson(json["owner"]),
        themeName: json["themeName"],
        bics: (json["bics"] as List)
            .map((bic) => BICResponse.fromJson(bic))
            .toList(),
      );
}
