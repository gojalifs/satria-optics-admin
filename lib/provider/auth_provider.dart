import 'package:flutter/material.dart';
import 'package:satria_optik_admin/helper/auth_helper.dart';
import 'package:satria_optik_admin/provider/base_provider.dart';

class AuthProvider extends BaseProvider {
  bool _hasNotification = false;
  final _authHelper = AuthHelper();

  bool get hasNotif => _hasNotification;

  Future<bool> checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();

    if (user != null) {
      return true;
    }
    return false;
  }

  set hasNotif(bool hasNotif) {
    _hasNotification = hasNotif;
    super.hasNotification.add('auth');
    notifyListeners();
  }

  Future login(String email, String password) async {
    state = ConnectionState.active;
    try {
      await _authHelper.login(email, password);
    } catch (e) {
      rethrow;
    } finally {
      state = ConnectionState.none;
      notifyListeners();
    }
  }

  Future logout() async {
    try {
      await _authHelper.logout();
    } catch (e) {
      throw 'Error logging you out :(';
    }
  }
}
