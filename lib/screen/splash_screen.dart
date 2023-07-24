import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik_admin/provider/auth_provider.dart';
import 'package:satria_optik_admin/provider/order_provider.dart';
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
      await Provider.of<OrderProvider>(context, listen: false).getNewOrder();
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushReplacementNamed(MainPage.route);
    } else {
      Navigator.of(context).pushReplacementNamed(LoginPage.route);
    }
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
