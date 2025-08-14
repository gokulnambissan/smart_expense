import 'package:flutter/material.dart';
import '../../viewmodels/budget_vm.dart';

class BudgetBanner extends StatelessWidget {
  final BudgetVM vm;
  const BudgetBanner({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    if (vm.monthlyBudget == 0) return const SizedBox.shrink();
    Color bg = Colors.transparent;
    String text = '';
    if (vm.exceeded) { bg = Colors.red.withOpacity(0.15); text = 'You exceeded budget!'; }
    else if (vm.nearing) { bg = Colors.orange.withOpacity(0.15); text = 'You are nearing the budget.'; }
    else { bg = Colors.green.withOpacity(0.12); text = 'Within budget.'; }

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
