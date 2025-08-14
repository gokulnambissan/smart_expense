import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_expense/src/models/expense.dart';
import 'package:smart_expense/src/services/export_service.dart';
import 'package:smart_expense/src/viewmodels/expense_vm.dart';
import 'package:smart_expense/src/viewmodels/theme_vm.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeVM = context.watch<ThemeVM>();
    final expenseVM = context.watch<ExpenseVM>();
    final export = ExportService();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(children: [
        SwitchListTile(
          title: const Text('Dark Mode'),
          value: themeVM.mode == ThemeMode.dark,
          onChanged: (_) => themeVM.toggle(),
        ),
        ListTile(
          leading: const Icon(Icons.download),
          title: const Text('Export CSV'),
          onTap: () async {
            final rows = expenseVM.filtered.map((e)=>_row(e)).toList();
            final f = await export.exportCsv(rows);
            await export.shareFile(f);
          },
        ),
        ListTile(
          leading: const Icon(Icons.picture_as_pdf),
          title: const Text('Export PDF'),
          onTap: () async {
            final rows = expenseVM.filtered.map((e)=>_row(e)).toList();
            final f = await export.exportPdf(rows);
            await export.shareFile(f);
          },
        ),
      ]),
    );
  }

  Map<String, dynamic> _row(Expense e) => {
    'title': e.title,
    'amount': e.amount,
    'date': e.date.toIso8601String(),
    'category': e.category.name,
  };
}
