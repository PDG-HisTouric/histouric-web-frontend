import '../../domain/datasources/datasources.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';

class UserRepositoryImpl extends UserRepository {
  final UserDatasource userDatasource;

  UserRepositoryImpl({required this.userDatasource});

  @override
  Future<void> deleteUserById(String id) {
    return userDatasource.deleteUserById(id);
  }

  @override
  Future<HistouricUser> getUserByNickname(String nickname) {
    return userDatasource.getUserByNickname(nickname);
  }

  @override
  Future<List<HistouricUser>> getUsers() {
    return userDatasource.getUsers();
  }

  @override
  Future<HistouricUser> updateUserById(
      String id, HistouricUserWithPassword histouricUserWithPassword) {
    return userDatasource.updateUserById(id, histouricUserWithPassword);
  }

  @override
  void configureToken(String token) {
    userDatasource.configureToken(token);
  }

  @override
  Future<List<HistouricUser>> getUsersByNickname(String nickname) {
    return userDatasource.getUsersByNickname(nickname);
  }
}
