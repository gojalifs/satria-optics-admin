import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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
        child: LineChart(
          LineChartData(
            lineTouchData: const LineTouchData(
              enabled: false,
            ),
            gridData: const FlGridData(show: false),
            titlesData: const FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  interval: 1,
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
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    width: 4),
                left: const BorderSide(color: Colors.transparent),
                right: const BorderSide(color: Colors.transparent),
                top: const BorderSide(color: Colors.transparent),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                isCurved: true,
                curveSmoothness: 0,
                color: Colors.green.withOpacity(0.5),
                barWidth: 4,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(show: false),
                spots: const [
                  FlSpot(1, 1),
                  FlSpot(3, 4),
                  FlSpot(5, 1.8),
                  FlSpot(7, 5),
                  FlSpot(10, 2),
                  FlSpot(12, 2.2),
                  FlSpot(13, 1.8),
                ],
              ),
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
                spots: const [
                  FlSpot(1, 1),
                  FlSpot(3, 2.8),
                  FlSpot(7, 1.2),
                  FlSpot(10, 2.8),
                  FlSpot(12, 2.6),
                  FlSpot(13, 3.9),
                ],
              ),
              LineChartBarData(
                isCurved: true,
                curveSmoothness: 0,
                color: Colors.cyan.withOpacity(0.5),
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(show: false),
                spots: const [
                  FlSpot(1, 3.8),
                  FlSpot(3, 1.9),
                  FlSpot(6, 5),
                  FlSpot(10, 3.3),
                  FlSpot(13, 4.5),
                ],
              ),
            ],
            minX: 0,
            maxX: 14,
            maxY: 6,
            minY: 0,
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
  String text;
  switch (value.toInt()) {
    case 1:
      text = '1m';
      break;
    case 2:
      text = '2m';
      break;
    case 3:
      text = '3m';
      break;
    case 4:
      text = '5m';
      break;
    case 5:
      text = '6m';
      break;
    default:
      return Container();
  }

  return Text(text, style: style, textAlign: TextAlign.center);
}

Widget bottomTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
  Widget text = const Text('');
  switch (value.toInt()) {
    case 2:
      text = const Text('SEPT', style: style);
      break;
    case 7:
      text = const Text('OCT', style: style);
      break;
    case 12:
      text = const Text('DEC', style: style);
      break;
    default:
      text = const Text('');
      break;
  }
  return text;
}
