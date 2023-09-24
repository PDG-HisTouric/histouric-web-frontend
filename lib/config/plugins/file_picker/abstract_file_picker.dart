import 'dart:typed_data';

abstract class AbstractFilePicker {
  Future<(List<Uint8List> images, List<String> extensions, List<String> names)>
      selectImages();
  Future<(List<Uint8List> videos, List<String> extensions, List<String> names)>
      selectVideos();
  Future<(Uint8List? audio, String? extension, String? name)> selectAudio();
}
