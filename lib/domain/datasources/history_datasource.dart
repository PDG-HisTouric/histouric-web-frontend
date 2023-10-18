import '../../infrastructure/models/models.dart';
import '../entities/entities.dart';

abstract class HistoryDatasource {
  Future<History> createHistory(HistoryCreation historyCreation);
  Future<History> getHistoryById(String historyId);
  void configureToken(String token);
}
