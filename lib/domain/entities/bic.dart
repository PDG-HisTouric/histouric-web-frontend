import 'bic_history.dart';

class BIC {
  final String bicId;
  final String name;
  final double latitude;
  final double longitude;
  final String description;
  final bool exists;
  final List<String> nicknames;
  final List<String> imagesUris;
  final List<BICHistory> histories;

  BIC({
    required this.bicId,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.exists,
    required this.nicknames,
    required this.imagesUris,
    required this.histories,
  });
}
