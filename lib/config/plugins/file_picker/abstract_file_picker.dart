import 'dart:typed_data';

abstract class AbstractFilePicker {
  Future<List<Uint8List>> selecFile();
}
