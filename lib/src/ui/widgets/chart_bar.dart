import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final List<double> monthData; // size 12
  const ChartBar({super.key, required this.monthData});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        titlesData: FlTitlesData(show: true),
        barGroups: [
          for (int i=0;i<monthData.length;i++)
            BarChartGroupData(x: i, barRods: [BarChartRodData(toY: monthData[i])])
        ],
      ),
    );
  }
}
