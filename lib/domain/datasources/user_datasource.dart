import 'package:histouric_web/domain/entities/entities.dart';
import 'package:histouric_web/domain/entities/histouric_user.dart';

abstract class UserDatasource {
  Future<List<HistouricUser>> getUsers();
  Future<HistouricUser> getUserByNickname(String nickname);
  Future<List<HistouricUser>> getUsersByNickname(String nickname);
  Future<HistouricUser> updateUserById(
    String id,
    HistouricUserWithPassword histouricUserWithPassword,
  );
  Future<void> deleteUserById(String id);
  void configureToken(String token);
}
