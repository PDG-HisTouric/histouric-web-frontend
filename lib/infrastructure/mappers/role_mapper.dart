import '../../domain/domain.dart';
import '../models/models.dart';

class RoleMapper {
  static Role fromRoleResponse(RoleResponse roleResponse) {
    return Role(
      id: roleResponse.id,
      name: roleResponse.name,
      description: roleResponse.description,
    );
  }

  static List<Role> fromRoleResponses(List<RoleResponse> roleResponses) {
    return roleResponses
        .map((roleResponse) => fromRoleResponse(roleResponse))
        .toList();
  }
}
