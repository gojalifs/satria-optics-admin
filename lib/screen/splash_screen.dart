import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik_admin/provider/auth_provider.dart';
import 'package:satria_optik_admin/provider/order_provider.dart';
import 'package:satria_optik_admin/provider/profile_provider.dart';
import 'package:satria_optik_admin/provider/report_provider.dart';
import 'package:satria_optik_admin/screen/login/login_screen.dart';
import 'package:satria_optik_admin/screen/main/main_screen.dart';

class CustomSplashPage extends StatefulWidget {
  static String route = '/splash';
  const CustomSplashPage({super.key});

  @override
  State<CustomSplashPage> createState() => _CustomSplashPageState();
}

class _CustomSplashPageState extends State<CustomSplashPage> {
  checkLoginStatus() async {
    var status = await Provider.of<AuthProvider>(context, listen: false)
        .checkLoginStatus();
    if (!mounted) {
      return;
    }
    if (status) {
      if (context.mounted) {
        var uid = Provider.of<AuthProvider>(context, listen: false).getUid();
        await Provider.of<ProfileProvider>(context, listen: false)
            .getProfile(uid);
        await getReport();
        await getNewOrder();
        if (context.mounted) {
          Navigator.of(context).pushReplacementNamed(MainPage.route);
        }
      }
    } else {
      Navigator.of(context).pushReplacementNamed(LoginPage.route);
    }
  }

  Future getReport() async {
    var date = DateTime.now();
    Provider.of<ReportProvider>(context, listen: false).setMonth =
        DateTime(date.year, date.month, date.day);
    await Provider.of<ReportProvider>(context, listen: false).getReport();
  }

  Future getNewOrder() async {
    var value = Provider.of<OrderProvider>(context, listen: false);
    value.hasNewOrder = true;
    await value.getNewOrder('packing');
  }

  @override
  void initState() {
    checkLoginStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: 250),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                child: CircularProgressIndicator.adaptive(),
              ),
              SizedBox(height: 10),
              Text('Please Wait'),
            ],
          ),
        ),
      ),
    );
  }
}
