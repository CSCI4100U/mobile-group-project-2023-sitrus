import 'package:async/async.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'local_storage.dart';
import 'message.dart';

class ChatPage extends StatefulWidget {
  final String userName;
  final String friendName;
  final String friendStatus;
  final String friendUid;

  const ChatPage({
    Key? key,
    required this.userName,
    required this.friendName,
    required this.friendStatus,
    required this.friendUid,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Controllers for message input and scrolling
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // List to hold messages
  List<Message> messages = [];

  // Background color and image for chat
  Color _backgroundColor = Colors.white;
  String? _backgroundImage;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadMessagesFromCloud();
  }

  // Listener for scroll events
  void _scrollListener() {
    // Auto-scroll to the bottom of the chat when new message arrives
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels == 0) {
        // Top of the list
      } else {
        _scrollToBottom();
      }
    }
  }

  // Method to scroll to the bottom of the chat
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // Method to load messages from Firestore
  void _loadMessagesFromCloud() {
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    String friendUid = widget.friendUid;

    var sentMessagesStream = FirebaseFirestore.instance
        .collection('messages')
        .where('senderUid', isEqualTo: currentUserUid)
        .where('receiverUid', isEqualTo: friendUid)
        .orderBy('timestamp', descending: false)
        .snapshots();

    var receivedMessagesStream = FirebaseFirestore.instance
        .collection('messages')
        .where('senderUid', isEqualTo: friendUid)
        .where('receiverUid', isEqualTo: currentUserUid)
        .orderBy('timestamp', descending: false)
        .snapshots();

    StreamZip([sentMessagesStream, receivedMessagesStream]).listen((snapshots) {
      List<DocumentSnapshot> combined = [];
      for (var snapshot in snapshots) {
        combined.addAll(snapshot.docs);
      }

      combined.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));

      List<Message> newMessages = combined
          .map((doc) => Message.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      setState(() {
        messages = newMessages;
      });
    });
  }


  void _showSettings() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Chat History'),
              onTap: () async {
                Navigator.pop(context); // Dismiss the bottom sheet
                await _deleteChatHistory();
              },
            ),
            ListTile(
              leading: const Icon(Icons.format_paint),
              title: const Text('Change Background'),
              onTap: () {
                Navigator.pop(context); // Dismiss the bottom sheet
                _showBackgroundOptions();
              },
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Back up Chat History from Cloud'),
              onTap: () {
                // load logic
                Navigator.pop(context);
                backupChatToLocalForSpecificFriend(widget.friendUid);
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload),
              title: const Text('Upload Local Backup Chat History To Cloud'),
              onTap: () {
                // load logic
                Navigator.pop(context);
                uploadLocalBackupToCloudForSpecificFriend(widget.friendUid);
              },
            ),
          ],
        );
      },
    );
  }

  // Method to delete all chat history with the current associate
  Future<void> _deleteChatHistory() async {
    // Delete chat history from Firestore
    QuerySnapshot sentMessages = await FirebaseFirestore.instance
        .collection('messages')
        .where('senderUid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('receiverUid', isEqualTo: widget.friendUid)
        .get();

    QuerySnapshot receivedMessages = await FirebaseFirestore.instance
        .collection('messages')
        .where('senderUid', isEqualTo: widget.friendUid)
        .where('receiverUid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    for (var doc in sentMessages.docs) {
      await doc.reference.delete();
    }

    for (var doc in receivedMessages.docs) {
      await doc.reference.delete();
    }

    setState(() {
      messages.clear();
    });
  }

  // Method to show background options
  void _showBackgroundOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.brightness_1),
              title: const Text('Light'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _backgroundColor = Colors.white;
                  _backgroundImage = null;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.brightness_3),
              title: const Text('Dark'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _backgroundColor = Colors.blueGrey;
                  _backgroundImage = null;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Upload Image'),
              onTap: () {
                Navigator.pop(context);
                _uploadImage();
              },
            ),
          ],
        );
      },
    );
  }

  // Method to handle image upload
  void _uploadImage() {
    // TODO: Implement the logic for uploading an image
    // For example, using image_picker package to pick an image
    // and then setting _backgroundImage to the path of the selected image
  }

  // This method is triggered when the send button is pressed
  // Method to send a new message
  void _sendMessage() async {
    final String content = _messageController.text.trim();
    if (content.isEmpty) {
      return;
    }

    final String userUid = FirebaseAuth.instance.currentUser!.uid;
    final String friendUid = widget.friendUid;

    final Message newMessage = Message(
      timestamp: Timestamp.now(),
      sender: widget.userName,
      senderUid: userUid,
      receiver: widget.friendName,
      receiverUid: friendUid,
      content: content,
      edited: false,
      deleted: false,
    );

    try {
      await FirebaseFirestore.instance.collection('messages').add(newMessage.toMap());
      setState(() {
        messages.insert(0, newMessage);
        _messageController.clear();
        _scrollToBottom();
      });
    } catch (e) {
      // Error handling for message send failure
    }
  }

  // Method to delete a message
  void _deleteMessage(String messageId) async {
    // Directly delete the message from Firestore
    await FirebaseFirestore.instance.collection('messages').doc(messageId).delete();

    // Update UI
    setState(() {
      messages.removeWhere((message) => message.uid == messageId);
    });

    // Show a snackbar message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Message deleted')),
    );
  }

  // Method to edit a message
  void _editMessage(String messageId, String newContent) async {
    // Update Firestore
    await FirebaseFirestore.instance.collection('messages').doc(messageId).update({
      'content': newContent,
      'edited': true,
    });

    // Update the local message list
    int index = messages.indexWhere((message) => message.uid == messageId);
    if (index != -1) {
      setState(() {
        messages[index] = messages[index].copyWith(content: newContent, edited: true);
      });
    }

    // Show a snackbar message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message edited')),
    );
  }

  // Building each message item
  Widget _buildMessageItem(Message message) {
    bool isUserMessage = message.senderUid == FirebaseAuth.instance.currentUser!.uid;
    return Row(
      mainAxisAlignment: isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isUserMessage) ...[
          const Icon(Icons.account_circle), // Friend's icon
        ],
        GestureDetector(
          onLongPress: () => _showMessageOptions(context, message),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isUserMessage ? Colors.blue : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              message.content,
              style: TextStyle(color: isUserMessage ? Colors.white : Colors.black),
            ),
          ),
        ),
        if (isUserMessage) ...[
          const Icon(Icons.account_circle), // User's icon
        ],
      ],
    );
  }

  // Message options (edit, delete)
  void _showMessageOptions(BuildContext context, Message message) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                // edit logic
                Navigator.pop(context);
                _showEditDialog(message);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                // delete logic
                Navigator.pop(context);
                _deleteMessage(message.uid!); // Assuming id is not null here
              },
            ),
          ],
        );
      },
    );
  }

  // Edit dialog
  void _showEditDialog(Message message) {
    TextEditingController editController = TextEditingController(text: message.content);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Message'),
          content: TextField(
            controller: editController,
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                if (editController.text.trim().isNotEmpty) {
                  _editMessage(message.uid!, editController.text.trim());
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Assume DatabaseHelper is a class that handles local database operations
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Method to backup chat history to local storage
  Future<void> backupChatToLocalForSpecificFriend(String friendUid) async {
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    for (var message in messages) {
      // Check if the current user is involved in the message
      if (message.senderUid == currentUserUid || message.receiverUid == currentUserUid) {
        if (message.senderUid == friendUid || message.receiverUid == friendUid) {
          // Save the message to local storage
          await _databaseHelper.insertMessage(message.toMap());
        }
      }
    }
  }


  // Method to upload local backup to the cloud, only for messages between the current user and the specified friend
  Future<void> uploadLocalBackupToCloudForSpecificFriend(String friendUid) async {
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    // Fetch messages from local storage
    List<Message> localMessages = await _databaseHelper.queryMessagesBetween(currentUserUid, friendUid);

    for (var localMessage in localMessages) {
      // Check if the message already exists in the cloud
      var existingDoc = await FirebaseFirestore.instance.collection('messages')
          .doc(localMessage.uid)
          .get();

      // If the message doesn't exist in the cloud, upload it
      if (!existingDoc.exists) {
        await FirebaseFirestore.instance.collection('messages')
            .doc(localMessage.uid)
            .set(localMessage.toMap());
      }
    }
  }


  @override
  void dispose() {
    // Dispose controllers
    _messageController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // This is default and can be omitted if not changed before
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('${widget.friendName} - ${widget.friendStatus}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettings,
          ),
        ],
      ),
      body: Container(
        color: _backgroundImage == null ? _backgroundColor : null,
        decoration: _backgroundImage != null
          ? BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(_backgroundImage!),
              fit: BoxFit.cover,
              ),
            )
          : null,
        child: Column(
          children: [
            Expanded(
              child:
              ListView.builder(
                controller: _scrollController, // Use the ScrollController here
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  // If your messages list is reversed, use this:
                  // Message message = messages[index];
                  // Otherwise, if your list is in chronological order, use this:
                  Message message = messages[messages.length - 1 - index];
                  return _buildMessageItem(message);
                },
              )
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.photo),
                      onPressed: () {
                        // TODO:Implement sending image or video
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type a message',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
