import '../entities/entities.dart';

abstract class BICRepository {
  Future<List<BIC>> getBICs();
  Future<BIC> createBIC(BIC bic);
  void configureToken(String token);
  Future<List<BIC>> getBICsByNameOrNickname(String nameOrNickname);
}
