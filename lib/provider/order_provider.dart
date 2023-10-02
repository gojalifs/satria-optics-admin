import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:satria_optik_admin/custom/common_function.dart';
import 'package:satria_optik_admin/helper/order_helper.dart';
import 'package:satria_optik_admin/model/order.dart';
import 'package:satria_optik_admin/model/order_summary.dart';
import 'package:satria_optik_admin/provider/base_provider.dart';

class OrderProvider extends BaseProvider {
  final OrderHelper _orderHelper = OrderHelper();
  List<OrderModel> _newOrders = [];
  List<OrderModel> _shippings = [];
  List<OrderModel> _rangedOrder = [];
  OrderModel _order = OrderModel();
  OrderSummary? _summary;
  bool _isfirst = true;
  DateTimeRange? _timeRange;
  String? _range;

  /// TODO perubahan nilai ini jika ada notif masuk,
  /// diubah lg ke false jika halaman new order dibuka
  bool _hasNewOrder = false;

  List<OrderModel> get orders => _newOrders;
  List<OrderModel> get shippings => _shippings;
  List<OrderModel> get rangedOrder => _rangedOrder;
  OrderModel get order => _order;
  bool get isFirst => _isfirst;
  bool get hasNewOrder => _hasNewOrder;
  OrderSummary? get summary => _summary;
  DateTimeRange? get timeRange => _timeRange;
  String? get range => _range;

  set order(OrderModel order) {
    _order = order;
    notifyListeners();
  }

  set hasNewOrder(bool status) {
    _hasNewOrder = status;
    notifyListeners();
  }

  set timeRange(DateTimeRange? range) {
    _timeRange = range;
    var format = DateFormat('yMMMMd');
    var start = format.format(range?.start ?? DateTime.now());
    var end = format.format(range?.end ?? DateTime.now());
    _range = '$start - $end';
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

  Future getRangedOrders() async {
    state = ConnectionState.active;

    var start = _timeRange?.start ?? DateTime.now();
    var end = _timeRange?.end ?? DateTime.now();
    try {
      _rangedOrder = await _orderHelper.getRangedOrder(start, end);
    } catch (e) {
      throw 'something error when trying to get data';
    } finally {
      state = ConnectionState.done;
      notifyListeners();
    }
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
        _shippings.add(_order);
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

  Future getTodaySummary() async {
    state = ConnectionState.active;
    try {
      var result = await _orderHelper.getTodaySummary();
      _summary = result.copyWith(total: formatToRupiah(result.total));
    } catch (e) {
      rethrow;
    } finally {
      state = ConnectionState.done;
      notifyListeners();
    }
  }
}
