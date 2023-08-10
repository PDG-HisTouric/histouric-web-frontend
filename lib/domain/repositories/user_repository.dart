import 'package:histouric_web/domain/entities/histouric_user.dart';

abstract class UserRepository {
  Future<List<HistouricUser>> getUsers();
  Future<HistouricUser> getUserByNickname(String nickname);
  Future<HistouricUser> updateUserById(String id, HistouricUser histouricUser);
  Future<void> deleteUserById(String id);
  void configureToken(String token);
}
