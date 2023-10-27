import 'history_response.dart';

class BICResponse {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String description;
  final bool exists;
  final List<String> nicknames;
  final List<String> imagesUris;
  final List<HistoryResponse> histories;

  BICResponse({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.exists,
    required this.nicknames,
    required this.imagesUris,
    required this.histories,
  });

  factory BICResponse.fromJson(Map<String, dynamic> json) {
    List<String> nicknames = json["nicknames"] != null
        ? (json["nicknames"] as List)
            .map((x) => x["nickname"].toString())
            .toList()
        : [];

    List<String> imagesUris = json["imagesUris"] != null
        ? (json["imagesUris"] as List)
            .map((x) => x["imageUri"].toString())
            .toList()
        : [];

    List<HistoryResponse> histories = json["histories"] != null
        ? (json["histories"] as List)
            .map((x) => HistoryResponse.fromJson(x))
            .toList()
        : [];

    return BICResponse(
      id: json["id"],
      name: json["name"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      description: json["description"],
      exists: json["existss"],
      nicknames: nicknames,
      imagesUris: imagesUris,
      histories: histories,
    );
  }
}
