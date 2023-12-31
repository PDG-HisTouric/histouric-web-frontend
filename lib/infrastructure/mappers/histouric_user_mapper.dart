import '../../domain/domain.dart';
import '../models/models.dart';
import 'role_mapper.dart';

class HistouricUserMapper {
  static Map<String, dynamic> toMap(HistouricUser histouricUser) {
    return {
      'id': histouricUser.id,
      'nickname': histouricUser.nickname,
      'email': histouricUser.email,
      'roles': histouricUser.roles,
    };
  }

  static HistouricUser fromHistouricUserResponse(
    HistouricUserResponse histouricUserResponse,
  ) {
    return HistouricUser(
      id: histouricUserResponse.id,
      nickname: histouricUserResponse.nickname,
      email: histouricUserResponse.email,
      roles: RoleMapper.fromRoleResponses(histouricUserResponse.roles),
      token: histouricUserResponse.token,
    );
  }
}
