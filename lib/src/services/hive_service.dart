import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


class HiveService {
  static const _expenseBox = 'expense_cache';

  static Future<void> init() async {
    await Hive.initFlutter();
    // We store expenses as Map<String, dynamic> (no adapter needed)
    await Hive.openBox(_expenseBox);
  }

  static Future<void> cacheExpenses(String uid, List<Map<String, dynamic>> list) async {
    final box = Hive.box(_expenseBox);
    await box.put(uid, list);
  }

  static List<Map<String, dynamic>> getCachedExpenses(String uid) {
    final box = Hive.box(_expenseBox);
    return (box.get(uid) as List?)?.cast<Map>() .map((e) => Map<String, dynamic>.from(e)).toList() ?? [];
  }
}
