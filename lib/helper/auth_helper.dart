import 'package:firebase_auth/firebase_auth.dart';
import 'package:satria_optik_admin/helper/firebase_helper.dart';

class AuthHelper extends FirestoreHelper {
  Future<UserCredential> login(String email, String password) async {
    try {
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
      throw 'Failed To Login';
    }
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
