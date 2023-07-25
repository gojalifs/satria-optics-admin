import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik_admin/provider/home_provider.dart';
import 'package:satria_optik_admin/screen/dashboard/dashboard_screen.dart';
import 'package:satria_optik_admin/screen/main/custom_appbar.dart';
import 'package:satria_optik_admin/screen/main/drawer.dart';
import 'package:satria_optik_admin/screen/new_order/new_order_screen.dart';

class MainPage extends StatelessWidget {
  static String route = '/home';

  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const SearchAppBar(),
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Consumer<HomeProvider>(
            builder: (context, value, child) {
              if (value.page == DashboardScreen.page) {
                return const DashboardScreen();
              }
              if (value.page == 'new-order') {
                return const NewOrderPage(orderStatus: 'packing');
              }
              if (value.page == 'on-delivery') {
                return const NewOrderPage(orderStatus: 'Shipping');
              }
              // Default screen
              return const Text('Something Error');
            },
          ),
        ),
      ),
    );
  }
}
