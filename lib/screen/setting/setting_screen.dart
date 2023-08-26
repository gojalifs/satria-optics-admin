import 'package:cherry_toast/cherry_toast.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik_admin/provider/auth_provider.dart';
import 'package:satria_optik_admin/provider/profile_provider.dart';
import 'package:satria_optik_admin/screen/login/login_screen.dart';

class SettingPage extends StatelessWidget {
  static const page = 'setting';
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return EasyRefresh(
      onRefresh: () async {
        try {
          var uid = Provider.of<AuthProvider>(context, listen: false).getUid();
          await Provider.of<ProfileProvider>(context, listen: false)
              .getProfile(uid);
        } catch (e) {
          if (e == "You're Logged Out") {
            Navigator.of(context).pushNamed(LoginPage.route);
          }
        }
      },
      child: ListView(
        children: [
          const Text(
            'Change Your App Data and Profile Here',
            style: TextStyle(fontSize: 20),
          ),
          const Divider(),
          Consumer2<ProfileProvider, AuthProvider>(
            builder: (context, profileProv, authProv, child) => InkWell(
              onTap: () async {
                nameController.text = profileProv.profile!.name!;
                emailController.text = authProv.user!.email!;
                var isEmailUpdated = false;

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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onChanged: (value) {
                              if (value != authProv.user?.email) {
                                isEmailUpdated = true;
                              }
                            },
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
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    try {
                                      if (isEmailUpdated) {
                                        primaryFocus?.unfocus();
                                        Navigator.of(context).pop();

                                        await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text(
                                                'Are You Sure To Change Email'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                    'The email will changed to ${emailController.text}'),
                                                const SizedBox(height: 20),
                                                const Text(
                                                    'Please input your password'),
                                                TextField(
                                                  controller:
                                                      passwordController,
                                                  obscureText: true,
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText: 'Password',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  primaryFocus?.unfocus();
                                                  try {
                                                    var uid = await authProv
                                                        .updateEmail(
                                                      emailController.text
                                                          .trim(),
                                                      passwordController.text,
                                                    );

                                                    await profileProv
                                                        .getProfile(uid);
                                                    if (context.mounted) {
                                                      Navigator.of(context)
                                                          .pop();
                                                      CherryToast.success(
                                                        title: const Text(
                                                            'Success Change Your Email'),
                                                      ).show(context);
                                                    }
                                                  } catch (e) {
                                                    CherryToast.error(
                                                      title: Text('$e'),
                                                    ).show(context);
                                                  }
                                                },
                                                child: const Text('Yes'),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      profileProv.profile =
                                          profileProv.profile!.copyWith(
                                        name: nameController.text,
                                      );
                                      await profileProv.editAdmin();
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
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Name'),
                          Text('${profileProv.profile?.name}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Email'),
                          Text('${authProv.user?.email}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('UID'),
                          Text('${profileProv.profile?.id}'),
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
        ],
      ),
    );
  }
}
