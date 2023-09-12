import '../entities/entities.dart';

abstract class BICDatasource {
  Future<List<BIC>> getBICs();
  Future<BIC> createBIC(BIC bic);
  void configureToken(String token);
}
