import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BaseProvider extends ChangeNotifier {
  ConnectionState _state = ConnectionState.none;
  User? _user;
  final List<String> _hasNotification = [];

  ConnectionState get state => _state;
  List<String> get hasNotification => _hasNotification;
  User? get user => _user;

  set state(ConnectionState state) {
    _state = state;
  }

  set setNotification(String name) {
    hasNotification.add(name);
    notifyListeners();
  }

  set user(User? user) {
    _user = user;
    notifyListeners();
  }
}
