import '../../domain/datasources/datasources.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';

class BICRepositoryImpl implements BICRepository {
  final BICDatasource bicDatasource;

  BICRepositoryImpl({required this.bicDatasource});

  @override
  Future<BIC> createBIC(BIC bic) {
    return bicDatasource.createBIC(bic);
  }

  @override
  Future<List<BIC>> getBICs() {
    return bicDatasource.getBICs();
  }

  @override
  void configureToken(String token) {
    bicDatasource.configureToken(token);
  }

  @override
  Future<List<BIC>> getBICsByNameOrNickname(String nameOrNickname) {
    return bicDatasource.getBICsByNameOrNickname(nameOrNickname);
  }
}
