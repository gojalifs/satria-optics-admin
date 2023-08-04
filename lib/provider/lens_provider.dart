import 'package:flutter/material.dart';
import 'package:satria_optik_admin/helper/lens_helper.dart';
import 'package:satria_optik_admin/model/lens.dart';
import 'package:satria_optik_admin/provider/base_provider.dart';

class LensProvider extends BaseProvider {
  final _helper = LensHelper();
  List<Lens>? _lenses = [];
  Lens _lens = Lens();

  List<Lens>? get lenses => _lenses;
  Lens get lens => _lens;

  set lens(Lens lens) {
    _lens = lens;
    notifyListeners();
  }

  Future getLenses() async {
    state = ConnectionState.active;
    try {
      _lenses = await _helper.getLenses();
    } catch (e) {
      rethrow;
    } finally {
      state = ConnectionState.done;
      notifyListeners();
    }
  }
}
