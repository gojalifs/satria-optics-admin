import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik_admin/custom/custom_theme.dart';
import 'package:satria_optik_admin/provider/base_provider.dart';
import 'package:satria_optik_admin/provider/home_provider.dart';
import 'package:satria_optik_admin/provider/order_provider.dart';
import 'package:satria_optik_admin/provider/product_provider.dart';
import 'package:satria_optik_admin/screen/main/main_screen.dart';
import 'package:satria_optik_admin/screen/orders/order_detail_page.dart';
import 'package:satria_optik_admin/screen/products/add_frame_stock_screen.dart';
import 'package:satria_optik_admin/screen/products/product_detail_screen.dart';

import 'firebase_options.dart';
import 'provider/auth_provider.dart';
import 'screen/login/login_screen.dart';
import 'screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BaseProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: CustomTheme().customTheme,
        home: const CustomSplashPage(),
        routes: {
          CustomSplashPage.route: (context) => const CustomSplashPage(),
          LoginPage.route: (context) => const LoginPage(),
          MainPage.route: (context) => const MainPage(),
          OrderDetailPage.route: (context) => const OrderDetailPage(),
          ProductDetailPage.route: (context) => const ProductDetailPage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == AddFrameStockPage.route) {
            var args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => AddFrameStockPage(colorData: args),
            );
          }
          assert(false, 'Need to implement ${settings.name} on routes');
          return null;
        },
      ),
    );
  }
}
