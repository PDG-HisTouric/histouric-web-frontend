class BICCreation {
  final String name;
  final double latitude;
  final double longitude;
  final String description;
  final bool exists;
  final List<String> nicknames;
  final List<String> imagesUris;
  final List<String> historiesIds;

  BICCreation({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.exists,
    required this.nicknames,
    required this.imagesUris,
    required this.historiesIds,
  });
}
