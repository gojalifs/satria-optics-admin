import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik_admin/provider/auth_provider.dart';
import 'package:satria_optik_admin/provider/home_provider.dart';
import 'package:satria_optik_admin/provider/order_provider.dart';
import 'package:satria_optik_admin/screen/login/login_screen.dart';

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
              value.index = 0;
              Navigator.of(context).pop();
            },
            leading: Image.asset('assets/icons/store.png'),
            title: const Text('Dashboard'),
          ),
          ListTile(
            onTap: () async {
              value.index = 1;
              Navigator.of(context).pop();
              await Provider.of<OrderProvider>(context, listen: false)
                  .getNewOrder();
            },
            leading: Image.asset('assets/icons/new-order.png'),
            title: const Text('New Order'),
          ),
          ListTile(
            onTap: () {
              value.index = 2;
              Navigator.of(context).pop();
            },
            leading: Image.asset('assets/icons/cashier.png'),
            title: const Text('Cashier'),
          ),
          ListTile(
            onTap: () {
              value.index = 3;
              Navigator.of(context).pop();
            },
            leading: Image.asset('assets/icons/booking.png'),
            title: const Text('Orders'),
          ),
          ListTile(
            onTap: () {
              value.index = 4;
              Navigator.of(context).pop();
            },
            leading: Image.asset('assets/icons/booking.png'),
            title: const Text('Products (Lens, Frames, Acc)'),
          ),
          ListTile(
            onTap: () {
              value.index = 5;
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
                  value.index = 6;
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
              value.index = 7;
              Navigator.of(context).pop();
            },
            leading: Image.asset('assets/icons/worker.png'),
            title: const Text('Data Admin'),
          ),
          const Divider(),
          ListTile(
            onTap: () {
              value.index = 7;
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
