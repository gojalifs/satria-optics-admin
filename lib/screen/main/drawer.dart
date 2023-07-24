import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik_admin/provider/auth_provider.dart';
import 'package:satria_optik_admin/provider/home_provider.dart';
import 'package:satria_optik_admin/provider/order_provider.dart';
import 'package:satria_optik_admin/screen/dashboard/dashboard_screen.dart';
import 'package:satria_optik_admin/screen/login/login_screen.dart';
import 'package:satria_optik_admin/screen/new_order/new_order_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, value, child) => NavigationDrawer(
        children: [
          DrawerHeader(
            child: Center(
              child: Image.asset('assets/images/working.png'),
            ),
          ),
          ListTile(
            onTap: () {
              value.page = DashboardScreen.page;
              Navigator.of(context).pop();
            },
            leading: Image.asset('assets/icons/store.png'),
            title: const Text('Dashboard'),
          ),
          ListTile(
            onTap: () async {
              value.page = NewOrderPage.page;
              Navigator.of(context).pop();
              await Provider.of<OrderProvider>(context, listen: false)
                  .getNewOrder();
            },
            leading: Image.asset('assets/icons/new-order.png'),
            title: const Text('New Order'),
          ),
          ListTile(
            onTap: () {
              value.page = 'on-delivery';
              Navigator.of(context).pop();
            },
            leading: Image.asset('assets/icons/delivery-truck.png'),
            title: const Text('On delivery'),
          ),
          ListTile(
            onTap: () {
              value.page = 'ccashier';
              Navigator.of(context).pop();
            },
            leading: Image.asset('assets/icons/cashier.png'),
            title: const Text('Cashier'),
          ),
          ListTile(
            onTap: () {
              value.page = 'order-history';
              Navigator.of(context).pop();
            },
            leading: Image.asset('assets/icons/booking.png'),
            title: const Text('Orders'),
          ),
          ListTile(
            onTap: () {
              value.page = 'product';
              Navigator.of(context).pop();
            },
            leading: Image.asset('assets/icons/booking.png'),
            title: const Text('Products (Lens, Frames, Acc)'),
          ),
          ListTile(
            onTap: () {
              value.page = 'chat';
              Navigator.of(context).pop();
            },
            leading: Image.asset('assets/icons/demand.png'),
            title: const Text('Chats'),
          ),

          /// TODO jika bukan owner, maka hilangkan
          Consumer<HomeProvider>(
            builder: (context, value, child) {
              return ListTile(
                onTap: () {
                  value.page = 'report';
                  Navigator.of(context).pop();
                },
                leading: Image.asset('assets/icons/sales.png'),
                title: const Text('Sales Report'),
              );
            },
          ),

          /// TODO Data Admin, muncul di owner
          ListTile(
            onTap: () {
              value.page = 'admins';
              Navigator.of(context).pop();
            },
            leading: Image.asset('assets/icons/worker.png'),
            title: const Text('Data Admin'),
          ),
          const Divider(),
          ListTile(
            onTap: () {
              value.page = 'setting';
              Navigator.of(context).pop();
            },
            leading: Image.asset('assets/icons/setting.png'),
            title: const Text('Setting'),
          ),
          const Divider(),
          Consumer<AuthProvider>(
            builder: (context, value, child) => ListTile(
              onTap: () async {
                await value.logout();
                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    LoginPage.route,
                    (route) => false,
                  );
                }
              },
              leading: Image.asset('assets/icons/demand.png'),
              title: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }
}
