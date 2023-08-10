class RoleResponse {
  final String id;
  final String name;
  final String description;

  RoleResponse({
    required this.id,
    required this.name,
    required this.description,
  });

  factory RoleResponse.fromJson(Map<String, dynamic> json) => RoleResponse(
        id: json["id"],
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
      };
}
