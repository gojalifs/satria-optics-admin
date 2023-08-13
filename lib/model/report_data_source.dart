import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:satria_optik_admin/custom/common_function.dart';
import 'package:satria_optik_admin/model/report.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ReportDataSource extends DataGridSource {
  List<DataGridRow> _reports = [];

  @override
  List<DataGridRow> get rows => _reports;

  ReportDataSource({required List<ReportModel> reports}) {
    _reports = reports
        .map(
          (e) => DataGridRow(
            cells: [
              DataGridCell(columnName: 'ID Order', value: e.id),
              DataGridCell(
                columnName: 'Tanggal',
                value: DateFormat('MMMM dd, yyyy').format(e.date),
              ),
              DataGridCell(
                columnName: 'Total',
                value: formatToRupiah('${e.total}'),
              ),
            ],
          ),
        )
        .toList();
  }
  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row
          .getCells()
          .map(
            (e) => Text('${e.value}'),
          )
          .toList(),
    );
  }
}
