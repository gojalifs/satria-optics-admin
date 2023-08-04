import 'package:satria_optik_admin/helper/firebase_helper.dart';
import 'package:satria_optik_admin/model/lens.dart';

class LensHelper extends FirestoreHelper {
  Future<List<Lens>> getLenses() async {
    try {
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
    } catch (e) {
      print(e);
      throw 'error while getting lenses';
    }
  }
}
