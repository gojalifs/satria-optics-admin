import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:satria_optik_admin/model/chat.dart';
import 'package:satria_optik_admin/screen/chat/chat_data_screen.dart';

class ChatPage extends StatelessWidget {
  static const page = 'chat';
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    var stream = FirebaseFirestore.instance
        .collectionGroup('chats')
        .orderBy('timestamp', descending: true)
        .snapshots();
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        List<String> allChatBuyerId = [];
        if (snapshot.data?.docs != null) {
          for (var element in snapshot.data!.docs) {
            ChatMetaData chat = ChatMetaData.fromMap(element.data());
            chat = chat.copyWith(id: element.id);
            if (!allChatBuyerId.contains(chat.senderId)) {
              if (chat.sender == 'user') {
                allChatBuyerId.add(chat.senderId ?? '');
              }
            } else {
              continue;
            }
          }
        }
        allChatBuyerId = allChatBuyerId.toSet().toList();

        return ListView.builder(
          itemCount: allChatBuyerId.length,
          itemBuilder: (context, index) {
            var chatHeader = allChatBuyerId[index];
            return InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(
                  ChatDataPage.page,
                  arguments: chatHeader,
                );
              },
              child: Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: ListTile(
                    title: Text(
                      chatHeader,
                    ),
                    subtitle: const Text('New Message Received'),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
