import 'dart:io';

import 'package:satria_optik_admin/helper/firebase_helper.dart';
import 'package:satria_optik_admin/model/lens.dart';

class LensHelper extends FirestoreHelper {
  Future<List<Lens>> getLenses() async {
    // try {
    List<Lens> lenses = [];
    var ref = db.collection('lens');
    var datas = await ref.get();
    for (var element in datas.docs) {
      var data = element.data();
      data['id'] = element.id;

      Lens lens = Lens.fromMap(data);
      lenses.add(lens);
    }
    return lenses;
  }

  Future addLens(Lens lens) async {
    try {
      var ref = db.collection('lens').doc();
      await ref.set(lens.toFirestore());
      lens = lens.copyWith(id: ref.id);
    } catch (e) {
      throw 'error adding lens';
    }
  }

  Future updateLens(String id, Map<String, dynamic> data) async {
    try {
      var ref = db.collection('lens').doc(id);
      await ref.update(data);
    } catch (e) {
      throw 'error while getting lenses';
    }
  }

  Future deleteLens(Lens lens) async {
    try {
      var ref = db.collection('lens').doc(lens.id);
      await ref.delete();
    } catch (e) {
      throw 'error deleting data';
    }
  }

  Future<String> uploadImage(String id, File image) async {
    try {
      var ref = storageRef.child('products').child('lens').child(id);
      await ref.putFile(image);
      var url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      throw 'error uploading image';
    }
  }
}
