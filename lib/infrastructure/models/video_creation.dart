import 'dart:typed_data';

class VideoCreation {
  final String? videoUri;
  final Uint8List? videoFile;
  final String? videoName;
  final bool needsUrlGen;

  VideoCreation({
    this.videoUri,
    this.videoFile,
    this.videoName,
    required this.needsUrlGen,
  });

  VideoCreation copyWith({
    String? videoUri,
    Uint8List? videoFile,
    String? videoName,
    bool? needsUrlGen,
  }) {
    return VideoCreation(
      videoUri: videoUri ?? this.videoUri,
      videoFile: videoFile ?? this.videoFile,
      videoName: videoName ?? this.videoName,
      needsUrlGen: needsUrlGen ?? this.needsUrlGen,
    );
  }
}
