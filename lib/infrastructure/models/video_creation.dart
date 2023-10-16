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
}
