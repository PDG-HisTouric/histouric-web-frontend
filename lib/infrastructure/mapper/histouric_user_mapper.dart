import 'package:histouric_web/domain/entities/entities.dart';
import 'package:histouric_web/infrastructure/mapper/role_mapper.dart';

import '../models/models.dart';

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
    );
  }
}
