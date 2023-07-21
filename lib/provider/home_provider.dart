import 'package:satria_optik_admin/provider/base_provider.dart';

class HomeProvider extends BaseProvider {
  int _index = 0;

  int get index => _index;

  set index(int index) {
    _index = index;
    notifyListeners();
  }
}
