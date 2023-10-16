import '../../infrastructure/models/models.dart';
import '../entities/entities.dart';

abstract class HistoryRepository {
  Future<History> createHistory(HistoryCreation historyCreation);
  void configureToken(String token);
}
