import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:satria_optik_admin/helper/firebase_helper.dart';
import 'package:satria_optik_admin/model/chat.dart';

class ChatHelper extends FirestoreHelper {
  var uid = FirebaseAuth.instance.currentUser?.uid;

  Future<List<String>> getAllChatHead() async {
    try {
      var ref = await db
          .collectionGroup('chats')
          .where('sender', isNotEqualTo: 'admin')
          .orderBy('sender')
          .orderBy('timestamp', descending: true)
          .get();

      List<String> users = [];
      for (var element in ref.docs) {
        ChatMetaData chat = ChatMetaData.fromMap(element.data());
        chat = chat.copyWith(id: element.id);
        users.add(chat.senderId ?? '');
      }
      var p = users.toSet().toList();
      return p;
    } on FirebaseException catch (e) {
      throw 'Error $e';
    } catch (e) {
      throw 'Unexpected error';
    }
  }

  Future<String> newMessage(ChatMetaData chat, String userId) async {
    try {
      final ref = db.collection('users').doc(userId).collection('chats');
      chat = chat.copyWith(
        senderId: uid,
        timestamp: Timestamp.now(),
      );

      var doc = await ref.add(chat.toMap());

      return doc.id;
    } on FirebaseException catch (e) {
      throw 'Error happened. code: $e';
    } catch (e) {
      throw 'Error happened.';
    }
  }
}
