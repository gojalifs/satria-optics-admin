import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BaseProvider extends ChangeNotifier {
  ConnectionState _state = ConnectionState.none;
  User? _user;
  final List<String> _hasNotification = [];
  late StreamSubscription<User?> _authStateSubscription;

  ConnectionState get state => _state;
  List<String> get hasNotification => _hasNotification;
  User? get user => _user;

  set state(ConnectionState state) {
    _state = state;
    notifyListeners();
  }

  set setNotification(String name) {
    hasNotification.add(name);
    notifyListeners();
  }

  BaseProvider() {
    _authStateSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
  }
}
