import 'dart:io';

import 'package:satria_optik_admin/helper/firebase_helper.dart';
import 'package:satria_optik_admin/model/glass_frame.dart';
import 'package:satria_optik_admin/model/lens.dart';

class ProductHelper extends FirestoreHelper {
  Future<List<GlassFrame>> getFrames() async {
    List<GlassFrame> frames = [];
    var ref = db.collection('products');
    var collection = await ref.get();
    for (var element in collection.docs) {
      var data = element.data();
      data['id'] = element.id;

      frames.add(GlassFrame.fromMap(data));
    }
    return frames;
  }

  Future<bool> updateFrame(String id, Map<String, dynamic> data) async {
    try {
      var ref = db.collection('products').doc(id);
      await ref.update(data);
      return true;
    } catch (e) {
      throw 'error updating data. code $e';
    }
  }

  Future updateFrameColors(String id, Map<String, dynamic> data) async {
    try {
      var ref = db.collection('products').doc(id);
      await ref.update({'colors': data});
    } catch (e) {
      throw 'error updating frame color.';
    }
  }

  Future<List<Lens>> getLenses() async {
    List<Lens> lenses = [];
    var ref = db.collection('lens');
    var collection = await ref.get();
    for (var element in collection.docs) {
      var data = element.data();
      data['id'] = element.id;

      lenses.add(Lens.fromMap(data));
    }
    return lenses;
  }

  Future<String> uploadImage(String id, File file, String color) async {
    var ref = storageRef
        .child('products')
        .child('frame')
        .child(id)
        .child('variants')
        .child(color);

    try {
      await ref.putFile(file);
      var url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      throw 'failed to upload, try again later';
    }
  }

  Future deleteImage(String id, String color) async {
    var ref = storageRef
        .child('products')
        .child('frame')
        .child(id)
        .child('variants')
        .child(color);

    // try {
    await ref.delete();
    // } catch (e) {
    //   throw 'failed to delete image, try again later';
    // }
  }
}
