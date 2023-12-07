import 'package:async/async.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:student_helper_project/pages/friend_list/friends_list_home_page.dart';
import 'package:student_helper_project/pages/new_home_page.dart';

import '../../models/friend_list/local_storage.dart';
import '../../models/friend_list/message.dart';

// ChatPage widget allows users to chat with a specific friend.
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
  // Controllers for managing message input and scrolling the chat view.
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();


  // List to store and display messages.
  List<Message> messages = [];

  // Variables to customize chat background.
  Color _backgroundColor = Colors.white;
  bool _darkmode = false;
  final ImagePicker _picker = ImagePicker();
  String? _backgroundImage;

  // Initialize state, set up scroll listener and load messages from the cloud.
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadMessagesFromCloud();
  }

  // Listens to the scroll events to enable auto-scrolling functionality.
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

  // Scrolls the chat to the latest message.
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // Loads messages from Firebase Firestore, combining both sent and received messages.
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
          .map((doc) => Message.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      setState(() {
        messages = newMessages;
      });
    });
  }

  // Shows a modal bottom sheet for chat settings.
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

  // Deletes the chat history between the user and their friend from Firestore.
  Future<void> _deleteChatHistory() async {
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    String friendUid = widget.friendUid;

    try {
      // Fetch all messages between the current user and the friend
      QuerySnapshot chatHistory = await FirebaseFirestore.instance
          .collection('messages')
          .where('senderUid', isEqualTo: currentUserUid)
          .where('receiverUid', isEqualTo: friendUid)
          .get();

      // Delete each message
      for (var doc in chatHistory.docs) {
        await doc.reference.delete();
      }

      // Update UI
      setState(() {
        messages.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chat history deleted successfully')),
      );
    } catch (e) {
      print("Error deleting chat history: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete chat history')),
      );
    }
  }


  // Shows a modal bottom sheet to allow the user to change the chat background.
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
                  _darkmode = false;
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
                  _backgroundColor = Colors.black;
                  _darkmode = true;
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

  // Handles the image upload process.
  // TODO: Still have to fix
  void _uploadImage() async {
    try {
      // Pick an image
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      // Check if an image is selected
      if (image == null) return;

      // Create a file from the picked image path
      File file = File(image.path);

      // Define the destination path in Firebase Storage
      String filePath = 'chat_backgrounds/${DateTime.now().millisecondsSinceEpoch}_${image.name}';
      Reference ref = FirebaseStorage.instance.ref().child(filePath);

      // Upload the file
      await ref.putFile(file);

      // Get the download URL
      String downloadUrl = await ref.getDownloadURL();

      // Update the state to reflect the new background image
      setState(() {
        _backgroundImage = downloadUrl;
      });
    } catch (e) {
      // Handle exceptions
      print('Error occurred while picking or uploading image: $e');
    }
  }

  // Sends a new message to the Firestore collection.
  void _sendMessage({String? text, String? mediaUrl}) async {
    // Use provided 'text' or fallback to text from the controller
    final String content = text ?? _messageController.text.trim();

    // Check if both content and mediaUrl are empty, then return
    if (content.isEmpty && mediaUrl == null) {
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
      mediaUrl: mediaUrl,
    );

    try {
      await FirebaseFirestore.instance.collection('messages').add(newMessage.toMap());
      setState(() {
        messages.add(newMessage);
        _messageController.clear();
        _scrollToBottom();
      });
    } catch (e) {
      // Error handling for message send failure
    }
  }

  Future<bool> requestPermissions() async {
    print("Requesting camera and storage permissions");

    var cameraStatus = await Permission.camera.status;
    var storageStatus = await Permission.photos.status;

    print("Initial Camera Permission Status: ${cameraStatus.isGranted}");
    print("Initial Storage Permission Status: ${storageStatus.isGranted}");

    if (!cameraStatus.isGranted) {
      print("Requesting camera permission");
      cameraStatus = await Permission.camera.request();
      print("Camera Permission Status After Request: ${cameraStatus.isGranted}");
    }

    if (!storageStatus.isGranted) {
      print("Requesting storage permission");
      storageStatus = await Permission.photos.request();
      print("Storage Permission Status After Request: ${storageStatus.isGranted}");
    }

    if (!cameraStatus.isGranted || !storageStatus.isGranted) {
      print("Not all permissions granted");
      return false;
    }

    print("All required permissions granted");
    return true;
  }

  // method to pick and send image/media
  Future<void> _pickAndSendMedia() async {
    print("Initiating media pick process");

    bool permissionsGranted = await requestPermissions();

    if (!permissionsGranted) {
      print("Required permissions are not granted");
      return;
    }

    print("Permissions granted, proceeding to pick media");

    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _uploadFile(File(pickedFile.path));
    }
  }

  Future<void> _uploadFile(File file) async {
    String fileName = 'chat_media/${DateTime.now().millisecondsSinceEpoch}_${p.basename(file.path)}';
    Reference storageReference = FirebaseStorage.instance.ref().child(fileName);

    try {
      // Upload file
      await storageReference.putFile(file);
      // Get file URL
      String fileUrl = await storageReference.getDownloadURL();
      // Send message with media URL
      _sendMessage(mediaUrl: fileUrl);
    } catch (e) {
      // Handle upload errors
    }
  }

  // Deletes a single message identified by its messageId.
  void _deleteMessage(String messageId) async {
    try {
      // Directly delete the message from Firestore
      await FirebaseFirestore.instance.collection('messages').doc(messageId).delete();

      // Update UI
      setState(() {
        messages.removeWhere((message) => message.uid == messageId); // Ensure this uses the property that stores the document ID
      });

      // Show a snackbar message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Message deleted')),
      );
    } catch (e) {
      print('Error deleting message: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete message')),
      );
    }
  }


  // Allows the user to edit a message.
  void _editMessage(String messageId, String newContent) async {
    // Update Firestore
    await FirebaseFirestore.instance.collection('messages').doc(messageId).update({
      'content': newContent,
      'edited': true,
    });

    // Update the local message list
    int index = messages.indexWhere((message) => message.uid == messageId); // Use a field that holds the document ID
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

  // Constructs a UI element for each message.
  Widget _buildMessageItem(Message message) {
    bool isUserMessage = message.senderUid == FirebaseAuth.instance.currentUser!.uid;
    return Row(
      mainAxisAlignment: isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isUserMessage) ...[
          Icon(Icons.account_circle, color: _darkmode ? Colors.white : Colors.black), // Friend's icon
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
          Icon(Icons.account_circle, color: _darkmode ? Colors.white : Colors.black), // User's icon
        ],
      ],
    );
  }

  // Shows options to edit or delete a message.
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
                Navigator.pop(context); // Close the modal bottom sheet
                _deleteMessage(message.uid!); // Use the document ID
              },
            ),
          ],
        );
      },
    );
  }

  // Displays a dialog for editing the content of a message.
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
              // When saving, pass the messageId to _editMessage
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

  // Methods for backing up and uploading chat history related to a specific friend.
  Future<void> backupChatToLocalForSpecificFriend(String friendUid) async {
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    print("Debug: Backing up chat to local for friend UID: $friendUid");

    try {
      int messageCount = 0;
      for (var message in messages) {
        if ((message.senderUid == currentUserUid || message.receiverUid == currentUserUid) &&
            (message.senderUid == friendUid || message.receiverUid == friendUid)) {
          await _databaseHelper.insertMessage(message.toMap());
          messageCount++;
        }
      }
      print("Debug: Total messages backed up: $messageCount");
    } catch (e) {
      print("Error during local backup: $e");
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chat history backed up to local database')),
    );
  }



  // Method to upload local backup to the cloud, only for messages between the current user and the specified friend
  Future<void> uploadLocalBackupToCloudForSpecificFriend(String friendUid) async {
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    print("Debug: Uploading local backup to cloud for friend UID: $friendUid");

    try {
      List<Message> localMessages = await _databaseHelper.queryMessagesBetween(currentUserUid, friendUid);
      print("Debug: Number of local messages found: ${localMessages.length}");

      int uploadCount = 0;
      for (var localMessage in localMessages) {
        var existingDoc = await FirebaseFirestore.instance.collection('messages')
            .doc(localMessage.uid)
            .get();

        if (!existingDoc.exists) {
          await FirebaseFirestore.instance.collection('messages')
              .doc(localMessage.uid)
              .set(localMessage.toMap());
          uploadCount++;
        }
      }
      print("Debug: Number of messages uploaded to cloud: $uploadCount");
    } catch (e) {
      print("Error during cloud upload: $e");
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Local backup uploaded to cloud')),
    );
  }


  // Disposes controllers when the widget is disposed.
  @override
  void dispose() {
    // Dispose controllers
    _messageController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  // Builds the chat page UI.
  @override
  Widget build(BuildContext context) {
    // The layout includes an AppBar, a list to display messages, and an input field to type new messages.
    // FloatingActionButton is used for additional chat-related actions.
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NewHomePage()));
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
                  // If you want to messages list is reversed, use this:
                  // Message message = messages[index];
                  // Otherwise, if you want to list is in chronological order, use this:
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
                      icon: Icon(Icons.photo, color: _darkmode ? Colors.white : Colors.black,),
                      onPressed: () {
                        // sending image or video
                        _pickAndSendMedia();
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                              color: _darkmode ? Colors.black : Colors.black
                          ),
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
                      icon: Icon(Icons.send,
                          color: _darkmode ? Colors.white : Colors.black),
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
