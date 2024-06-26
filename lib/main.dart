import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';

import 'package:satria_optik_admin/custom/custom_theme.dart';
import 'package:satria_optik_admin/firebase_options.dart';
import 'package:satria_optik_admin/provider/admins_provider.dart';
import 'package:satria_optik_admin/provider/auth_provider.dart';
import 'package:satria_optik_admin/provider/base_provider.dart';
import 'package:satria_optik_admin/provider/chat_provider.dart';
import 'package:satria_optik_admin/provider/customer_provider.dart';
import 'package:satria_optik_admin/provider/home_provider.dart';
import 'package:satria_optik_admin/provider/lens_provider.dart';
import 'package:satria_optik_admin/provider/order_provider.dart';
import 'package:satria_optik_admin/provider/product_provider.dart';
import 'package:satria_optik_admin/provider/profile_provider.dart';
import 'package:satria_optik_admin/provider/report_provider.dart';
import 'package:satria_optik_admin/screen/chat/chat_data_screen.dart';
import 'package:satria_optik_admin/screen/login/login_screen.dart';
import 'package:satria_optik_admin/screen/main/main_screen.dart';
import 'package:satria_optik_admin/screen/orders/order_detail_page.dart';
import 'package:satria_optik_admin/screen/products/add_frame_stock_screen.dart';
import 'package:satria_optik_admin/screen/products/lens_detail_screen.dart';
import 'package:satria_optik_admin/screen/products/product_detail_screen.dart';
import 'package:satria_optik_admin/screen/sales_report/report_monthly_screen.dart';
import 'package:satria_optik_admin/screen/splash_screen.dart';

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
        ChangeNotifierProvider(create: (context) => LensProvider()),
        ChangeNotifierProvider(create: (context) => ReportProvider()),
        ChangeNotifierProvider(create: (context) => AdminProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => CustomerProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
      ],
      child: MaterialApp(
        title: 'Optik Satria Jaya - Admin',
        theme: CustomTheme().customTheme,
        home: const CustomSplashPage(),
        localizationsDelegates: const [MonthYearPickerLocalizations.delegate],
        routes: {
          CustomSplashPage.route: (context) => const CustomSplashPage(),
          LoginPage.route: (context) => const LoginPage(),
          MainPage.route: (context) => const MainPage(),
          OrderDetailPage.route: (context) => const OrderDetailPage(),
          MonthlyReportPage.page: (context) => const MonthlyReportPage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == AddFrameStockPage.route) {
            var args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => AddFrameStockPage(colorData: args),
            );
          } else if (settings.name == ChatDataPage.page) {
            var args = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => ChatDataPage(userId: args),
            );
          } else if (settings.name == ProductDetailPage.route) {
            var args = settings.arguments as bool;
            return MaterialPageRoute(
              builder: (context) => ProductDetailPage(isAdd: args),
            );
          } else if (settings.name == LensDetailPage.route) {
            var args = settings.arguments as bool;
            return MaterialPageRoute(
              builder: (context) => LensDetailPage(isAdd: args),
            );
          }
          assert(false, 'Need to implement ${settings.name} on routes');
          return null;
        },
      ),
    );
  }
}
