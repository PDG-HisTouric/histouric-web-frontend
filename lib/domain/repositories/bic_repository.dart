import 'package:histouric_web/infrastructure/infrastructure.dart';

import '../entities/entities.dart';

abstract class BICRepository {
  Future<List<BIC>> getBICs();
  Future<BIC> createBIC(BICCreation bic);
  void configureToken(String token);
  Future<List<BIC>> getBICsByNameOrNickname(String nameOrNickname);
}
