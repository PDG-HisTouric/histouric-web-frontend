import '../../domain/domain.dart';

class HistouricUserWithPasswordMapper {
  static Map<String, dynamic> toMap(
    HistouricUserWithPassword histouricUserWithPassword,
  ) {
    return {
      if (histouricUserWithPassword.id != null)
        'id': histouricUserWithPassword.id,
      if (histouricUserWithPassword.nickname != null)
        'nickname': histouricUserWithPassword.nickname,
      if (histouricUserWithPassword.email != null)
        'email': histouricUserWithPassword.email,
      if (histouricUserWithPassword.roles != null)
        'roles': histouricUserWithPassword.roles!,
      if (histouricUserWithPassword.password != null)
        'password': histouricUserWithPassword.password,
    };
  }
}
