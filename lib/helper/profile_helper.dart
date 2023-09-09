import 'package:satria_optik_admin/helper/firebase_helper.dart';
import 'package:satria_optik_admin/model/admins.dart';

class ProfileHelper extends FirestoreHelper {
  Future<Admin> getAdminData(String id) async {
    try {
      var ref = db.collection('admins').doc(id);
      var data = await ref.get();
      Map<String, dynamic> adminMap = data.data()!;
      adminMap['id'] = data.id;
      return Admin.fromMap(adminMap);
    } catch (e, s) {
      print(s);
      throw 'Error getting data';
    }
  }

  Future editAdmin(Admin profile) async {
    try {
      var ref = db.collection('admins').doc(profile.id);

      await ref.update(profile.toMap());
    } catch (e) {
      throw 'Error getting data';
    }
  }
}
