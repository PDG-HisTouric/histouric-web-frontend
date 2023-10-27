import 'package:histouric_web/infrastructure/infrastructure.dart';

import '../../domain/domain.dart';

class BICRepositoryImpl implements BICRepository {
  final BICDatasource bicDatasource;

  BICRepositoryImpl({required this.bicDatasource});

  @override
  Future<BIC> createBIC(BICCreation bic) {
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
