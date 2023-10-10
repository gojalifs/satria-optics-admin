import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:satria_optik_admin/helper/lens_helper.dart';
import 'package:satria_optik_admin/model/lens.dart';
import 'package:satria_optik_admin/provider/base_provider.dart';

class LensProvider extends BaseProvider {
  final _helper = LensHelper();
  final ImagePicker _picker = ImagePicker();

  List<Lens> _lenses = [];
  Lens _lens = Lens();
  XFile? _image;

  List<Lens> get lenses => _lenses;
  Lens get lens => _lens;
  XFile? get image => _image;

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

  Future addLens() async {
    state = ConnectionState.active;
    notifyListeners();
    try {
      await _helper.addLens(lens);
      lenses.add(lens);
    } catch (e) {
      rethrow;
    } finally {
      state = ConnectionState.done;
      notifyListeners();
    }
  }

  Future updateLens(String key, data) async {
    var newData = data;
    state = ConnectionState.active;
    try {
      Map<String, dynamic> updatedLens = _lens.toMap();
      updatedLens.update(key, (value) {
        if (value.runtimeType == int) {
          newData = int.parse(data);
        }
        return newData;
      });

      _lens = Lens.fromMap(updatedLens);
      await _helper.updateLens(_lens.id!, {key: newData});
    } catch (e) {
      rethrow;
    } finally {
      state = ConnectionState.done;
      notifyListeners();
    }
  }

  Future deleteLens() async {
    state = ConnectionState.active;
    try {
      notifyListeners();
      await _helper.deleteLens(lens);
      lenses.remove(lens);
    } catch (e) {
      rethrow;
    } finally {
      state = ConnectionState.done;
      notifyListeners();
    }
  }

  Future uploadImage() async {
    try {
      String url = await _helper.uploadImage(_lens.id!, File(_image!.path));
      await updateLens('imageUrl', url);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> pickImage({bool takeCamera = false}) async {
    try {
      ImageSource source =
          takeCamera ? ImageSource.camera : ImageSource.gallery;

      final pict = await _picker.pickImage(source: source);
      String filePath = pict?.path ?? '';
      String newPath = '${filePath}_compressed.jpg';
      var compressed = await FlutterImageCompress.compressAndGetFile(
        filePath,
        newPath,
        keepExif: true,
        quality: 50,
      );

      _image = XFile(compressed!.path);

      notifyListeners();
      return _image!.path;
    } catch (e) {
      throw 'Failed to get image';
    }
  }
}
