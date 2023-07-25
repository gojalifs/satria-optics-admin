import 'package:flutter/material.dart';
import 'package:satria_optik_admin/helper/order_helper.dart';
import 'package:satria_optik_admin/model/order.dart';
import 'package:satria_optik_admin/provider/base_provider.dart';

class OrderProvider extends BaseProvider {
  final OrderHelper _orderHelper = OrderHelper();
  List<OrderModel> _newOrders = [];
  List<OrderModel> _shippings = [];
  final List<OrderModel> _shippingOrder = [];
  OrderModel _order = OrderModel();
  bool _isfirst = true;

  /// TODO perubahan nilai ini jika ada notif masuk,
  /// diubah lg ke false jika halaman new order dibuka
  bool _hasNewOrder = false;

  List<OrderModel> get orders => _newOrders;
  List<OrderModel> get shippings => _shippings;
  OrderModel get order => _order;
  bool get isFirst => _isfirst;
  bool get hasNewOrder => _hasNewOrder;

  set order(OrderModel order) {
    _order = order;
    notifyListeners();
  }

  set hasNewOrder(bool status) {
    _hasNewOrder = status;
    notifyListeners();
  }

  Future getNewOrder(String orderStatus) async {
    if (_isfirst) {
      _isfirst = false;
      _hasNewOrder = true;
    }
    if (_newOrders.isEmpty || _shippings.isEmpty || hasNewOrder) {
      state = ConnectionState.active;
      if (orderStatus == 'packing') {
        _newOrders = await _orderHelper.getNewOrder(orderStatus);
      } else {
        _shippings = await _orderHelper.getNewOrder(orderStatus);
      }
      _hasNewOrder = false;
    }

    state = ConnectionState.done;
    notifyListeners();
  }

  Future insertReceipt(bool isproceed, String data) async {
    try {
      if (isproceed) {
        _order = _order.copyWith(
          orderStatus: 'Shipping',
          receiptNumber: data,
        );

        await _orderHelper.insertReceipt(
            _order.user!, _order.id!, isproceed, data);

        var a = _newOrders.indexWhere((element) => element.id == _order.id);
        _newOrders[a] = _order;

        /// add order into shipping order and remove from new order page
        _shippingOrder.add(_order);
        _newOrders.remove(_order);
      } else {
        await _orderHelper.insertReceipt(
            _order.user!, _order.id!, !isproceed, data);
      }
      notifyListeners();
      // else {
      //   throw 'invalid argument, both number and reason cannot filled or both null';
      // }
    } catch (e) {
      rethrow;
    }
  }
}
