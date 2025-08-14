import 'package:flutter/material.dart';
import '../../models/expense.dart';
import 'package:intl/intl.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final VoidCallback onDelete;
  const ExpenseCard({super.key, required this.expense, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(child: Text(expense.category.name.substring(0,1).toUpperCase())),
        title: Text(expense.title),
        subtitle: Text('${DateFormat.yMMMd().format(expense.date)} • ${expense.category.name.toUpperCase()}'),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('₹${expense.amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
            IconButton(icon: const Icon(Icons.delete_outline), onPressed: onDelete)
          ],
        ),
        onTap: () {
          if (expense.imageUrl != null) {
            showDialog(context: context, builder: (_) => Dialog(child: Image.network(expense.imageUrl!)));
          }
        },
      ),
    );
  }
}
