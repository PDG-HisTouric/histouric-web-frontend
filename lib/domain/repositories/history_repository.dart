import '../../infrastructure/models/models.dart';
import '../entities/entities.dart';

abstract class HistoryRepository {
  Future<Story> createHistory(HistoryCreation historyCreation);
  Future<List<Story>> getHistoriesByTitle(String title);
  void configureToken(String token);
}
