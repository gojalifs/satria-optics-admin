import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik_admin/provider/auth_provider.dart';
import 'package:satria_optik_admin/screen/dashboard/dashboard_screen.dart';

class LoginPage extends StatelessWidget {
  static String route = '/login';
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    TextEditingController emailController = TextEditingController();
    TextEditingController passController = TextEditingController();

    return GestureDetector(
      onTap: () {
        primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Center(
            child: AutofillGroup(
              child: Form(
                key: formKey,
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  children: [
                    Image.asset('assets/images/working.png'),
                    const Center(
                      child: Text('Welcome, Admin!',
                          style: TextStyle(fontSize: 30)),
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      autofillHints: const [AutofillHints.email],
                      controller: emailController,
                      decoration: const InputDecoration(
                        label: Text('E-mail'),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please input email';
                        }
                        if (!value.contains('@')) {
                          return 'Please input valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      autofillHints: const [AutofillHints.password],
                      controller: passController,
                      decoration: const InputDecoration(
                        label: Text('Password'),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please input password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Consumer<AuthProvider>(
                      builder: (context, value, child) {
                        if (value.state == ConnectionState.active) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }
                        return ElevatedButton(
                          onPressed: () async {
                            try {
                              if (formKey.currentState != null &&
                                  formKey.currentState!.validate()) {
                                await value.login(emailController.text.trim(),
                                    passController.text.trim());
                                if (context.mounted) {
                                  CherryToast.success(
                                    title: const Text(
                                      'Login Success, redirecting You . . .',
                                    ),
                                    toastPosition: Position.bottom,
                                  ).show(context);
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      HomePage.route, (route) => false);
                                }
                              }
                            } catch (e) {
                              CherryToast.error(title: Text('$e'))
                                  .show(context);
                            }
                          },
                          child: const Text('LOGIN'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
