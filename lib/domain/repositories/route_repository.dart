import '../../infrastructure/models/models.dart';
import '../entities/entities.dart';

abstract class RouteRepository {
  Future<HistouricRoute> createRoute(RouteCreation route);
  void configureToken(String token);
}
