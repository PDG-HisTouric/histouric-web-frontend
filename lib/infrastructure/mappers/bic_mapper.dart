import 'package:histouric_web/infrastructure/infrastructure.dart';

import '../../domain/domain.dart';

class BICMapper {
  static BIC fromBICResponse(BICResponse bicResponse) {
    return BIC(
      bicId: bicResponse.id,
      name: bicResponse.name,
      latitude: bicResponse.latitude,
      longitude: bicResponse.longitude,
      description: bicResponse.description,
      exists: bicResponse.exists,
      nicknames: bicResponse.nicknames,
      imagesUris: bicResponse.imagesUris,
      histories: bicResponse.histories
          .map((historyResponse) =>
              HistoryMapper.fromHistoryResponseToHistory(historyResponse))
          .toList(),
    );
  }

  static Map<String, dynamic> toMap(BICCreation bic) {
    return {
      'name': bic.name,
      'latitude': bic.latitude,
      'longitude': bic.longitude,
      'description': bic.description,
      'existss': bic.exists,
      'nicknames': bic.nicknames,
      'imagesUris': bic.imagesUris,
      'historiesIds': bic.historiesIds,
    };
  }
}
