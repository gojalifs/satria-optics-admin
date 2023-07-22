import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik_admin/provider/home_provider.dart';
import 'package:satria_optik_admin/screen/dashboard/dashboard_screen.dart';
import 'package:satria_optik_admin/screen/main/custom_appbar.dart';
import 'package:satria_optik_admin/screen/main/drawer.dart';

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
              switch (value.index) {
                case 0:
                  return const DashboardScreen();

                default:
                  return const Text('Something Error');
              }
            },
          ),
        ),
      ),
    );
  }
}
