import 'dart:typed_data';

import 'abstract_file_picker.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerImpl implements AbstractFilePicker {
  @override
  Future<Uint8List> selectAudio() {
    // TODO: implement selectAudio
    throw UnimplementedError();
  }

  @override
  Future<(List<Uint8List>, List<String>)> selectImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
      allowMultiple: true,
    );
    return (
      result?.files.map((file) => file.bytes!).toList() ?? [],
      result?.files.map((file) => file.extension!).toList() ?? []
    );
  }

  @override
  Future<List<Uint8List>> selectVideos() {
    // TODO: implement selectVideos
    throw UnimplementedError();
  }
}
