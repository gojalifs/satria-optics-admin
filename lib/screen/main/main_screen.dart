import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik_admin/model/admins.dart';
import 'package:satria_optik_admin/model/glass_frame.dart';
import 'package:satria_optik_admin/model/lens.dart';
import 'package:satria_optik_admin/provider/admins_provider.dart';
import 'package:satria_optik_admin/provider/home_provider.dart';
import 'package:satria_optik_admin/provider/lens_provider.dart';
import 'package:satria_optik_admin/provider/product_provider.dart';
import 'package:satria_optik_admin/screen/admin/admins_screen.dart';
import 'package:satria_optik_admin/screen/chat/chat_list_screen.dart';
import 'package:satria_optik_admin/screen/customer/customers_screen.dart';
import 'package:satria_optik_admin/screen/dashboard/dashboard_screen.dart';
import 'package:satria_optik_admin/screen/main/drawer.dart';
import 'package:satria_optik_admin/screen/orders/all_order_screen.dart';
import 'package:satria_optik_admin/screen/orders/new_order_screen.dart';
import 'package:satria_optik_admin/screen/products/lens_detail_screen.dart';
import 'package:satria_optik_admin/screen/products/lens_screen.dart';
import 'package:satria_optik_admin/screen/products/product_detail_screen.dart';
import 'package:satria_optik_admin/screen/products/products_screen.dart';
import 'package:satria_optik_admin/screen/sales_report/report_monthly_screen.dart';
import 'package:satria_optik_admin/screen/profile/profile_screen.dart';

class MainPage extends StatelessWidget {
  static String route = '/home';

  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _key = GlobalKey<ScaffoldState>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Optik Satria Jaya'),
      ),
      drawer: const CustomDrawer(),
      floatingActionButton: makeFAB(context),
      body: Consumer<HomeProvider>(
        builder: (context, value, child) => WillPopScope(
          onWillPop: () {
            bool isDrawerOpen = _key.currentState?.isDrawerOpen ?? false;
            print(isDrawerOpen);
            if (isDrawerOpen) {
              Navigator.of(context).pop();
              return Future.value(false);
            }
            if (value.page != DashboardScreen.page) {
              value.page = DashboardScreen.page;
              return Future.value(false);
            }
            return Future.value(true);
          },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Builder(
              builder: (context) {
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
                  case CustomersPage.page:
                    return const CustomersPage();
                  case ChatPage.page:
                    return const ChatPage();
                  case AdminScreen.page:
                    return const AdminScreen();
                  case MonthlyReportPage.page:
                    return const MonthlyReportPage();
                  case SettingPage.page:
                    return const SettingPage();
                  default:
                    return const Text('Something Error');
                }
                // Default screen
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget? makeFAB(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    final key = GlobalKey<FormState>();

    var page = Provider.of<HomeProvider>(context).page;
    if (page == ProductListPage.page || page == LensPage.page) {
      return Consumer2<ProductProvider, LensProvider>(
        builder: (context, productProv, lensProv, child) =>
            FloatingActionButton(
          onPressed: () {
            if (page == ProductListPage.page) {
              productProv.frame = GlassFrame();
              Navigator.of(context).pushNamed(
                ProductDetailPage.route,
                arguments: true,
              );
            } else {
              lensProv.lens = Lens();
              Navigator.of(context).pushNamed(
                LensDetailPage.route,
                arguments: true,
              );
            }
          },
          child: const Icon(Icons.add_rounded),
        ),
      );
    } else if (page == AdminScreen.page) {
      return FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => Padding(
              padding: EdgeInsets.only(
                top: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                left: 20,
                right: 20,
              ),
              child: Form(
                key: key,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Add Data',
                      style: TextStyle(fontSize: 24),
                    ),
                    TextFormField(
                      controller: nameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This Field is Mandatory';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        label: Text('Name'),
                      ),
                    ),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This Field is Mandatory';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        label: Text('email'),
                      ),
                    ),
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This Field is Mandatory';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        label: Text('Password'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel')),
                        Consumer<AdminProvider>(
                          builder: (context, value, child) => TextButton(
                            onPressed: () async {
                              if (key.currentState!.validate()) {
                                try {
                                  value.admin = Admin(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                  await value.addAdmin();
                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                    CherryToast.success(
                                      title: const Text('New Admin Added'),
                                    ).show(context);
                                  }
                                } catch (e) {
                                  CherryToast.error(title: Text('$e'))
                                      .show(context);
                                }
                              }
                            },
                            child: const Text('Save'),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
        child: const Icon(Icons.add_rounded),
      );
    } else {
      return null;
    }
  }
}
