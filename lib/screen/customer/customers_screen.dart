import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik_admin/provider/customer_provider.dart';

class CustomersPage extends StatelessWidget {
  static const String page = '/customer';
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      onRefresh: () async {
        await Provider.of<CustomerProvider>(context, listen: false)
            .getCustomers();
      },
      triggerAxis: Axis.vertical,
      child: ListView(
        children: [
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.search),
              suffixIconColor: Colors.grey,
              hintText: 'Find Customer',
            ),
            onTapOutside: (event) {
              primaryFocus?.unfocus();
            },
            onChanged: (value) {
              Provider.of<CustomerProvider>(context, listen: false).find(value);
            },
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Consumer<CustomerProvider>(
              builder: (context, custs, child) => DataTable(
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Username')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Phone')),
                ],
                rows: custs.filteredCustomers
                    .map(
                      (e) => DataRow(
                        cells: [
                          DataCell(Text('${e.id}')),
                          DataCell(Text('${e.username}')),
                          DataCell(Text('${e.email}')),
                          DataCell(Text('${e.phone}')),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
