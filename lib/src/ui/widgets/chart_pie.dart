import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartPie extends StatelessWidget {
  final Map<String, double> data;
  const ChartPie({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final items = data.entries.toList();
    final total = items.fold<double>(0, (s, e) => s + e.value);
    return PieChart(
      PieChartData(
        sections: [
          for (int i=0;i<items.length;i++)
            PieChartSectionData(
              value: items[i].value,
              title: total==0 ? '' : '${((items[i].value/total)*100).toStringAsFixed(0)}%',
              radius: 50,
            )
        ],
        sectionsSpace: 1,
        centerSpaceRadius: 30,
      ),
    );
  }
}
