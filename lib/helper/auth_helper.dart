import 'package:firebase_auth/firebase_auth.dart';
import 'package:satria_optik_admin/helper/firebase_helper.dart';

class AuthHelper extends FirestoreHelper {
  Future<UserCredential> login(String email, String password) async {
    try {
      /* 
      check if email is not on admins collection */
      var ref = db.collection('admins').where('email', isEqualTo: email);
      var admins = await ref.get();
      if (admins.size == 0) {
        throw 'Your Email Is Not Registered';
      }
      var credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        throw 'Wrong password provided for that user.';
      }
      throw 'Failed To Login';
    } catch (e) {
      rethrow;
    }
  }

  Future changeEmail(
      User user, String oldEmail, String newEmail, String password) async {
    try {
      var credential =
          EmailAuthProvider.credential(email: oldEmail, password: password);
      await user.reauthenticateWithCredential(credential);
      await user.updateEmail(newEmail);
      await FirebaseAuth.instance.currentUser?.reload();

      /* 
        if above success, update data on collection
       */

      var ref = db.collection('admins').doc(user.uid);
      await ref.update({'email': newEmail});
    } catch (e) {
      throw 'Error Happened';
    }
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
