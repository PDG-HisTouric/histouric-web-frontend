import '../../domain/datasources/datasources.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../models/models.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryDatasource historyDatasource;

  HistoryRepositoryImpl({required this.historyDatasource});

  @override
  void configureToken(String token) {
    historyDatasource.configureToken(token);
  }

  @override
  Future<History> createHistory(HistoryCreation historyCreation) {
    return historyDatasource.createHistory(historyCreation);
  }
}
