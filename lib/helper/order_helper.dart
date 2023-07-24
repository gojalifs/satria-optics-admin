import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:satria_optik_admin/helper/firebase_helper.dart';
import 'package:satria_optik_admin/model/order.dart';

class OrderHelper extends FirestoreHelper {
  /// TODO using FCM
  getNotification() {}

  Future<List<OrderModel>> getNewOrder() async {
    List<OrderModel> orders = [];
    var data = await db
        .collectionGroup('transactions')
        .where('paymentStatus', isEqualTo: 'Paid')
        .where('orderStatus', isEqualTo: 'packing')
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

  Future insertReceipt(
      String user, String id, bool isProceed, String data) async {
    try {
      var ref =
          db.collection('users').doc(user).collection('transactions').doc(id);
      if (isProceed) {
        await ref.set(
          {'receiptNumber': data, 'orderStatus': 'Shipping'},
          SetOptions(merge: true),
        );
      } else {
        await ref.set(
          {'cancelReason': data, 'orderStatus': 'Cancelled by Seller'},
          SetOptions(merge: true),
        );
      }
    } catch (e) {
      throw 'Something error when updating the data';
    }
  }
}
