import 'package:flutter/material.dart';
import 'local_storage.dart';
import 'message.dart';

class ChatPage extends StatefulWidget {
  final String friendName;
  final String friendStatus;

  ChatPage({required this.friendName, required this.friendStatus});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  List<Message> messages = []; // Make sure to use the Message model

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() async {
    final List<Map<String, dynamic>> messageMaps = await DatabaseHelper.instance.queryMessages('user', widget.friendName);
    final List<Message> loadedMessages = messageMaps.map((messageMap) => Message.fromMap(messageMap)).toList();
    setState(() {
      messages = loadedMessages;
    });
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
      print('Error when sending message: $e');
      // Optionally, show an error message to the user
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
                // TODO: Implement edit logic
                Navigator.pop(context);
                _showEditDialog(message);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                // TODO: Implement delete logic
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
    TextEditingController _editController = TextEditingController(text: message.content);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Message'),
          content: TextField(
            controller: _editController,
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
                if (_editController.text.trim().isNotEmpty) {
                  _editMessage(message.id!, _editController.text.trim());
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
  Widget build(BuildContext context) {
    return Scaffold(
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
            onPressed: () {
              // Settings or delete chat history
              // ...
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child:
            ListView.builder(
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
    );
  }
}
