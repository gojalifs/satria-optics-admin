import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:satria_optik_admin/provider/report_provider.dart';
import 'package:satria_optik_admin/screen/main/chart_card.dart';

class MonthlyReportPage extends StatefulWidget {
  static const String page = '/monthly-report';
  const MonthlyReportPage({super.key});

  @override
  State<MonthlyReportPage> createState() => _MonthlyReportPageState();
}

class _MonthlyReportPageState extends State<MonthlyReportPage> {
  bool showFab = true;

  var duration = const Duration(milliseconds: 300);
  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Report')),
      floatingActionButton: AnimatedSlide(
        duration: duration,
        offset: showFab ? Offset.zero : const Offset(0, 2),
        child: AnimatedOpacity(
          duration: duration,
          opacity: showFab ? 1 : 0,
          child: Consumer<ReportProvider>(
            builder: (context, value, child) => ElevatedButton(
              onPressed: () async {
                try {
                  await value.exportToExcel(_key);
                } catch (e) {
                  CherryToast.error(title: Text('$e')).show(context);
                }
              },
              child: const Text('Export To Excel'),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          final ScrollDirection direction = notification.direction;
          setState(() {
            if (direction == ScrollDirection.reverse) {
              showFab = false;
            } else if (direction == ScrollDirection.forward) {
              showFab = true;
            }
          });
          return true;
        },
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            Row(
              children: [
                const Text('Pick a Month'),
                Consumer<ReportProvider>(
                  builder: (context, report, child) => TextButton(
                    onPressed: () async {
                      var month = await showMonthYearPicker(
                        context: context,
                        initialDate: report.month ?? DateTime.now(),
                        firstDate: DateTime(2023, 1),
                        lastDate: DateTime.now(),
                      );
                      if (month != null) {
                        report.setMonth = month;
                        await report.getReport();
                      }
                    },
                    child: Text(formatMonth(report.month) ?? 'Pick A Date'),
                  ),
                ),
              ],
            ),
            const ChartSample(),
            const Divider(height: 30),
            const Center(
                child: Text(
              'Detail Data Penjualan',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            )),
            SizedBox(
              child: Consumer<ReportProvider>(
                builder: (context, reports, child) {
                  if (reports.dataSource == null) {
                    return const SizedBox();
                  }
                  return SfDataGrid(
                    shrinkWrapRows: true,
                    allowColumnsResizing: true,
                    verticalScrollPhysics: const NeverScrollableScrollPhysics(),
                    showHorizontalScrollbar: true,
                    columnWidthMode: ColumnWidthMode.fitByCellValue,
                    key: _key,
                    source: reports.dataSource!,
                    columns: [
                      GridColumn(
                        columnName: 'ID Order',
                        label: const Center(
                            child: Text(
                          'ID Order',
                          style: TextStyle(fontSize: 20),
                        )),
                      ),
                      GridColumn(
                        columnName: 'Tanggal',
                        label: const Center(
                          child: Text(
                            'Tanggal',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'Total',
                        label: const Center(
                          child: Text(
                            'Total',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
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
