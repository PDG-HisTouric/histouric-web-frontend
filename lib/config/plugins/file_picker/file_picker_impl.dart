import 'dart:typed_data';

import 'abstract_file_picker.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerImpl implements AbstractFilePicker {
  @override
  Future<List<Uint8List>> selecFile() async {
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles();
    return fileResult?.files.map((file) => file.bytes!).toList() ?? [];
  }
}
