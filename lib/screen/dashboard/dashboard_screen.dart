import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik_admin/provider/home_provider.dart';
import 'package:satria_optik_admin/provider/auth_provider.dart';
import 'package:satria_optik_admin/provider/order_provider.dart';

class DashboardScreen extends StatelessWidget {
  static String page = 'dashboard';
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        greetingCard(),
        newOrdersCard(),
        summaryCard(),
        stockControllCard(),
      ],
    );
  }

  Card greetingCard() {
    return Card(
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            Expanded(
              child: Container(
                color: Colors.amber,
                child: const SizedBox(),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Good Night',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Consumer<AuthProvider>(
                    builder: (context, value, child) {
                      return const Text(
                        'Fajar',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                alignment: Alignment.centerRight,
                child: Consumer<AuthProvider>(
                  builder: (context, value, child) {
                    if (value.user == null || value.user?.photoURL == null) {
                      return const Icon(
                        Icons.person,
                        size: 50,
                      );
                    }
                    return CircleAvatar(
                      maxRadius: 50,
                      foregroundImage: AssetImage(
                        value.user!.photoURL!,
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.yellow,
                child: const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card newOrdersCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            const Text(
              'Today Order(s)',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            const Divider(),
            Consumer2<HomeProvider, OrderProvider>(
              builder: (context, home, order, child) => ListView.separated(
                itemCount: order.orders.length <= 3 ? order.orders.length : 3,
                shrinkWrap: true,
                primary: false,
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        order.orders[index].cartProduct?[0].product.name ?? ''),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(order.orders[index].address?.receiverName ?? ''),
                        Text(
                          '${order.orders[index].total}',
                          style: const TextStyle(
                            color: Color.fromRGBO(251, 18, 16, 1),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Consumer<OrderProvider>(
              builder: (context, value, child) {
                if (value.orders.length > 3) {
                  return TextButton(
                    onPressed: () {},
                    child: const Text('Show More . . .'),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Card stockControllCard() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              'Stock Controll',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            Divider(),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Rayaban'),
                  Text('5'),
                ],
              ),
            ),
            ListTile(
              title: Text('Other product has more than 10 pcs'),
            )
          ],
        ),
      ),
    );
  }

  Card summaryCard() {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: const Column(
          children: [
            Text(
              'Today Summary',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            Divider(),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Amount Sold'),
                  Text('5'),
                ],
              ),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Turnover'),
                  Text('Rp2.300.000'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
