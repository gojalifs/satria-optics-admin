import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:satria_optik_admin/helper/firebase_helper.dart';
import 'package:satria_optik_admin/model/report.dart';

class ReportHelper extends FirestoreHelper {
  Future<List<ReportModel>> monthlyReport(DateTime month) async {
    List<ReportModel> reports = [];
    var ref = await db
        .collectionGroup('transactions')
        .where('orderMadeTime', isGreaterThanOrEqualTo: month)
        .where(
          'orderMadeTime',
          isLessThanOrEqualTo: DateTime(month.year, month.month + 1, month.day),
        )
        .get();
    for (var element in ref.docs) {
      var data = element.data();

      var report = ReportModel(
        id: element.id,
        quantity: (data['cartProduct'] as List).length,
        total: data['total'],
        date: (data['orderMadeTime'] as Timestamp).toDate(),
      );

      reports.add(report);
    }
    return reports;
  }
}
