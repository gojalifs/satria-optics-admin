import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik_admin/provider/profile_provider.dart';

class SettingPage extends StatelessWidget {
  static const page = 'setting';
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return ListView(
      children: [
        const Text(
          'Change Your App Data and Profile Here',
          style: TextStyle(fontSize: 20),
        ),
        const Divider(),
        Consumer<ProfileProvider>(
          builder: (context, value, child) => InkWell(
            onTap: () async {
              nameController.text = value.profile!.name!;
              emailController.text = value.profile!.email!;

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
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Edit Profile',
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

                        /// TODO behaviour of change email need verification from auth
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel')),
                            Consumer<ProfileProvider>(
                              builder: (context, value, child) => TextButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    try {
                                      value.profile = value.profile!.copyWith(
                                        name: nameController.text,
                                        email: emailController.text,
                                      );
                                      await value.editAdmin();
                                      if (context.mounted) {
                                        Navigator.of(context).pop();
                                        CherryToast.success(
                                          title: const Text(
                                              'Edit Profile Success'),
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
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Consumer<ProfileProvider>(
                  builder: (context, value, child) => Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Name'),
                          Text('${value.profile?.name}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Email'),
                          Text('${value.profile?.email}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('UID'),
                          Text('${value.profile?.id}'),
                        ],
                      ),
                      const Text(
                        'Tap To Edit',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
