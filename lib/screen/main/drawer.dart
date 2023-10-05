import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik_admin/provider/auth_provider.dart';
import 'package:satria_optik_admin/provider/home_provider.dart';
import 'package:satria_optik_admin/provider/lens_provider.dart';
import 'package:satria_optik_admin/provider/order_provider.dart';
import 'package:satria_optik_admin/provider/product_provider.dart';
import 'package:satria_optik_admin/provider/profile_provider.dart';
import 'package:satria_optik_admin/screen/admin/admins_screen.dart';
import 'package:satria_optik_admin/screen/chat/chat_list_screen.dart';
import 'package:satria_optik_admin/screen/customer/customers_screen.dart';
import 'package:satria_optik_admin/screen/dashboard/dashboard_screen.dart';
import 'package:satria_optik_admin/screen/login/login_screen.dart';
import 'package:satria_optik_admin/screen/orders/all_order_screen.dart';
import 'package:satria_optik_admin/screen/products/lens_screen.dart';
import 'package:satria_optik_admin/screen/products/products_screen.dart';
import 'package:satria_optik_admin/screen/sales_report/report_monthly_screen.dart';
import 'package:satria_optik_admin/screen/profile/profile_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeProvider, ProfileProvider>(
      builder: (context, home, user, child) => NavigationDrawer(
        children: [
          DrawerHeader(
            child: Center(
              child: Image.asset('assets/images/working.png'),
            ),
          ),
          ListTile(
            onTap: () {
              home.page = DashboardScreen.page;
              Navigator.of(context).pop();
            },
            leading: Image.asset('assets/icons/store.png'),
            title: const Text('Dashboard'),
          ),
          ListTile(
            onTap: () async {
              home.page = 'new-order';
              Navigator.of(context).pop();
              await Provider.of<OrderProvider>(context, listen: false)
                  .getNewOrder('packing');
            },
            leading: Image.asset('assets/icons/new-order.png'),
            title: const Text('New Order'),
          ),
          ListTile(
            onTap: () async {
              home.page = 'on-delivery';
              Navigator.of(context).pop();
              await Provider.of<OrderProvider>(context, listen: false)
                  .getNewOrder('Shipping');
            },
            leading: Image.asset('assets/icons/delivery-truck.png'),
            title: const Text('On delivery'),
          ),
          ListTile(
            onTap: () {
              home.page = AllOrderPage.pageName;
              Navigator.of(context).pop();
            },
            leading: Image.asset('assets/icons/booking.png'),
            title: const Text('Orders'),
          ),
          ListTile(
            onTap: () async {
              home.page = ProductListPage.page;
              Navigator.of(context).pop();
              await Provider.of<ProductProvider>(context, listen: false)
                  .getProducts('products');
            },
            leading: Image.asset('assets/icons/glasses.png'),
            title: const Text('Frames'),
          ),
          ListTile(
            onTap: () async {
              home.page = LensPage.page;
              Navigator.of(context).pop();
              await Provider.of<LensProvider>(context, listen: false)
                  .getLenses();
            },
            leading: Image.asset('assets/icons/lens.png'),
            title: const Text('Lens'),
          ),
          ListTile(
            onTap: () async {
              home.page = CustomersPage.page;
              Navigator.of(context).pop();
              await Provider.of<LensProvider>(context, listen: false)
                  .getLenses();
            },
            leading: Image.asset('assets/icons/worker.png'),
            title: const Text('Users Data'),
          ),
          ListTile(
            onTap: () {
              home.page = ChatPage.page;
              Navigator.of(context).pop();
            },
            leading: Image.asset('assets/icons/demand.png'),
            title: const Text('Chats'),
          ),
          (user.profile?.isOwner != null && user.profile!.isOwner!)
              ? ListTile(
                  onTap: () {
                    home.page = MonthlyReportPage.page;
                    Navigator.of(context).pop();
                  },
                  leading: Image.asset('assets/icons/sales.png'),
                  title: const Text('Sales Report'),
                )
              : const SizedBox(),
          (user.profile?.isOwner != null && user.profile!.isOwner!)
              ? ListTile(
                  onTap: () {
                    home.page = AdminScreen.page;
                    Navigator.of(context).pop();
                  },
                  leading: Image.asset('assets/icons/worker.png'),
                  title: const Text('Data Admin'),
                )
              : const SizedBox(),
          const Divider(),
          ListTile(
            onTap: () {
              home.page = SettingPage.page;
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
