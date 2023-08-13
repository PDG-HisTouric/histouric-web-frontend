import 'package:histouric_web/domain/entities/entities.dart';
import 'package:histouric_web/infrastructure/mapper/role_mapper.dart';

import '../models/models.dart';

class HistouricUserWithPasswordMapper {
  static Map<String, dynamic> toMap(
      HistouricUserWithPassword histouricUserWithPassword) {
    return {
      'id': histouricUserWithPassword.id,
      'nickname': histouricUserWithPassword.nickname,
      'email': histouricUserWithPassword.email,
      if (histouricUserWithPassword.roles != null)
        'roles': [histouricUserWithPassword.roles!.join(" ")],
      'password': histouricUserWithPassword.password,
    };
  }
}
