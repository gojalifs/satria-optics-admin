import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik_admin/custom/common_function.dart';
import 'package:satria_optik_admin/provider/order_provider.dart';
import 'package:satria_optik_admin/screen/orders/order_detail_page.dart';
import 'package:shimmer/shimmer.dart';

class AllOrderPage extends StatelessWidget {
  static const String pageName = 'all-order';
  const AllOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        if (pageName == 'all-order')
          const Text(
            'Order History',
            style: TextStyle(fontSize: 24),
          ),
        if (pageName == 'all-order')
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text('Select Date Range'),
              Consumer<OrderProvider>(
                builder: (context, value, child) => TextButton(
                  onPressed: () async {
                    value.timeRange = await showDateRangePicker(
                      context: context,
                      initialDateRange: value.timeRange,
                      firstDate: DateTime(2020, 1, 1),
                      lastDate: DateTime.now(),
                    );
                    if (value.timeRange != null) {
                      await value.getRangedOrders();
                    }
                  },
                  child: Text(value.range ?? 'Select Here'),
                ),
              ),
            ],
          ),
        Consumer<OrderProvider>(
          builder: (context, value, child) {
            if (value.state == ConnectionState.active) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: ListView.builder(
                  itemCount: 10,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => Card(
                    child: Column(
                      children: [
                        Container(
                          height: 20,
                          width: double.maxFinite,
                          color: Colors.white,
                          margin: const EdgeInsets.all(10),
                        ),
                        Container(height: 20),
                        Container(height: 20),
                      ],
                    ),
                  ),
                ),
              );
            }
            if (value.rangedOrder.isEmpty) {
              return const Center(
                child: Text('''Currently No Order(s) at this Time, '''
                    '''Try Different Time Range'''),
              );
            }
            return ListView.builder(
              itemCount: value.rangedOrder.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var order = value.rangedOrder[index];
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
            );
          },
        )
      ],
    );
  }
}
