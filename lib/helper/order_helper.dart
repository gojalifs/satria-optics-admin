import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:satria_optik_admin/helper/firebase_helper.dart';
import 'package:satria_optik_admin/model/order.dart';
import 'package:satria_optik_admin/model/order_summary.dart';

class OrderHelper extends FirestoreHelper {
  /// TODO using FCM
  getNotification() {}

  Future<List<OrderModel>> getNewOrder(String orderStatus) async {
    List<OrderModel> orders = [];
    var data = await db
        .collectionGroup('transactions')
        .where('paymentStatus', isEqualTo: 'Paid')
        .where('orderStatus', isEqualTo: orderStatus)
        .orderBy('orderMadeTime', descending: true)
        .get();
    String ref;
    for (var element in data.docs) {
      var data = element.data();
      ref = element.reference.path;
      ref = ref
          .replaceAll('users/', '')
          .replaceAll('transactions/', '')
          .split('/')
          .first;

      data['id'] = element.id;
      data['user'] = ref;
      var address = data['address'] as DocumentReference<Map<String, dynamic>>;
      data['address'] = await address.get().then((value) => value.data());

      orders.add(OrderModel.fromMap(data));
    }
    return orders;
  }

  Future<List<OrderModel>> getRangedOrder(DateTime start, DateTime end) async {
    List<OrderModel> orders = [];
    var ref = db
        .collectionGroup('transactions')
        .where(
          'orderMadeTime',
          isGreaterThanOrEqualTo: start,
          isLessThanOrEqualTo: end,
        )
        .where('orderStatus', isEqualTo: 'Done')
        .orderBy('orderMadeTime', descending: true);
    var data = await ref.get();
    for (var element in data.docs) {
      var data = element.data();

      data['id'] = element.id;
      var address = data['address'] as DocumentReference<Map<String, dynamic>>;
      data['address'] = await address.get().then((value) => value.data());

      orders.add(OrderModel.fromMap(data));
    }
    return orders;
  }

  Future insertReceipt(
      String user, String id, bool isProceed, String data) async {
    try {
      var ref =
          db.collection('users').doc(user).collection('transactions').doc(id);
      if (isProceed) {
        await ref.set(
          {
            'receiptNumber': data,
            'orderStatus': 'Shipping',
            'deliveryStatus': 'On Courier',
          },
          SetOptions(merge: true),
        );
      } else {
        await ref.set(
          {'cancelReason': data, 'orderStatus': 'cancelled'},
          SetOptions(merge: true),
        );
      }
    } catch (e) {
      throw 'Something error when updating the data';
    }
  }

  Future<OrderSummary> getTodaySummary() async {
    try {
      var time = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );
      print(time);
      var ref = db
          .collectionGroup('transactions')
          .where(
            'paymentMadeTime',
            isGreaterThanOrEqualTo: time,
          )
          .where('paymentStatus', isEqualTo: 'Paid')
          .orderBy('paymentMadeTime', descending: true);
      var data = await ref.get();
      var count = data.size;
      var total = 0;
      for (var element in data.docs) {
        var dataMap = element.data();
        int subTotal = dataMap['total'];
        total += subTotal;
      }
      return OrderSummary(total: '$total', count: count);
    } catch (e) {
      throw 'Error Getting Data';
    }
  }
}
