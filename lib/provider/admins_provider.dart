import 'package:flutter/material.dart';
import 'package:satria_optik_admin/helper/admins_helper.dart';
import 'package:satria_optik_admin/model/admins.dart';
import 'package:satria_optik_admin/provider/base_provider.dart';

class AdminProvider extends BaseProvider {
  final _helper = AdminHelper();
  List<Admin> _admins = [];
  Admin? _admin;

  List<Admin> get admins => _admins;
  Admin? get admin => _admin;

  set admin(Admin? admin) {
    _admin = admin;
    notifyListeners();
  }

  Future getAdmins() async {
    try {
      state = ConnectionState.active;
      _admins = await _helper.getAdmins();
    } catch (e) {
      rethrow;
    } finally {
      state = ConnectionState.done;
      notifyListeners();
    }
  }

  Future setStatus() async {
    try {
      state = ConnectionState.active;
      _admin?.isBanned = !_admin!.isBanned!;
      await _helper.setStatus(_admin!);
    } catch (e) {
      rethrow;
    } finally {
      state = ConnectionState.done;
      notifyListeners();
    }
  }
}
