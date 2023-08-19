import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik_admin/provider/admins_provider.dart';

class AdminScreen extends StatelessWidget {
  static const String page = '/admins';

  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      onRefresh: () async {
        await Provider.of<AdminProvider>(context, listen: false).getAdmins();
      },
      refreshOnStart:
          Provider.of<AdminProvider>(context, listen: false).admins.isEmpty
              ? true
              : false,
      child: Consumer<AdminProvider>(
        builder: (context, value, child) => ListView.builder(
          itemCount: value.admins.length,
          itemBuilder: (BuildContext context, int index) {
            var admin = value.admins[index];
            return Card(
              color: admin.isBanned!
                  ? Colors.white60
                  : Theme.of(context).cardColor,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    const Icon(Icons.person_rounded),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            admin.name!,
                            style: const TextStyle(
                              fontSize: 22,
                            ),
                          ),
                          Text(
                            admin.id!,
                            style: const TextStyle(color: Colors.black54),
                          ),
                          Text(
                            admin.email!,
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        value.admin = admin;
                        await value.setStatus();
                      },
                      child: admin.isBanned!
                          ? const Text('Activate')
                          : const Text('Deactivate'),
                    ),
                    IconButton(
                      onPressed: (admin.isBanned! || value.admins.length <= 1)
                          ? null
                          : () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text(
                                      'Are You Sure To Delete This Admin?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        value.admin = admin;
                                        await value.deleteAdmin();
                                        if (context.mounted) {
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      child: const Text('Yes, Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                      icon: const Icon(Icons.delete_forever_rounded),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
