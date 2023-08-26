import 'dart:io';

import 'package:cr_file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:satria_optik_admin/helper/report_helper.dart';
import 'package:satria_optik_admin/model/report.dart';
import 'package:satria_optik_admin/model/report_data_source.dart';
import 'package:satria_optik_admin/provider/base_provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ReportProvider extends BaseProvider {
  final _helper = ReportHelper();
  DateTime? _month;
  ReportDataSource? _dataSource;
  List<ReportModel> _reports = [];

  DateTime? get month => _month;
  List<ReportModel> get reports => _reports;
  ReportDataSource? get dataSource => _dataSource;

  set month(DateTime? month) {
    _month = month;
    notifyListeners();
  }

  Future getReport() async {
    if (month != null) {
      _reports = await _helper.monthlyReport(month!);
      _dataSource = ReportDataSource(reports: _reports);
      notifyListeners();
    }
  }

  Future exportToExcel(GlobalKey<SfDataGridState> key) async {
    try {
      var tempPath = await getTemporaryDirectory();
      var filename = 'report.xlsx';
      final Workbook workbook = key.currentState!.exportToExcelWorkbook();
      final List<int> bytes = workbook.saveAsStream();
      File file = File('${tempPath.path}/$filename');
      await file.writeAsBytes(bytes);
      CRFileSaver.saveFileWithDialog(SaveFileDialogParams(
          sourceFilePath: file.path, destinationFileName: filename));
    } catch (e) {
      throw 'Failed to export to excel. Please try again.';
    }
  }
}
