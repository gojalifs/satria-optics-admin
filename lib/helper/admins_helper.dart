import 'package:satria_optik_admin/helper/firebase_helper.dart';
import 'package:satria_optik_admin/model/admins.dart';

class AdminHelper extends FirestoreHelper {
  Future<List<Admin>> getAdmins() async {
    List<Admin> admins = [];
    var ref = db.collection('admins');
    var adminsData = await ref.get();

    for (var admin in adminsData.docs) {
      var adminMap = admin.data();
      adminMap['id'] = admin.id;

      admins.add(Admin.fromMap(adminMap));
    }
    return admins;
  }

  Future setStatus(Admin admin) async {
    try {
      var ref = db.collection('admins').doc(admin.id);
      await ref.update(admin.toMap());
    } catch (e) {
      throw 'Failed to update data, try again later';
    }
  }

  Future<String> addAdmin(Admin admin) async {
    try {
      var ref = db.collection('admins');
      var data = await ref.add(admin.toMap());
      var id = data.id;
      return id;
    } catch (e) {
      throw 'Failed to add data, try again later';
    }
  }

  Future deleteAdmin(String id) async {
    try {
      var ref = db.collection('admins').doc(id);
      await ref.delete();
    } catch (e) {
      throw 'Failed to delete admin';
    }
  }
}
