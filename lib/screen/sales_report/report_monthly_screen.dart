import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik_admin/provider/report_provider.dart';
import 'package:satria_optik_admin/screen/main/chart_card.dart';

class MonthlyReportPage extends StatelessWidget {
  static String route = '/monthly-report';
  const MonthlyReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Report')),
      floatingActionButton: ElevatedButton(
        onPressed: () {},
        child: const Text('Export To Excel'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ListView(
        children: [
          Row(
            children: [
              const Text('Pick a Month'),
              Consumer<ReportProvider>(
                builder: (context, report, child) => TextButton(
                  onPressed: () async {
                    var month = await showMonthYearPicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2023, 1),
                      lastDate: DateTime.now(),
                    );
                    if (month != null) {
                      report.setMonth = month;
                    }
                  },
                  child: Text(formatMonth(report.month) ?? 'Pick A Date'),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: ChartSample(),
          ),
        ],
      ),
    );
  }

  formatMonth(DateTime? month) {
    var format = DateFormat('MMMM yyyy');
    if (month != null) {
      return format.format(month);
    }
  }
}
