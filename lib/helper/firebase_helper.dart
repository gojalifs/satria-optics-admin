import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreHelper {
  final String? _userID;
  final FirebaseFirestore _db;
  final Reference _storageRef;
  final FieldValue _timestamp;

  FirestoreHelper()
      : _userID = FirebaseAuth.instance.currentUser?.uid,
        _db = FirebaseFirestore.instance,
        _storageRef = FirebaseStorage.instance.ref(),
        _timestamp = FieldValue.serverTimestamp();

  String? get userID => _userID;
  FirebaseFirestore get db => _db;
  Reference get storageRef => _storageRef;
  FieldValue get timestamp => _timestamp;
}
