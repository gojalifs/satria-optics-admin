import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:satria_optik_admin/helper/firebase_helper.dart';
import 'package:satria_optik_admin/model/glass_frame.dart';
import 'package:satria_optik_admin/model/lens.dart';

class ProductHelper extends FirestoreHelper {
  Future<List<GlassFrame>> getFrames() async {
    try {
      List<GlassFrame> frames = [];
      var ref = db.collection('products');
      var collection = await ref.get();
      for (var element in collection.docs) {
        var data = element.data();
        data['id'] = element.id;

        frames.add(GlassFrame.fromMap(data));
      }
      return frames;
    } catch (e, s) {
      print(s);
      rethrow;
    }
  }

  Future addProduct(GlassFrame frame) async {
    try {
      var ref = db.collection('products').doc();
      await ref.set(frame.toMap(), SetOptions(merge: true));
      frame = frame.copyWith(id: ref.id);
    } catch (e) {
      throw 'error adding data. try again later';
    }
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

  Future deleteProduct(GlassFrame frame) async {
    try {
      var ref = db.collection('products').doc(frame.id);
      await ref.delete();
    } catch (e) {
      throw 'Error deleting product. try again';
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

  Future<String> uploadImage(String id, File file, {String? color}) async {
    Reference ref;
    if (color != null) {
      ref = storageRef
          .child('products')
          .child('frame')
          .child(id)
          .child('variants')
          .child(color);
    } else {
      ref = storageRef
          .child('products')
          .child('frame')
          .child(id)
          .child(XFile(file.path).name);
    }

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

    try {
      await ref.delete();
    } catch (e) {
      throw 'failed to delete image, try again later';
    }
  }

  Future deleteMainImage(String id, String url) async {
    Reference ref = FirebaseStorage.instance.refFromURL(url);
    try {
      await ref.delete();
      await db.collection('products').doc(id).update({
        'imageUrl': FieldValue.arrayRemove([url]),
      });
    } catch (e) {
      throw 'failed to delete image, try again later';
    }
  }
}
