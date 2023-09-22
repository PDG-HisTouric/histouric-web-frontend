import 'dart:typed_data';

abstract class AbstractFilePicker {
  Future<(List<Uint8List>, List<String>)> selectImages();
  Future<(List<Uint8List>, List<String>)> selectVideos();
  Future<(Uint8List?, String?)> selectAudio();
}
