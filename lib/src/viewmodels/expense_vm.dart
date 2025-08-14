import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/expense.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';
import '../repositories/expense_repository.dart';
import 'auth_vm.dart';

class ExpenseVM extends ChangeNotifier {
  final _repo = ExpenseRepository(FirestoreService());
  final _storage = StorageService();

  List<Expense> _all = [];
  List<Expense> filtered = [];
  bool loading = false;
  String query = '';
  ExpenseCategory? category;

  Stream<List<Expense>>? _stream;

  void init() {}

  void attachAuth(AuthVM auth) {
    final uid = auth.user?.uid;
    if (uid == null) return;
    _stream = _repo.streamExpenses(uid);
    _stream!.listen((list) {
      _all = list;
      _applyFilters();
    }, onError: (_) async {
      _all = await _repo.getCached(uid);
      _applyFilters();
    });
  }

  void _applyFilters() {
    filtered = _all.where((e) {
      final matchesQ = query.isEmpty || e.title.toLowerCase().contains(query.toLowerCase());
      final matchesC = category == null || e.category == category;
      return matchesQ && matchesC;
    }).toList();
    notifyListeners();
  }

  void setQuery(String q) { query = q; _applyFilters(); }
  void setCategory(ExpenseCategory? c) { category = c; _applyFilters(); }

  Future<String?> addExpense({
    required String uid,
    required String title,
    required double amount,
    required DateTime date,
    required ExpenseCategory category,
    File? receipt,
  }) async {
    try {
      loading = true; notifyListeners();
      String? url;
      if (receipt != null) {
        url = await _storage.uploadReceipt(uid, receipt);
      }
      final now = DateTime.now();
      final exp = Expense(
        id: const Uuid().v4(),
        uid: uid,
        title: title,
        amount: amount,
        date: date,
        category: category,
        imageUrl: url,
        createdAt: now,
        updatedAt: now,
      );
      await _repo.addExpense(uid, exp);
      return null;
    } catch (e) { return e.toString(); }
    finally { loading = false; notifyListeners(); }
  }

  Future<void> deleteExpense(String uid, String id) => _repo.deleteExpense(uid, id);
}
