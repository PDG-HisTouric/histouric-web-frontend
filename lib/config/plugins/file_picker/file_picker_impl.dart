import 'dart:typed_data';

import 'abstract_file_picker.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerImpl implements AbstractFilePicker {
  @override
  Future<(List<Uint8List> images, List<String> extensions, List<String> names)>
      selectImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
      allowMultiple: true,
    );
    return (
      result?.files.map((file) => file.bytes!).toList() ?? [],
      result?.files.map((file) => file.extension!).toList() ?? [],
      result?.files.map((file) => file.name).toList() ?? []
    );
  }

  @override
  Future<(Uint8List? audio, String? extension, String? name)>
      selectAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'mpeg', 'wav'],
      allowMultiple: false,
    );
    return (
      result?.files.first.bytes,
      result?.files.first.extension,
      result?.files.first.name
    );
  }

  @override
  Future<(List<Uint8List> videos, List<String> extensions, List<String> names)>
      selectVideos() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4', 'webm'],
      allowMultiple: true,
    );

    return (
      result?.files.map((file) => file.bytes!).toList() ?? [],
      result?.files.map((file) => file.extension!).toList() ?? [],
      result?.files.map((file) => file.name).toList() ?? []
    );
  }
}
