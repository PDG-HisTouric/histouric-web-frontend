import 'dart:typed_data';

import 'abstract_file_picker.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerImpl implements AbstractFilePicker {
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
  Future<(Uint8List?, String?)> selectAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3, mpeg, wav'],
      allowMultiple: false,
    );
    return (result?.files.first.bytes, result?.files.first.extension);
  }

  @override
  Future<(List<Uint8List>, List<String>)> selectVideos() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4, webm'],
      allowMultiple: true,
    );

    return (
      result?.files.map((file) => file.bytes!).toList() ?? [],
      result?.files.map((file) => file.extension!).toList() ?? []
    );
  }
}
