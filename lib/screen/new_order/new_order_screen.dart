import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik_admin/provider/order_provider.dart';
import 'package:satria_optik_admin/screen/new_order/order_detail_page.dart';

class NewOrderPage extends StatelessWidget {
  static String route = '/new-order';
  const NewOrderPage({Key? key}) : super(key: key);

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
            await value.getNewOrder();
          },
          child: ListView.builder(
            itemCount: value.orders.length,
            itemBuilder: (context, index) {
              var order = value.orders[index];
              return InkWell(
                onTap: () {
                  value.order = order;
                  Navigator.of(context).pushNamed(OrderDetailPage.route);
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.id ?? '',
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              for (final e in order.cartProduct!)
                                if (e.minusData?.leftEyeMinus != null &&
                                    e.minusData!.leftEyeMinus!.isNotEmpty)
                                  _MinusDataRow(
                                    data: e.minusData!.leftEyeMinus!,
                                    title: 'Left Eye Minus',
                                  ),
                              Text(
                                'Rp${350 + (index * 25)}.000',
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
            formatGrandTotalToRupiah(data),
            textAlign: TextAlign.end,
            style: const TextStyle(color: Colors.white54),
          ),
        ),
      ],
    );
  }

  String formatGrandTotalToRupiah(String data) {
    NumberFormat formatToRupiah = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp',
    );
    var price = double.parse(data) * 50000;
    return formatToRupiah.format(price);
  }
}
