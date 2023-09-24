import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import '../external_repository.dart';

class FirebaseRepository extends ExternalRepository {
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Future<String?> uploadImage(String fileName, Uint8List image) async {
    final UploadTask task;
    final Reference ref = storage.ref().child('images').child('/$fileName');
    task = ref.putData(image);
    final TaskSnapshot snapshot = await task;
    if (snapshot.state != TaskState.success) return null;
    return await snapshot.ref.getDownloadURL();
  }
}
