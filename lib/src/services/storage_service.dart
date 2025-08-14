import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final _storage = FirebaseStorage.instance;

  Future<String> uploadReceipt(String uid, File file) async {
    final ref = _storage.ref().child('receipts/$uid/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }
}
