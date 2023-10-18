import '../../infrastructure/models/models.dart';
import '../entities/entities.dart';

abstract class HistoryDatasource {
  Future<History> createHistory(HistoryCreation historyCreation);
  Future<List<History>> getHistoriesByTitle(String title);
  void configureToken(String token);
}
