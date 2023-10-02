import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik_admin/custom/common_function.dart';
import 'package:satria_optik_admin/provider/home_provider.dart';
import 'package:satria_optik_admin/provider/auth_provider.dart';
import 'package:satria_optik_admin/provider/order_provider.dart';
import 'package:satria_optik_admin/provider/profile_provider.dart';
import 'package:satria_optik_admin/screen/main/chart_card.dart';
import 'package:satria_optik_admin/screen/orders/new_order_screen.dart';
import 'package:satria_optik_admin/screen/profile/profile_screen.dart';

class DashboardScreen extends StatelessWidget {
  static const String page = 'dashboard';
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        InkWell(
          onTap: () {
            Provider.of<HomeProvider>(context, listen: false).page =
                SettingPage.page;
          },
          child: greetingCard(),
        ),
        InkWell(
          onTap: () {
            Provider.of<HomeProvider>(context, listen: false).page =
                NewOrderPage.page;
          },
          child: newOrdersCard(),
        ),
        InkWell(
          onTap: () async {
            await Provider.of<OrderProvider>(context, listen: false)
                .getTodaySummary();
          },
          child: const SummaryCard(),
        ),
        reportCard(context),
      ],
    );
  }

  reportCard(BuildContext context) {
    return const Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'This Month Report',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 20),
          ChartSample(),
        ],
      ),
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
                    'Hello',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Consumer<ProfileProvider>(
                    builder: (context, value, child) {
                      return Text(
                        '${value.profile?.name}',
                        style: const TextStyle(
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
              'New Order(s)',
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
                  var orderData = order.orders[index];
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            order.orders[index].cartProduct?[0].product.name ??
                                '',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '#${orderData.id}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(order.orders[index].address?.receiverName ?? ''),
                        Text(
                          formatToRupiah('${order.orders[index].total}'),
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

/* 
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
 */
}

class SummaryCard extends StatefulWidget {
  const SummaryCard({
    super.key,
  });

  @override
  State<SummaryCard> createState() => _SummaryCardState();
}

class _SummaryCardState extends State<SummaryCard> {
  @override
  void initState() {
    Provider.of<OrderProvider>(context, listen: false).getTodaySummary();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Consumer<OrderProvider>(
          builder: (context, value, child) => Column(
            children: [
              const Text(
                'Today Summary',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              const Divider(),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Amount Sold'),
                    Text('${value.summary?.count}'),
                  ],
                ),
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Turnover'),
                    Text(value.summary?.total ?? ''),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
