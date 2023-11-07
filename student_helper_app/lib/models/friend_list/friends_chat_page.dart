import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'local_storage.dart';
import 'message.dart';

class ChatPage extends StatefulWidget {
  final String friendName;
  final String friendStatus;

  const ChatPage({super.key,  required this.friendName, required this.friendStatus});

  @override
  // ignore: library_private_types_in_public_api
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Message> messages = []; // Make sure to use the Message model

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
    final List<Map<String, dynamic>> messageMaps = await DatabaseHelper.instance.queryMessages('user', widget.friendName);
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
          ],
        );
      },
    );
  }

  // Method to delete all chat history with the current associate
  Future<void> _deleteChatHistory() async {
    await DatabaseHelper.instance.deleteConversation('user', widget.friendName);
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
      // If the input is empty, do nothing or you can show a warning to the user
      return;
    }

    try {
      // Create a new message object
      final Message message = Message(
        timestamp: DateTime.now(),
        sender: 'user', // In a real application, replace with the actual user identifier
        receiver: widget.friendName, // The friend's name or identifier
        content: content, // The user input is set as the content
        edited: false,
      );

      // Insert the message into the database and get the auto-generated ID
      final int id = await DatabaseHelper.instance.insert(message.toMap());

      // Update the UI on the main thread after the message is inserted
      setState(() {
        // Add the new message to the messages list
        messages.insert(0, message.copyWith(id: id)); // Insert at the beginning of the list
        // Clear the input field for new message
        _messageController.clear();
      });
    } catch (e) {
      // Log the error or use a developer tool to help with debugging
      if (kDebugMode) {
        print('Error when sending message: $e');
      }
      // Optionally, show an error message to the user
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send message. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // This method is used to delete a message
  void _deleteMessage(int id) async {
    await DatabaseHelper.instance.delete(id);
    setState(() {
      messages.removeWhere((message) => message.id == id);
    });
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message deleted'),
        duration: Duration(seconds: 2),
      ),
    );
  }

// This method is used to edit a message
  void _editMessage(int id, String newContent) async {
    final int index = messages.indexWhere((message) => message.id == id);
    if (index != -1) {
      final Message updatedMessage = messages[index].copyWith(
        content: newContent,
        edited: true,
      );
      await DatabaseHelper.instance.update(updatedMessage.toMap());
      setState(() {
        messages[index] = updatedMessage;
      });
    }
  }

  Widget _buildMessageItem(Message message) {
    bool isUserMessage = message.sender == 'user';
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
                // Implement edit logic
                Navigator.pop(context);
                _showEditDialog(message);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                // Implement delete logic
                Navigator.pop(context);
                _deleteMessage(message.id!); // Assuming id is not null here
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
                  _editMessage(message.id!, editController.text.trim());
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
                        // Implement sending image or video
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
