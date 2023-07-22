import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik_admin/provider/home_provider.dart';
import 'package:satria_optik_admin/screen/home/custom_appbar.dart';
import 'package:satria_optik_admin/provider/auth_provider.dart';
import 'package:satria_optik_admin/screen/home/drawer.dart';

class HomePage extends StatelessWidget {
  static String route = '/home';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    int count = 5;

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
                  return ListView(
                    children: [
                      greetingCard(),
                      newOrdersCard(count),
                      const DailySummary(),
                      // Text(
                      //     '''Dashboard tampilkan orderan baru, jumlah orderan hari ini, '''
                      //     '''jumlah omzet hari ini, tampilkan stok yang menipis'''),
                    ],
                  );

                default:
                  return const Text('Something Error');
              }
            },
          ),
        ),
      ),
    );
  }

  Card newOrdersCard(int count) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            const Text(
              'Today Order(s)',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            ListView.separated(
              itemCount: 3,
              shrinkWrap: true,
              primary: false,
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemBuilder: (context, index) {
                return const ListTile(
                  title: Text('Nama Kacamata'),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Nama Penerima'),
                      Text(
                        'Rp500.000',
                        style: TextStyle(
                          color: Color.fromRGBO(251, 18, 16, 1),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            count > 3
                ? TextButton(
                    onPressed: () {},
                    child: const Text('Show More . . .'),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Card newOrderCard() {
    int count = 5;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            const Text(
              'Today Order(s)',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            ListView.separated(
              itemCount: 3,
              shrinkWrap: true,
              primary: false,
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemBuilder: (context, index) {
                return const ListTile(
                  title: Text('Nama Kacamata'),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Nama Penerima'),
                      Text(
                        'Rp500.000',
                        style: TextStyle(
                          color: Color.fromRGBO(251, 18, 16, 1),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            count > 3
                ? Consumer<HomeProvider>(
                    builder: (context, value, child) => TextButton(
                      onPressed: () {
                        value.hasNotification.add('home');
                        print(value.hasNotification);
                      },
                      child: const Text('Show More . . .'),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Card greetingCard() {
    return Card(
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            Expanded(
              child: Container(
                color: Colors.amber,
                child: const SizedBox(),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Good Night',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Consumer<AuthProvider>(
                    builder: (context, value, child) {
                      return const Text(
                        'Fajar',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                alignment: Alignment.centerRight,
                child: Consumer<AuthProvider>(
                  builder: (context, value, child) {
                    if (value.user == null || value.user?.photoURL == null) {
                      return const Icon(
                        Icons.person,
                        size: 50,
                      );
                    }
                    return CircleAvatar(
                      maxRadius: 50,
                      foregroundImage: AssetImage(
                        value.user!.photoURL!,
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.yellow,
                child: const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DailySummary extends StatelessWidget {
  const DailySummary({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: const Column(
          children: [
            Text(
              'Today Summary',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Amount Sold'),
                  Text('5'),
                ],
              ),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Turnover'),
                  Text('Rp2.300.000'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
