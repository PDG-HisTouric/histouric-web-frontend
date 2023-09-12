class BICResponse {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String description;
  final bool exists;
  final List<String> nicknames;
  final List<String> imagesUris;

  BICResponse({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.exists,
    required this.nicknames,
    required this.imagesUris,
  });

  factory BICResponse.fromJson(Map<String, dynamic> json) => BICResponse(
        id: json["id"],
        name: json["name"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        description: json["description"],
        exists: json["existss"],
        nicknames: (json["nicknames"] as List)
            .map((x) => x["nickname"].toString())
            .toList(),
        imagesUris: (json["imagesUris"] as List)
            .map((x) => x["imageUri"].toString())
            .toList(),
      );
}
