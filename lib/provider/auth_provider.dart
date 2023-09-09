import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:satria_optik_admin/helper/auth_helper.dart';
import 'package:satria_optik_admin/provider/base_provider.dart';

class AuthProvider extends BaseProvider {
  bool _hasNotification = false;
  final _authHelper = AuthHelper();
  late StreamSubscription<User?> _authStateSubscription;

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

  AuthProvider() {
    _authStateSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) {
      super.user = user;
      notifyListeners();
    });
  }

  String getUid() {
    try {
      if (user?.uid != null) {
        return user!.uid;
      } else {
        throw "You're Logged Out";
      }
    } catch (e) {
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<String> updateEmail(String email, String password) async {
    state = ConnectionState.active;
    try {
      await _authHelper.changeEmail(user!, user!.email!, email, password);

      FirebaseAuth.instance.authStateChanges().listen((user) {
        super.user = user;
      });
      notifyListeners();
      return user!.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw 'Wrong Password';
      }
      throw 'You Entered Wrong Password';
    } catch (e) {
      throw 'error while updating your email';
    } finally {
      state = ConnectionState.done;
    }
  }

  Future<String> login(String email, String password) async {
    state = ConnectionState.active;
    try {
      var userCredential = await _authHelper.login(email, password);
      return userCredential.user!.uid;
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

  @override
  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
  }
}
