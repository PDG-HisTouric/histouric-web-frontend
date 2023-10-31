import 'package:histouric_web/infrastructure/infrastructure.dart';

import '../../domain/entities/entities.dart';
import '../models/models.dart';

class RouteMapper {
  static Map<String, dynamic> fromRouteCreationToMap(
      RouteCreation routeCreation) {
    List<Map<String, dynamic>> bicList = [];
    for (int i = 0; i < routeCreation.bicList.length; i++) {
      var bic = routeCreation.bicList[i];
      bicList.add(fromBicAndHistoryToMap(bic));
    }

    return {
      "name": routeCreation.name,
      "description": routeCreation.description,
      "ownerId": routeCreation.ownerId,
      "themeName": routeCreation.themeName,
      "bicList": bicList,
    };
  }

  static Map<String, dynamic> fromBicAndHistoryToMap(
      BicAndHistory bicAndHistory) {
    return {
      "bicId": bicAndHistory.bicId,
      "historyId": bicAndHistory.historyId,
    };
  }

  static HistouricRoute fromRouteResponseToRoute(RouteResponse routeResponse) {
    return HistouricRoute(
      id: routeResponse.id,
      name: routeResponse.name,
      description: routeResponse.description,
      owner: HistouricUserMapper.fromHistouricUserResponse(routeResponse.owner),
      themeName: routeResponse.themeName,
      bics: routeResponse.bics
          .map((bic) => BICMapper.fromBICResponse(bic))
          .toList(),
    );
  }
}
