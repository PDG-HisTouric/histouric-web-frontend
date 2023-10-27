import '../../infrastructure/models/models.dart';
import '../entities/entities.dart';

abstract class BICDatasource {
  Future<List<BIC>> getBICs();
  Future<BIC> createBIC(BICCreation bic);
  void configureToken(String token);
  Future<List<BIC>> getBICsByNameOrNickname(String nameOrNickname);
}
