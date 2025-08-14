import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_expense/src/models/expense.dart';
import 'package:smart_expense/src/ui/widgets/budget_banner.dart';
import 'package:smart_expense/src/ui/widgets/chart_bar.dart';
import 'package:smart_expense/src/ui/widgets/chart_pie.dart';
import 'package:smart_expense/src/viewmodels/auth_vm.dart';
import 'package:smart_expense/src/viewmodels/budget_vm.dart';
import 'package:smart_expense/src/viewmodels/expense_vm.dart';
import 'package:smart_expense/src/viewmodels/profile_vm.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final auth = context.read<AuthVM>();
    context.read<ExpenseVM>().attachAuth(auth);
    final uid = auth.user?.uid;
    if (uid != null) context.read<ProfileVM>().load(uid);
  }

  @override
  Widget build(BuildContext context) {
    final expenseVM = context.watch<ExpenseVM>();
    final profileVM = context.watch<ProfileVM>();
    final budgetVM = context.watch<BudgetVM>();

    final month = DateTime.now();
    final monthExpenses = expenseVM.filtered.where((e) => e.date.month == month.month && e.date.year == month.year).toList();
    final monthTotal = monthExpenses.fold<double>(0, (s, e) => s + e.amount);
    budgetVM.setMonthTotal(monthTotal);

    final byCat = <String,double>{};
    for (var c in ExpenseCategory.values) {
      byCat[c.name] = monthExpenses.where((e)=> e.category == c).fold(0.0, (s,e)=> s+e.amount);
    }

    // Very light bar data: last 6 months totals
    final List<double> barData = List.generate(12, (i) => 0);
    for (final e in expenseVM.filtered) {
      if (e.date.year == month.year) { barData[e.date.month-1] += e.amount; }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(icon: const Icon(Icons.list), onPressed: ()=> Navigator.pushNamed(context, '/list')),
          IconButton(icon: const Icon(Icons.person), onPressed: ()=> Navigator.pushNamed(context, '/profile')),
          IconButton(icon: const Icon(Icons.settings), onPressed: ()=> Navigator.pushNamed(context, '/settings')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=> Navigator.pushNamed(context, '/add'),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(children: [
          Text('Total this month: ₹${NumberFormat('#,##0.##').format(monthTotal)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (profileVM.profile != null) BudgetBanner(vm: budgetVM),
          const SizedBox(height: 12),
          Card(child: SizedBox(height: 200, child: Padding(
            padding: const EdgeInsets.all(12), child: ChartPie(data: byCat),
          ))),
          const SizedBox(height: 12),
          Card(child: SizedBox(height: 220, child: Padding(
            padding: const EdgeInsets.all(12), child: ChartBar(monthData: barData),
          ))),
        ]),
      ),
    );
  }
}
