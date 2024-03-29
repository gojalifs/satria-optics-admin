import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:satria_optik_admin/helper/product_helper.dart';
import 'package:satria_optik_admin/model/glass_frame.dart';
import 'package:satria_optik_admin/model/lens.dart';
import 'package:satria_optik_admin/provider/base_provider.dart';

class ProductProvider extends BaseProvider {
  final ProductHelper _helper = ProductHelper();
  bool _isRefresh = true;

  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  String? _imagePath = '';
  Map<String, dynamic>? _tempVariantData;

  List<GlassFrame> _frames = [];
  GlassFrame _frame = GlassFrame();
  List<Lens> _lenses = [];

  bool get isRefresh => _isRefresh;
  List<GlassFrame> get frames => _frames;
  GlassFrame get frame => _frame;
  List<Lens> get lenses => _lenses;

  XFile? get image => _image;
  String? get imagePath => _imagePath;
  Map<String, dynamic>? get tempVariantData => _tempVariantData;

  set isRefresh(bool refresh) {
    _isRefresh = refresh;
    notifyListeners();
  }

  set frame(GlassFrame frame) {
    _frame = frame;
    notifyListeners();
  }

  set image(XFile? image) {
    _image = null;
    _imagePath = null;
  }

  set tempvariantData(Map<String, dynamic> data) {
    _tempVariantData = data;
    notifyListeners();
  }

  Future getProducts(String type) async {
    // if the request is not refresh, return

    if (_isRefresh == false && (_frames.isNotEmpty && _lenses.isNotEmpty)) {
      return;
    }
    // run the getting data
    try {
      state = ConnectionState.active;
      if (type == 'products') {
        if (_frames.isNotEmpty && _isRefresh == false) {
          return;
        }

        _frames = await _helper.getFrames();
      } else if (type == 'lens') {
        if (_lenses.isNotEmpty && _isRefresh == false) {
          return;
        }
        _lenses = await _helper.getLenses();
      }
    } catch (e) {
      throw 'Error getting data, try again later';
    } finally {
      _isRefresh = false;
      state = ConnectionState.done;
      notifyListeners();
    }
  }

  Future<bool> addProduct() async {
    state = ConnectionState.active;
    try {
      notifyListeners();
      await _helper.addProduct(frame);
      _frames.add(frame);
      return true;
    } catch (e) {
      rethrow;
    } finally {
      state = ConnectionState.done;
      notifyListeners();
    }
  }

  Future<bool> updateFrame(Map<String, dynamic> data) async {
    try {
      state = ConnectionState.active;
      await _helper.updateFrame(_frame.id!, {data['key']: data['value']});

      var frame = _frame.toMap();
      var index = _frames.indexWhere((element) => element == _frame);
      frame[data['key']] = data['value'];

      _frame = GlassFrame.fromMap(frame);
      _frames[index] = _frame;
      return true;
    } catch (e) {
      rethrow;
    } finally {
      state = ConnectionState.done;
      notifyListeners();
    }
  }

  Future deleteProduct() async {
    state = ConnectionState.active;
    try {
      notifyListeners();
      await _helper.deleteProduct(frame);
      _frames.remove(frame);
    } catch (e) {
      rethrow;
    } finally {
      state = ConnectionState.done;
      notifyListeners();
    }
  }

  Future uploadImage() async {
    state = ConnectionState.active;
    notifyListeners();
    try {
      Map<String, dynamic> newMap = Map.from(_tempVariantData!);
      newMap.removeWhere((key, value) {
        return !(value as Map).containsKey('tempPath');
      });
      String? resultUrl;

      for (var entry in newMap.entries) {
        final key = entry.key;
        final value = entry.value;

        resultUrl = await _helper.uploadImage(
          _frame.id!,
          File(value['tempPath']),
          color: key,
        );
        if (value is Map) {
          value.remove('tempPath');
        }
        _tempVariantData?[key]['url'] = resultUrl;
      }

      _tempVariantData!.addEntries(newMap.entries);
      await _helper.updateFrameColors(_frame.id!, _tempVariantData!);
    } catch (e) {
      rethrow;
    } finally {
      notifyListeners();
      state = ConnectionState.done;
    }
  }

  Future uploadMainImage(String path) async {
    state = ConnectionState.active;
    notifyListeners();
    try {
      String url = await _helper.uploadImage(_frame.id!, File(path));
      await _helper.updateFrame(_frame.id!, {
        'imageUrl': FieldValue.arrayUnion([url])
      });
      _frame.imageUrl?.add(url);
    } catch (e) {
      rethrow;
    } finally {
      state = ConnectionState.done;

      notifyListeners();
    }
  }

  Future deleteImage(String color) async {
    state = ConnectionState.active;
    try {
      await _helper.deleteImage(_frame.id!, color);
      await _helper.updateFrameColors(_frame.id!, _tempVariantData!);
    } catch (e) {
      rethrow;
    } finally {
      state = ConnectionState.done;
      notifyListeners();
    }
  }

  Future deleteMainImage(String url) async {
    state = ConnectionState.active;
    try {
      await _helper.deleteMainImage(_frame.id!, url);
    } catch (e) {
      rethrow;
    } finally {
      state = ConnectionState.done;
      notifyListeners();
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
      _imagePath = _image!.path.split('/').last;
      notifyListeners();
      return _image!.path;
    } catch (e) {
      throw 'Failed to get image';
    }
  }
}
