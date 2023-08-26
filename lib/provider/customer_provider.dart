import 'package:satria_optik_admin/helper/customer_helper.dart';
import 'package:satria_optik_admin/model/customer.dart';
import 'package:satria_optik_admin/provider/base_provider.dart';

class CustomerProvider extends BaseProvider {
  final _helper = CustomerHelper();
  List<Customer> customers = [];
  List<Customer> filteredCustomers = [];

  Future getCustomers() async {
    try {
      customers = await _helper.getCustomers();
      filteredCustomers = customers;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  find(String query) {
    if (query.isEmpty) {
      filteredCustomers = Customer.search(customers, query);
    } else {}
    filteredCustomers = Customer.search(customers, query);
    notifyListeners();
  }
}
