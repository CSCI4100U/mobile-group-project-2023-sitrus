import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'local_storage.dart';
import 'message.dart';

class ChatPage extends StatefulWidget {
  final String userName;
  final String friendName;
  final String friendStatus;
  final String friendUid; // Add this line

  const ChatPage({
    Key? key,
    required this.userName,
    required this.friendName,
    required this.friendStatus,
    required this.friendUid, // Add this line
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Message> messages = []; // Use the Message model

  // State variable to hold the background setting
  Color _backgroundColor = Colors.white; // Default to white
  String? _backgroundImage; // Will hold the path to the background image

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadMessages();
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels == 0) {
        // You're at the top of the list
      } else {
        // You're at the bottom of the list
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _loadMessages() async {
    // Assuming 'userUid' is the UID of the current logged-in user.
    final String userUid = FirebaseAuth.instance.currentUser!.uid;
    // 'friendUid' needs to be provided to this widget.
    final String friendUid = widget.friendUid; // You need to add this variable to your widget.

    final List<Map<String, dynamic>> messageMaps = await DatabaseHelper.instance.queryMessages(userUid, friendUid);
    final List<Message> loadedMessages = messageMaps.map((messageMap) => Message.fromMap(messageMap)).toList();

    setState(() {
      messages = loadedMessages;
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
              title: const Text('Download Chat History from Cloud'),
              onTap: () {
                // load logic
                Navigator.pop(context);
                _loadMessagesFromCloud();
              },
            ),
          ],
        );
      },
    );
  }

  // Method to delete all chat history with the current associate
  Future<void> _deleteChatHistory() async {
    await DatabaseHelper.instance.deleteConversation(widget.userName, widget.friendName);
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
  void _sendMessage() async {
    final String content = _messageController.text.trim();
    if (content.isEmpty) {
      return;
    }

    // Assuming 'userUid' is the UID of the current logged-in user and 'friendUid' is provided to the widget.
    final String userUid = FirebaseAuth.instance.currentUser!.uid;
    final String friendUid = widget.friendUid; // You need to add this variable to your widget.

    // Create a new message object with UIDs
    final Message newMessage = Message(
      timestamp: DateTime.now(),
      sender: widget.userName, // Replace with the actual sender's name or username
      senderUid: userUid,
      receiver: widget.friendName,
      receiverUid: friendUid,
      content: content,
      edited: false,
      deleted: false, // Include the 'deleted' field
    );

    // Convert the message to a map before storing it
    final Map<String, dynamic> messageMap = newMessage.toMap();

    // Store the message locally and send to Firestore
    try {
      int uid = await DatabaseHelper.instance.insert(messageMap);

      // Update the local messages list
      setState(() {
        messages.insert(0, newMessage);
        _messageController.clear();
        _scrollToBottom();
      });

      // Send the message to Firestore
      await FirebaseFirestore.instance.collection('messages').add(messageMap);

      // Handle message sent successfully...

    } catch (e) {
      // Handle the error, e.g., show a snackbar
      if (kDebugMode) {
        print('Error when sending message: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send message. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // This method is used to delete a message
  void _deleteMessage(int uid) async {
    // Mark as deleted in local database
    Message? localMessage = messages.firstWhere((message) => message.uid == uid);
    Message deletedMessage = localMessage.copyWith(deleted: true); // Add a 'deleted' field to your Message class
    await DatabaseHelper.instance.update(deletedMessage.toMap());

    // Mark as deleted in Firestore
    FirebaseFirestore.instance.collection('messages').doc(uid.toString()).update({
      'deleted': true,
    });

    // Update UI
    setState(() {
      messages.removeWhere((message) => message.uid == uid);
    });

    // Show a snackbar message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Message deleted')),
    );
    }


// This method is used to edit a message
  void _editMessage(int uid, String newContent) async {
    // Update local database
    Message? localMessage = messages.firstWhere((message) => message.uid == uid);
    Message updatedMessage = localMessage.copyWith(content: newContent, edited: true, deleted: false);
    await DatabaseHelper.instance.update(updatedMessage.toMap());

    // Update Firestore
    FirebaseFirestore.instance.collection('messages').doc(uid.toString()).update({
      'content': newContent,
      'edited': true,
    });

    // Update UI
    setState(() {
      int index = messages.indexWhere((message) => message.uid == uid);
      if (index != -1) {
        messages[index] = updatedMessage;
      }
    });

    // Show a snackbar message
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message edited')),
    );
  }

  // This method is used to load messages from Firestore
  void _loadMessagesFromCloud() {
    String currentUserID = widget.userName; // Replace with the actual user identifier
    String friendID = widget.friendName; // Replace with the actual friend identifier

    FirebaseFirestore.instance
        .collection('messages')
        .where('receiver', isEqualTo: currentUserID)
        .where('sender', isEqualTo: friendID)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) async {
      for (var doc in snapshot.docs) {
        // Create a Message object from the document
        Message message = Message.fromMap({
          'id': doc.id, // Firestore document ID
          ...doc.data() as Map<String, dynamic>,
        });

        // Optionally, store the message in the local SQLite database
        await DatabaseHelper.instance.insert(message.toMap());
      }

      // Load the messages into the UI
      _loadMessagesFromLocal();
    });

    // Also listen for messages where the current user is the receiver
    FirebaseFirestore.instance
        .collection('messages')
        .where('sender', isEqualTo: currentUserID)
        .where('receiver', isEqualTo: friendID)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) async {
      for (var doc in snapshot.docs) {
        // Handle the received documents, similar to above
      }

      // Update the UI, similar to above

    });
  }

  void _loadMessagesFromLocal() async {
    List<Map<String, dynamic>> messageMaps = await DatabaseHelper.instance.queryAllRows();
    List<Message> localMessages = messageMaps.map((messageMap) => Message.fromMap(messageMap)).toList();
    setState(() {
      messages = localMessages;
    });
  }


  Widget _buildMessageItem(Message message) {
    bool isUserMessage = message.sender == widget.userName;
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
                _deleteMessage(message.uid! as int); // Assuming id is not null here
              },
            ),
          ],
        );
      },
    );
  }

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
                  _editMessage(message.uid! as int, editController.text.trim());
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
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
