import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:smart_expense/src/models/expense.dart';
import 'package:smart_expense/src/services/speech_service.dart';
import 'package:smart_expense/src/viewmodels/auth_vm.dart';
import 'package:smart_expense/src/viewmodels/expense_vm.dart';


class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});
  @override State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final title = TextEditingController();
  final amount = TextEditingController();
  DateTime date = DateTime.now();
  ExpenseCategory category = ExpenseCategory.food;
  File? receipt;
  final speech = SpeechService();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExpenseVM>();
    final auth = context.watch<AuthVM>();

    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(children: [
          TextField(controller: title, decoration: InputDecoration(
            labelText: 'Title',
            suffixIcon: IconButton(
              icon: Icon(speech.isListening ? Icons.stop_circle : Icons.mic),
              onPressed: () async {
                final ok = await speech.init();
                if (!ok) return;
                if (!speech.isListening) {
                  await speech.listen((txt) {
                    setState(() => title.text = txt);
                  });
                } else {
                  await speech.stop();
                  setState(() {});
                }
              },
            ),
          )),
          const SizedBox(height: 8),
          TextField(controller: amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount')),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: Text('Date: ${date.toLocal().toString().split(' ').first}')),
            TextButton(onPressed: () async {
              final picked = await showDatePicker(context: context, firstDate: DateTime(2020), lastDate: DateTime(2100), initialDate: date);
              if (picked != null) setState(()=> date = picked);
            }, child: const Text('Pick'))
          ]),
          const SizedBox(height: 8),
          DropdownButtonFormField<ExpenseCategory>(
            value: category,
            items: ExpenseCategory.values.map((c)=> DropdownMenuItem(value: c, child: Text(c.name.toUpperCase()))).toList(),
            onChanged: (v){ if (v!=null) setState(()=> category = v); },
            decoration: const InputDecoration(labelText: 'Category'),
          ),
          const SizedBox(height: 8),
          Row(children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.image),
              label: const Text('Upload Receipt'),
              onPressed: () async {
                final img = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
                if (img != null) setState(()=> receipt = File(img.path));
              },
            ),
            const SizedBox(width: 12),
            if (receipt != null) const Icon(Icons.check_circle),
          ]),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: vm.loading ? null : () async {
              final uid = auth.user!.uid;
              final amt = double.tryParse(amount.text.trim()) ?? 0;
              final err = await vm.addExpense(uid: uid, title: title.text.trim(), amount: amt, date: date, category: category, receipt: receipt);
              if (err != null) _err(err);
              else if (mounted) Navigator.pop(context);
            },
            child: Text(vm.loading ? 'Saving...' : 'Save'),
          )
        ]),
      ),
    );
  }

  void _err(String e) => showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Error'), content: Text(e)));
}
