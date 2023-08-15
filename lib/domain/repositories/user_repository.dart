import '../entities/entities.dart';

abstract class UserRepository {
  Future<List<HistouricUser>> getUsers();

  Future<HistouricUser> getUserByNickname(String nickname);

  Future<List<HistouricUser>> getUsersByNickname(String nickname);

  Future<HistouricUser> registerUser(
    HistouricUserWithPassword histouricUserWithPassword,
  );

  Future<HistouricUser> updateUserById(
    String id,
    HistouricUserWithPassword histouricUserWithPassword,
  );

  Future<void> deleteUserById(String id);

  void configureToken(String token);
}
