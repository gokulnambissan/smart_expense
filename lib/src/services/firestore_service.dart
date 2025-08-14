import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  CollectionReference userCol() => _db.collection('users');
  CollectionReference expenseCol(String uid) => userCol().doc(uid).collection('expenses');

  Future<void> setUser(String uid, Map<String, dynamic> data) =>
      userCol().doc(uid).set(data, SetOptions(merge: true));
}
