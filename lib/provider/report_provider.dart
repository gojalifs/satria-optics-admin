import 'package:satria_optik_admin/provider/base_provider.dart';

class ReportProvider extends BaseProvider {
  DateTime? _month;

  DateTime? get month => _month;

  set setMonth(DateTime? month) {
    _month = month;
    notifyListeners();
  }
}
