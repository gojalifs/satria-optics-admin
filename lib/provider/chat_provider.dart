import 'package:flutter/widgets.dart';
import 'package:satria_optik_admin/helper/chat_helper.dart';
import 'package:satria_optik_admin/model/chat.dart';
import 'package:satria_optik_admin/provider/base_provider.dart';

class ChatProvider extends BaseProvider {
  final _helper = ChatHelper();
  List<ChatMetaData> _chats = [];
  List<String> _allChatId = [];

  List<ChatMetaData> get chat => _chats;
  List<String> get allChat => _allChatId;

  getAllChat() async {
    state = ConnectionState.active;
    try {
      _allChatId = await _helper.getAllChatHead();
    } catch (e) {
      rethrow;
    } finally {
      state = ConnectionState.done;
      notifyListeners();
    }
  }

  addNewChat(ChatMetaData chat, String userId) async {
    state = ConnectionState.active;
    try {
      _chats.add(chat);
      var id = await _helper.newMessage(chat, userId);
      var i = _chats.indexOf(chat);
      _chats[i] = chat.copyWith(id: id);
    } catch (e) {
      rethrow;
    } finally {
      state = ConnectionState.done;
      notifyListeners();
    }
  }
}
