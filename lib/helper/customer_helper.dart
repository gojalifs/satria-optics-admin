import 'package:satria_optik_admin/helper/firebase_helper.dart';
import 'package:satria_optik_admin/model/customer.dart';

class CustomerHelper extends FirestoreHelper {
  Future<List<Customer>> getCustomers() async {
    try {
      List<Customer> customerList = [];
      var ref = db.collection('users');
      var customers = await ref.get();
      for (var customer in customers.docs) {
        var data = customer.data();
        data['id'] = customer.id;
        customerList.add(Customer.fromMap(data));
      }
      return customerList;
    } catch (e) {
      throw 'Failed to get customers data, try again later';
    }
  }
}
