import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik_admin/provider/home_provider.dart';
import 'package:satria_optik_admin/screen/admin/admins_screen.dart';
import 'package:satria_optik_admin/screen/dashboard/dashboard_screen.dart';
import 'package:satria_optik_admin/screen/main/custom_appbar.dart';
import 'package:satria_optik_admin/screen/main/drawer.dart';
import 'package:satria_optik_admin/screen/orders/all_order_screen.dart';
import 'package:satria_optik_admin/screen/orders/new_order_screen.dart';
import 'package:satria_optik_admin/screen/products/lens_screen.dart';
import 'package:satria_optik_admin/screen/products/products_screen.dart';

class MainPage extends StatelessWidget {
  static String route = '/home';

  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const SearchAppBar(),
      drawer: const CustomDrawer(),
      floatingActionButton: makeFAB(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Consumer<HomeProvider>(
            builder: (context, value, child) {
              switch (value.page) {
                case DashboardScreen.page:
                  return const DashboardScreen();
                case 'new-order':
                  return const NewOrderPage(orderStatus: 'packing');
                case 'on-delivery':
                  return const NewOrderPage(orderStatus: 'Shipping');
                case AllOrderPage.pageName:
                  return const AllOrderPage();
                case 'products':
                  return const ProductListPage();
                case 'lens':
                  return const LensPage();
                case AdminScreen.page:
                  return const AdminScreen();
                default:
                  return const Text('Something Error');
              }
              // Default screen
            },
          ),
        ),
      ),
    );
  }

  FloatingActionButton? makeFAB(BuildContext context) {
    var page = Provider.of<HomeProvider>(context).page;
    if (page == ProductListPage.page || page == LensPage.page) {
      return FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add_rounded),
      );
    } else {
      return null;
    }
  }
}
