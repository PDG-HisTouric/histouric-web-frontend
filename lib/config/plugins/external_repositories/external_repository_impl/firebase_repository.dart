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

  @override
  Future<String?> uploadAudio(String fileName, Uint8List audio) async {
    final UploadTask task;
    final Reference ref = storage.ref().child('audios').child('/$fileName');
    task = ref.putData(audio);
    final TaskSnapshot snapshot = await task;
    if (snapshot.state != TaskState.success) return null;
    return await snapshot.ref.getDownloadURL();
  }

  @override
  Future<String?> uploadVideo(String fileName, Uint8List video) async {
    final UploadTask task;
    final Reference ref = storage.ref().child('videos').child('/$fileName');
    task = ref.putData(video);
    final TaskSnapshot snapshot = await task;
    if (snapshot.state != TaskState.success) return null;
    return await snapshot.ref.getDownloadURL();
  }
}
