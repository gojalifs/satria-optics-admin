import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik_admin/provider/chat_provider.dart';
import 'package:satria_optik_admin/screen/chat/chat_data_screen.dart';

class ChatPage extends StatelessWidget {
  static const page = 'chat';
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      onRefresh: () {
        Provider.of<ChatProvider>(context, listen: false).getAllChat();
      },
      refreshOnStart: true,
      child: Consumer<ChatProvider>(
        builder: (context, value, child) {
          if (value.state == ConnectionState.active) {
            return LoadingAnimationWidget.threeArchedCircle(
                color: Theme.of(context).primaryColor, size: 20);
          }
          return ListView.builder(
            itemCount: value.allChat.length,
            itemBuilder: (context, index) {
              var chatHeader = value.allChat[index];
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
                    child: Text(
                      chatHeader,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
