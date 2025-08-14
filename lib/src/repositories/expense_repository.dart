import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';
import '../services/firestore_service.dart';
import '../services/hive_service.dart';

class ExpenseRepository {
  final FirestoreService _fs;
  ExpenseRepository(this._fs);

  Stream<List<Expense>> streamExpenses(String uid) {
    return _fs.expenseCol(uid)
      .orderBy('date', descending: true)
      .snapshots()
      .map((snap) {
        final list = snap.docs.map((d) => Expense.fromDoc(d)).toList();
        // cache
        HiveService.cacheExpenses(uid, list.map((e) => e.toMap()).toList());
        return list;
      });
  }

  Future<List<Expense>> getCached(String uid) async {
    final cached = HiveService.getCachedExpenses(uid)
      .map((m) => Expense(
        id: m['id'],
        uid: m['uid'],
        title: m['title'],
        amount: (m['amount'] as num).toDouble(),
        date: (m['date'] as Timestamp?)?.toDate() ?? DateTime.parse(m['date']),
        category: ExpenseCategory.values.firstWhere(
          (e) => e.name == (m['category'] ?? 'others'),
          orElse: () => ExpenseCategory.others),
        imageUrl: m['imageUrl'],
        createdAt: (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.parse(m['createdAt']),
        updatedAt: (m['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.parse(m['updatedAt']),
      )).toList();
    return cached;
  }

  Future<void> addExpense(String uid, Expense e) =>
    _fs.expenseCol(uid).doc(e.id).set(e.toMap(), SetOptions(merge: true));

  Future<void> deleteExpense(String uid, String id) =>
    _fs.expenseCol(uid).doc(id).delete();
}
