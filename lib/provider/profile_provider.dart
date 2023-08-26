import 'package:flutter/material.dart';
import 'package:satria_optik_admin/helper/profile_helper.dart';
import 'package:satria_optik_admin/model/admins.dart';
import 'package:satria_optik_admin/provider/base_provider.dart';

class ProfileProvider extends BaseProvider {
  final _helper = ProfileHelper();
  Admin? _profile;

  Admin? get profile => _profile;

  set profile(Admin? profile) {
    _profile = profile;
    notifyListeners();
  }

  Future getProfile(String uid) async {
    try {
      _profile = await _helper.getAdminData(uid);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future editAdmin() async {
    state = ConnectionState.active;
    try {
      await _helper.editAdmin(_profile!);
    } catch (e) {
      rethrow;
    } finally {
      state = ConnectionState.done;
      notifyListeners();
    }
  }
}
