import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik_admin/provider/report_provider.dart';

class ChartSample extends StatelessWidget {
  const ChartSample({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 300,
        padding: const EdgeInsets.all(10),
        child: Consumer<ReportProvider>(
          builder: (context, report, child) => LineChart(
            LineChartData(
              lineTouchData: const LineTouchData(
                enabled: true,
              ),
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 31,
                    // interval: 1,
                    getTitlesWidget: bottomTitleWidgets,
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    getTitlesWidget: leftTitleWidgets,
                    showTitles: true,
                    interval: 1,
                    reservedSize: 40,
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  bottom: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.2),
                      width: 4),
                  left: const BorderSide(color: Colors.transparent),
                  right: const BorderSide(color: Colors.transparent),
                  top: const BorderSide(color: Colors.transparent),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  color: Colors.pink.withOpacity(0.5),
                  barWidth: 4,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.pink.withOpacity(0.2),
                  ),
                  spots: List.generate(31, (index) => index).map((e) {
                    var random = Random();
                    return FlSpot(
                        e.toDouble(), 3 + random.nextInt(10).toDouble());
                  }).toList(),
                  // List.generate(31, (index) => index).map((e) {
                  //   double qty;
                  //   qty = report.reports
                  //       .where((element) {
                  //         return element.date.day == e;
                  //       })
                  //       .toList()
                  //       .length
                  //       .toDouble();
                  //   return FlSpot(e.toDouble(), qty);
                  // }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget leftTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  String text = '${value.toInt()}';

  return Text(text, style: style, textAlign: TextAlign.center);
}

Widget bottomTitleWidgets(double value, TitleMeta meta) {
  Widget text = Text('${value.toInt()}');

  return text;
}
