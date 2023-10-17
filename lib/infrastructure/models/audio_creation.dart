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

  AudioCreation copyWith({
    String? audioUri,
    Uint8List? audioFile,
    String? audioName,
    bool? needsUrlGen,
  }) {
    return AudioCreation(
      audioUri: audioUri ?? this.audioUri,
      audioFile: audioFile ?? this.audioFile,
      audioName: audioName ?? this.audioName,
      needsUrlGen: needsUrlGen ?? this.needsUrlGen,
    );
  }
}
