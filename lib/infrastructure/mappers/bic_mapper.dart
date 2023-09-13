import '../../domain/entities/entities.dart';
import '../models/models.dart';

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
      histories: [],
    );
  }

  static Map<String, dynamic> toMap(BIC bic) {
    return {
      'name': bic.name,
      'latitude': bic.latitude,
      'longitude': bic.longitude,
      'description': bic.description,
      'existss': bic.exists,
      'nicknames': bic.nicknames,
      'imagesUris': bic.imagesUris,
      'histories': bic.histories,
    };
  }
}
