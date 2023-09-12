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
}
