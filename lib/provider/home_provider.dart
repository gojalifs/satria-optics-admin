import 'package:satria_optik_admin/provider/base_provider.dart';

class HomeProvider extends BaseProvider {
  String _page = 'dashboard';

  String get page => _page;

  set page(String page) {
    _page = page;
    notifyListeners();
  }
}
