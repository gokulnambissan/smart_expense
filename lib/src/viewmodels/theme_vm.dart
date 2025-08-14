import 'package:flutter/material.dart';

class ThemeVM extends ChangeNotifier {
  ThemeMode mode = ThemeMode.system;
  void toggle() {
    mode = (mode == ThemeMode.dark) ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
