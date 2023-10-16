import '../../infrastructure/models/models.dart';
import '../entities/entities.dart';

abstract class HistoryDatasource {
  Future<History> createHistory(HistoryCreation historyCreation);

  void configureToken(String token);
}
