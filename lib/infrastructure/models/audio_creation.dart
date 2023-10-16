import 'dart:typed_data';

class AudioCreation {
  final String? audioUri;
  final Uint8List? audioFile;
  final String? audioName;
  final bool needsUrlGen;

  AudioCreation({
    this.audioUri,
    this.audioFile,
    this.audioName,
    required this.needsUrlGen,
  });
}
