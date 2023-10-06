import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ChatHeader {
  final String? id;
  final String? name;
  final String? lastMessage;
  final List<ChatMetaData>? chats;

  ChatHeader({
    this.id,
    this.name,
    this.lastMessage,
    this.chats,
  });

  ChatHeader copyWith({
    ValueGetter<String?>? id,
    ValueGetter<String?>? name,
    ValueGetter<String?>? lastMessage,
    ValueGetter<List<ChatMetaData>?>? chat,
  }) {
    return ChatHeader(
      id: id != null ? id() : this.id,
      name: name != null ? name() : this.name,
      lastMessage: lastMessage != null ? lastMessage() : this.lastMessage,
      chats: chat != null ? chat() : this.chats,
    );
  }

  @override
  String toString() {
    return 'ChatHeader(id: $id, name: $name, lastMessage: $lastMessage, chat: $chats)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatHeader &&
        other.id == id &&
        other.name == name &&
        other.lastMessage == lastMessage &&
        listEquals(other.chats, chats);
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ lastMessage.hashCode ^ chats.hashCode;
  }
}

class ChatMetaData {
  final String? id;
  final String? sender;
  final String? senderName;
  final String? senderId;
  final String? message;
  final Timestamp? timestamp;

  ChatMetaData({
    this.id,
    this.sender,
    this.senderName,
    this.senderId,
    this.message,
    this.timestamp,
  });

  ChatMetaData copyWith({
    String? id,
    String? sender,
    String? senderName,
    String? senderId,
    String? message,
    Timestamp? timestamp,
  }) {
    return ChatMetaData(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      senderName: senderName ?? this.senderName,
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'sender': sender,
      'senderName': senderName,
      'senderId': senderId,
      'message': message,
      'timestamp': timestamp,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender': sender,
      'senderName': senderName,
      'senderId': senderId,
      'message': message,
      'timestamp': timestamp,
    };
  }

  factory ChatMetaData.fromMap(Map<String, dynamic> map) {
    return ChatMetaData(
      id: map['id'],
      sender: map['sender'],
      senderName: map['senderName'],
      senderId: map['senderId'],
      message: map['message'],
      timestamp: map['timestamp'],
    );
  }

  @override
  String toString() {
    return 'ChatMetaData(id: $id, sender: $sender, senderName: $senderName, senderId: $senderId, message: $message, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatMetaData &&
        other.id == id &&
        other.sender == sender &&
        other.senderName == senderName &&
        other.senderId == senderId &&
        other.message == message &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        sender.hashCode ^
        senderName.hashCode ^
        senderId.hashCode ^
        message.hashCode ^
        timestamp.hashCode;
  }
}
