class Message {
  final int? id; // Made nullable to allow auto-generation by the database
  final DateTime timestamp;
  final String sender;
  final String receiver;
  final String content;
  final bool edited;

  Message({
    this.id, // Now nullable
    required this.timestamp,
    required this.sender,
    required this.receiver,
    required this.content,
    this.edited = false,
  });

  // Convert a Message into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Can be null
      'timestamp': timestamp.toIso8601String(),
      'sender': sender,
      'receiver': receiver,
      'content': content,
      'edited': edited ? 1 : 0,
    };
  }

  // Implement a method to create a message from a Map
  static Message fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      timestamp: DateTime.parse(map['timestamp']),
      sender: map['sender'],
      receiver: map['receiver'],
      content: map['content'],
      edited: map['edited'] == 1,
    );
  }

  // Implement a copyWith method
  Message copyWith({
    int? id,
    DateTime? timestamp,
    String? sender,
    String? receiver,
    String? content,
    bool? edited,
  }) {
    return Message(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      content: content ?? this.content,
      edited: edited ?? this.edited,
    );
  }
}
