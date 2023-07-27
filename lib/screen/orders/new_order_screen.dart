import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik_admin/custom/common_function.dart';
import 'package:satria_optik_admin/model/order.dart';

import 'package:satria_optik_admin/provider/order_provider.dart';
import 'package:satria_optik_admin/screen/orders/order_detail_page.dart';

class NewOrderPage extends StatelessWidget {
  static String page = 'new-order';
  final String orderStatus;

  const NewOrderPage({
    Key? key,
    required this.orderStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, value, child) {
        if (value.state == ConnectionState.active) {
          return const Center(child: CircularProgressIndicator());
        }
        return EasyRefresh(
          onRefresh: () async {
            value.hasNewOrder = true;
            await value.getNewOrder(orderStatus);
          },
          child: ListView.builder(
            itemCount: orderStatus == 'packing'
                ? value.orders.length
                : value.shippings.length,
            itemBuilder: (context, index) {
              OrderModel order;
              if (orderStatus == 'packing') {
                order = value.orders[index];
              } else {
                order = value.shippings[index];
              }

              return InkWell(
                onTap: () {
                  value.order = order;
                  Navigator.of(context).pushNamed(OrderDetailPage.route);
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.id ?? '',
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          formatToRupiah('${order.total}'),
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        const Text(
                          'Tap to see order detail',
                          style: TextStyle(color: Colors.black45),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _MinusDataRow extends StatelessWidget {
  final String data;
  final String title;

  const _MinusDataRow({
    Key? key,
    required this.data,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 2, child: Text(title)),
        Expanded(child: Text(data)),
        Expanded(
          flex: 2,
          child: Text(
            formatToRupiah(data),
            textAlign: TextAlign.end,
            style: const TextStyle(color: Colors.white54),
          ),
        ),
      ],
    );
  }
}
