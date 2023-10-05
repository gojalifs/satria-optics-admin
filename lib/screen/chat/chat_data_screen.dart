import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik_admin/custom/common_function.dart' as format;
import 'package:satria_optik_admin/model/chat.dart';
import 'package:satria_optik_admin/provider/chat_provider.dart';

class ChatDataPage extends StatefulWidget {
  static const page = 'chat-data';
  final String userId;

  const ChatDataPage({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<ChatDataPage> createState() => _ChatDataPageState();
}

class _ChatDataPageState extends State<ChatDataPage> {
  final controller = TextEditingController();

  Stream<QuerySnapshot<Map<String, dynamic>>>? stream;

  @override
  void initState() {
    stream = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('chats')
        .orderBy('timestamp', descending: true)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.userId}'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 48),
            child: StreamBuilder(
              stream: stream,
              builder: (context, snapshot) {
                List<ChatMetaData> chatData = [];
                if (snapshot.data?.docs != null) {
                  for (var element in snapshot.data!.docs) {
                    chatData.add(ChatMetaData.fromMap(element.data()));
                  }
                }

                return ListView.builder(
                  itemCount: chatData.length,
                  shrinkWrap: true,
                  reverse: true,
                  padding: const EdgeInsets.only(
                    right: 16,
                    left: 16,
                  ),
                  itemBuilder: (context, index) {
                    var chat = chatData[index];
                    return ChatBubble(
                      chat: chat,
                      isSender: chat.sender == 'admin',
                    );
                  },
                );
              },
            ),
          ),
          // const Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10, right: 16, left: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      minLines: 1,
                      maxLines: 3,
                      decoration: const InputDecoration(
                          hintText: 'type message here...',
                          fillColor: Colors.black),
                    ),
                  ),
                  IconButton(
                    onPressed: controller.text.isEmpty
                        ? null
                        : () {
                            print('object');
                            Provider.of<ChatProvider>(context, listen: false)
                                .addNewChat(
                              ChatMetaData(
                                message: controller.text.trim(),
                                sender: 'admin',
                              ),
                              widget.userId,
                            );
                            controller.clear();
                          },
                    icon: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final ChatMetaData? chat;
  final bool isSender;

  const ChatBubble({
    Key? key,
    this.chat,
    required this.isSender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bgColor = isSender
        ? Theme.of(context).colorScheme.secondaryContainer
        : Theme.of(context).colorScheme.tertiaryContainer;

    var bubbleRadius = 15.0;
    var textStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 18,
    );

    return Row(
      children: <Widget>[
        isSender
            ? const Expanded(
                child: SizedBox(
                  width: 5,
                ),
              )
            : Container(),
        Container(
          color: Colors.transparent,
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Container(
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(bubbleRadius),
                  topRight: Radius.circular(bubbleRadius),
                  bottomLeft: Radius.circular(isSender ? bubbleRadius : 0),
                  bottomRight: Radius.circular(isSender ? 0 : bubbleRadius),
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 6, 28, 6),
                    child: Column(
                      crossAxisAlignment: isSender
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          chat?.message ?? '',
                          style: textStyle,
                          textAlign: TextAlign.left,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              format.hourFormat(chat?.timestamp),
                              style: const TextStyle(
                                color: Colors.black45,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 20),
                            isSender
                                ? const SizedBox()
                                : Text(
                                    '${chat?.senderName}',
                                    style: const TextStyle(
                                      color: Colors.black45,
                                      fontSize: 16,
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Positioned(
                    bottom: 4,
                    right: 6,
                    child: Icon(
                      Icons.done,
                      size: 18,
                      color: Color(0xFF97AD8E),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
