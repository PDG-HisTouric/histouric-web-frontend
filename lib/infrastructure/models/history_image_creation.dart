import 'dart:typed_data';

class HistoryImageCreation {
  final String? imageUri;
  final Uint8List? imageFile;
  final String? imageName;
  final int startTime;
  final bool needsUrlGen;

  HistoryImageCreation({
    this.imageUri,
    this.imageFile,
    this.imageName,
    required this.startTime,
    required this.needsUrlGen,
  });
}
