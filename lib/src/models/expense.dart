import 'package:cloud_firestore/cloud_firestore.dart';

enum ExpenseCategory { food, travel, bills, shopping, others }

class Expense {
  final String id;
  final String uid;
  final String title;
  final double amount;
  final DateTime date;
  final ExpenseCategory category;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Expense({
    required this.id,
    required this.uid,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'uid': uid,
        'title': title,
        'amount': amount,
        'date': Timestamp.fromDate(date),
        'category': category.name,
        'imageUrl': imageUrl,
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': Timestamp.fromDate(updatedAt),
      };

  factory Expense.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return Expense(
      id: d['id'],
      uid: d['uid'],
      title: d['title'],
      amount: (d['amount'] as num).toDouble(),
      date: (d['date'] as Timestamp).toDate(),
      category: ExpenseCategory.values.firstWhere(
        (e) => e.name == (d['category'] ?? 'others'),
        orElse: () => ExpenseCategory.others,
      ),
      imageUrl: d['imageUrl'],
      createdAt: (d['createdAt'] as Timestamp).toDate(),
      updatedAt: (d['updatedAt'] as Timestamp).toDate(),
    );
  }
}
