import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_expense/src/models/expense.dart';
import 'package:smart_expense/src/ui/widgets/expense_card.dart';
import 'package:smart_expense/src/viewmodels/auth_vm.dart';
import 'package:smart_expense/src/viewmodels/expense_vm.dart';


class ExpenseListScreen extends StatelessWidget {
  const ExpenseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExpenseVM>();
    final auth = context.watch<AuthVM>();

    return Scaffold(
      appBar: AppBar(title: const Text('Expenses')),
      body: RefreshIndicator(
        onRefresh: () async {
          // No manual refresh needed since Firestore streams; this is UX sugar
          vm.setQuery(vm.query); // triggers notify
        },
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              Expanded(child: TextField(
                decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search'),
                onChanged: vm.setQuery,
              )),
              const SizedBox(width: 8),
              DropdownButton<ExpenseCategory?>(
                value: vm.category,
                items: [
                  const DropdownMenuItem(value: null, child: Text('All')),
                  ...ExpenseCategory.values.map((c)=> DropdownMenuItem(value: c, child: Text(c.name.toUpperCase())))
                ],
                onChanged: vm.setCategory,
              ),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: vm.filtered.length,
              itemBuilder: (_, i) => ExpenseCard(
                expense: vm.filtered[i],
                onDelete: () => vm.deleteExpense(auth.user!.uid, vm.filtered[i].id),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
