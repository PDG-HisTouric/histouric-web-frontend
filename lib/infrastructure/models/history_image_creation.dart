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

  HistoryImageCreation copyWith({
    String? imageUri,
    Uint8List? imageFile,
    String? imageName,
    int? startTime,
    bool? needsUrlGen,
  }) {
    return HistoryImageCreation(
      imageUri: imageUri ?? this.imageUri,
      imageFile: imageFile ?? this.imageFile,
      imageName: imageName ?? this.imageName,
      startTime: startTime ?? this.startTime,
      needsUrlGen: needsUrlGen ?? this.needsUrlGen,
    );
  }
}
