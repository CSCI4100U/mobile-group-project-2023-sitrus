class Message {
  final String? uid; // Nullable to allow auto-generation by the database
  final DateTime timestamp;
  final String sender;
  final String senderUid;
  final String receiver;
  final String receiverUid;
  final String content;
  final bool edited;
  final bool deleted; // Assuming you want to track if a message is deleted

  Message({
    this.uid, // Nullable
    required this.timestamp,
    required this.sender,
    required this.senderUid,
    required this.receiver,
    required this.receiverUid,
    required this.content,
    this.edited = false,
    this.deleted = false, // Default to false
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid, // Can be null
      'timestamp': timestamp.toIso8601String(),
      'sender': sender,
      'senderUid': senderUid,
      'receiver': receiver,
      'receiverUid': receiverUid,
      'content': content,
      'edited': edited ? 1 : 0,
      'deleted': deleted ? 1 : 0, // Assuming you are using 1 and 0 to represent true and false
    };
  }

  static Message fromMap(Map<String, dynamic> map) {
    return Message(
      uid: map['uid'],
      timestamp: DateTime.parse(map['timestamp']),
      sender: map['sender'],
      senderUid: map['senderUid'],
      receiver: map['receiver'],
      receiverUid: map['receiverUid'],
      content: map['content'],
      edited: map['edited'] == 1,
      deleted: map['deleted'] == 1, // Handle the 'deleted' field
    );
  }

  Message copyWith({
    String? uid,
    DateTime? timestamp,
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
