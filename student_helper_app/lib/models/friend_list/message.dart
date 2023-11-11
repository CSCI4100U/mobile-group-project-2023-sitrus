import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String? uid; // Nullable for auto-generation by the database
  final Timestamp timestamp; // Changed to Timestamp type for Firestore compatibility
  final String sender;
  final String senderUid;
  final String receiver;
  final String receiverUid;
  final String content;
  final bool edited;
  final bool deleted;

  Message({
    this.uid,
    required this.timestamp,
    required this.sender,
    required this.senderUid,
    required this.receiver,
    required this.receiverUid,
    required this.content,
    this.edited = false,
    this.deleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid, // Can be null
      'timestamp': timestamp,
      'sender': sender,
      'senderUid': senderUid,
      'receiver': receiver,
      'receiverUid': receiverUid,
      'content': content,
      'edited': edited,
      'deleted': deleted,
    };
  }

  static Message fromMap(Map<String, dynamic> map) {
    return Message(
      uid: map['uid'],
      timestamp: map['timestamp'] as Timestamp,
      sender: map['sender'],
      senderUid: map['senderUid'],
      receiver: map['receiver'],
      receiverUid: map['receiverUid'],
      content: map['content'],
      edited: map['edited'] ?? false,
      deleted: map['deleted'] ?? false,
    );
  }

  Message copyWith({
    String? uid,
    Timestamp? timestamp,
    String? sender,
    String? senderUid,
    String? receiver,
    String? receiverUid,
    String? content,
    bool? edited,
    bool? deleted,
  }) {
    return Message(
      uid: uid ?? this.uid,
      timestamp: timestamp ?? this.timestamp,
      sender: sender ?? this.sender,
      senderUid: senderUid ?? this.senderUid,
      receiver: receiver ?? this.receiver,
      receiverUid: receiverUid ?? this.receiverUid,
      content: content ?? this.content,
      edited: edited ?? this.edited,
      deleted: deleted ?? this.deleted,
    );
  }
}
