import 'package:flutter/material.dart';
import '../models/user_profile.dart';


class BudgetVM extends ChangeNotifier {
  double monthlyBudget = 0;
  double monthTotal = 0;

  Future<void> updateFromProfile(UserProfile p) async {
    monthlyBudget = p.monthlyBudget;
    notifyListeners();
  }

  void setMonthTotal(double total) {
    monthTotal = total; notifyListeners();
  }

  bool get nearing => monthlyBudget > 0 && monthTotal >= monthlyBudget * 0.8 && monthTotal < monthlyBudget;
  bool get exceeded => monthlyBudget > 0 && monthTotal >= monthlyBudget;
}
