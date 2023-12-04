import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../pages/new_home_page.dart';
import 'appuser.dart';
import 'message.dart';
import 'local_storage.dart';
import 'friends_add_friend_page.dart';
import 'friends_chat_page.dart';
import 'friends_profile_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'new_profile_page.dart';

class FriendListPage extends StatefulWidget {
  const FriendListPage({super.key});

  @override
  _FriendListPageState createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage> {
  // UID for the current user, obtained from Firebase Authentication
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  // Current user's status, defaulting to 'Online'
  String userStatus = 'Online';
  // Controller for the search text field
  final searchController = TextEditingController();
  // Boolean to track whether a search is active
  bool isSearching = false;
  // Results from the search
  List<AppUser> searchResults = [];
  // All messages for the current user
  List<Message> messages = [];
  // A complete list of all friends, unfiltered
  List<AppUser> allFriends = [];

  String _weatherDescription = 'Loading weather...';
  String _apiKey = '30c17ef9cc1cd4397ee2239f09434073'; // Replace with your actual API key from OpenWeatherMap
  String location = 'Oshawa'; // Example location


  // Fetches the current Firebase user and converts their data to an AppUser object
  Future<AppUser> _fetchCurrentUser() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      throw Exception('Not logged in');
    }
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).get();
    if (!userSnapshot.exists) {
      throw Exception('User does not exist in Firestore');
    }
    return AppUser.fromMap(userSnapshot.data() as Map<String, dynamic>, firebaseUser.uid);
  }

  // Stream that listens for changes in the friends list for the current user
  Stream<List<AppUser>> _friendsStream() {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('friends')
        .snapshots()
        .asyncMap((snapshot) async {
      List<AppUser> friendsList = [];
      for (var doc in snapshot.docs) {
        final friendUid = doc.data()['friendUid'];
        final friend = await _fetchFriendData(friendUid);
        if (friend != null) {
          friendsList.add(friend);
        }
      }
      return friendsList;
    });
  }

  // Fetches data for a friend based on their UID
  Future<AppUser?> _fetchFriendData(String friendUid) async {
    try {
      DocumentSnapshot friendDocSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(friendUid)
          .get();
      if (friendDocSnapshot.exists) {
        return AppUser.fromMap(friendDocSnapshot.data() as Map<String, dynamic>, friendDocSnapshot.id);
      } else {
        print('Friend user document does not exist.');
        return null;
      }
    } catch (e) {
      print('Error fetching friend data: $e');
      return null;
    }
  }

  // Deletes all chat history for the current user from Firestore
  Future<void> _deleteAllChatHistory() async {
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    // Delete messages sent by the current user
    QuerySnapshot sentMessages = await FirebaseFirestore.instance
        .collection('messages')
        .where('senderUid', isEqualTo: currentUserUid)
        .get();
    for (var doc in sentMessages.docs) {
      await doc.reference.delete();
    }
    // Delete messages received by the current user
    QuerySnapshot receivedMessages = await FirebaseFirestore.instance
        .collection('messages')
        .where('receiverUid', isEqualTo: currentUserUid)
        .get();
    for (var doc in receivedMessages.docs) {
      await doc.reference.delete();
    }
    // Provide feedback to the user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chat history deleted'),
        duration: Duration(seconds: 3)
      ),
    );

    setState(() {
      _buildFriendListWithLastMessage();
    });
  }

  // Local database helper instance for storing messages
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Backs up chat messages to local storage
  Future<void> backupChatToLocal() async {
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    for (var message in messages) {
      if (message.senderUid == currentUserUid || message.receiverUid == currentUserUid) {
        await _databaseHelper.insertMessage(message.toMap());
      }
    }
  }

  // Uploads local backup of chat messages to the cloud
  Future<void> uploadLocalBackupToCloud() async {
    // Fetch messages from local storage
    List<Message> localMessages = (await _databaseHelper.queryAllMessages()).cast<Message>();

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

  // Shows a bottom sheet with settings options
  void _showSettings() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete All Chat History on Cloud'),
              onTap: () async {
                Navigator.pop(context); // Dismiss the bottom sheet
                await _deleteAllChatHistory();
              },
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Back up All Chat History from Cloud'),
              onTap: () {
                // load logic
                Navigator.pop(context);
                backupChatToLocal();
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload),
              title: const Text('Up load All Chat History from Local'),
              onTap: () {
                // load logic
                Navigator.pop(context);
                uploadLocalBackupToCloud();
              },
            ),
            ListTile(
              leading: const Icon(Icons.arrow_back),
              title: const Text('Back to Home Page'),
              onTap: () {
                // This will cause the homepage AppBar not to be displayed WAIT FOR FIX
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewHomePage()), // Go to the home page
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Builds a list of friends along with the last message sent or received
  Widget _buildFriendListWithLastMessage() {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    List<AppUser> friendsToDisplay = isSearching ? searchResults : allFriends;
    return StreamBuilder<List<AppUser>>(
      stream: _friendsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          print('Error loading friends: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error.toString()}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No friends yet'));
        }

        List<AppUser> friendsList = snapshot.data!;
        print('Building list for ${friendsList.length} friends');

        return ListView.builder(
          itemCount: friendsToDisplay.length,
          itemBuilder: (context, index) {
            AppUser friend = friendsList[index];
            String friendFullName = "${friend.firstName} ${friend.middleName ?? ''} ${friend.lastName}".trim();
            return FutureBuilder<String>(
              future: _getLastMessage(currentUserId, friend.uid, friendFullName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListTile(
                    leading: const Icon(Icons.account_circle, size: 40), // TODO: Replace with friend's profile picture
                    title: Text('$friendFullName - ${friend.status}'),
                    subtitle: const Text('Loading...'),
                    trailing: Icon(Icons.circle, size: 15, color: getStatusColor(friend.status)),
                  );
                }
                if (snapshot.hasError) {
                  return ListTile(
                    leading: const Icon(Icons.account_circle, size: 40),
                    title: Text('$friendFullName - ${friend.status}'),
                    subtitle: Text('Error: ${snapshot.error}'),
                  );
                }
                String lastMessage = snapshot.data ?? 'No messages';
                return ListTile(
                  leading: const Icon(Icons.account_circle, size: 40),
                  title: Text('$friendFullName - ${friend.status}'),
                  subtitle: Text(lastMessage),
                  trailing: Icon(Icons.circle, size: 15, color: getStatusColor(friend.status)),
                  onTap: () async {
                    final AppUser user = await _fetchCurrentUser();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          userName: user.getFullName(),
                          friendName: friend.getFullName(),
                          friendStatus: friend.status,
                          friendUid: friend.uid,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  // Refreshes the friend list UI
  void _refreshFriendsList() {
    _friendsStream().first.then((friendsList) {
      setState(() {
        allFriends = friendsList;
        if (!isSearching) {
          searchResults = allFriends;
        }
      });
    });
  }

  late Future<AppUser> _currentUserFuture;

  // Initializes the state and fetches the current user and friend list
  @override
  void initState() {
    super.initState();
    // Fetches the current user and stores it in a Future for later use
    _currentUserFuture = _fetchCurrentUser();
    // Fetch the initial list of friends and assign it to allFriends
    _friendsStream().first.then((friendsList) {
      setState(() {
        allFriends = friendsList;
      });
    });
    _fetchWeather();
  }

  // Fetches weather data from the Weatherstack API
  Future<Map<String, dynamic>> fetchWeather(String apiKey, String location) async {
    String url = 'http://api.weatherstack.com/current?access_key=$apiKey&query=$location';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      if (responseJson['error'] != null) {
        throw Exception('Weather API error: ${responseJson['error']['info']}');
      }
      return responseJson;
    } else {
      throw Exception('Failed to load weather data with status code: ${response.statusCode}');
    }
  }

  // Fetches the weather description and updates the UI
  void _fetchWeather() async {
    try {
      // Make sure to use https if you're on a paid plan for Weatherstack
      final weatherData = await fetchWeather(_apiKey, location);
      setState(() {
        _weatherDescription = '${weatherData['current']['temperature']}°C, ${weatherData['current']['weather_descriptions'][0]}';
      });
    } catch (e) {
      setState(() {
        _weatherDescription = 'Weather unavailable';
      });
      if (kDebugMode) {
        print('Error fetching weather: $e');
      }
    }
  }

  // Function to search for friends based on a query
  // void _searchFriend(String searchQuery) async {
  //   if (searchQuery.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Search query cannot be empty'),
  //         duration: Duration(seconds: 3),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return;
  //   }
  //
  //   final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  //   final querySnapshot = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(currentUserId)
  //       .collection('friends')
  //       .where('firstName', isEqualTo: searchQuery)
  //       .get();
  //
  //   final List<AppUser> users = querySnapshot.docs
  //       .map((doc) => AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id))
  //       .where((user) => user.firstName.toLowerCase().contains(searchQuery.toLowerCase()))
  //       .toList();
  //
  //   // setState(() {
  //   //   searchResults = users;
  //   // });
  //   setState(() {
  //     // Update searchResults with users if found, or an empty list if no users are found
  //     searchResults = users.isNotEmpty ? users : [];
  //   });
  // }
  void _searchFriend(String searchQuery) async {
    print("Search query: $searchQuery"); // Debug: Print the search query

    if (searchQuery.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Search query cannot be empty'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
      print("Search query is empty"); // Debug: Print when search query is empty
      return;
    }

    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    print("Current user ID: $currentUserId"); // Debug: Print the current user ID

    // Step 1: Retrieve friend UIDs
    final friendUidsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('friends')
        .get();

    List<String> friendUids = friendUidsSnapshot.docs
        .map((doc) => doc.id) // Assuming the friend UID is the document ID
        .toList();

    print("Friend UIDs: $friendUids"); // Debug: Print the list of friend UIDs

    // Step 2: Retrieve user details and filter
    List<AppUser> users = [];
    for (String uid in friendUids) {
      var userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        AppUser user = AppUser.fromMap(userDoc.data() as Map<String, dynamic>, userDoc.id);
        print("User details: ${user.toString()}"); // Enhance this line to print more details
        if (user.firstName.toLowerCase().contains(searchQuery.toLowerCase())) {
          users.add(user);
        }
      }
    }

    print("Filtered users: $users"); // Debug: Print the list of filtered users

    if (mounted) {
      setState(() {
        searchResults = users;
        isSearching = true;
      });
    }

    print("Search results updated"); // Debug: Print when search results are updated
  }

  // Dialog to allow searching for friends
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Search Friends'),
          content: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: "Enter a friend's firstname",
            ),
            onSubmitted: (value) {
              // Implement the search functionality
              _searchFriend(value);
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Reset'),
              onPressed: () {
                // Reset the search field
                searchController.clear();
                // Reset the search results
                setState(() {
                  searchResults = allFriends;
                  isSearching = false;
                });
              },
            ),
            TextButton(
              child: const Text('Search'),
              onPressed: () {
                // Implement the search functionality
                _searchFriend(searchController.text);
              },
            ),
          ],
        );
      },
    );
  }

  // Filters the friends list based on status
  void _filterFriendsByStatus(String status) {
    if (status == 'All') {
      // Display all friends if no filter is applied.
      setState(() {
        searchResults = allFriends;
        isSearching = false;
      });
    } else {
      // Filter the friends locally based on the status.
      setState(() {
        searchResults = allFriends.where((friend) => friend.status == status).toList();
        isSearching = true;
      });
    }
  }

  // Dialog to allow filtering friends by status
  void _showFilterDialog() {
    // Initial filter selection
    String selectedStatus = 'All';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Filter Friends'),
              content: DropdownButtonFormField<String>(
                value: selectedStatus,
                items: ['All', 'Online', 'Busy', 'Offline']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  // This updates the state inside the dialog
                  setDialogState(() {
                    selectedStatus = newValue!;
                  });
                },
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('Reset'),
                  onPressed: () {
                    // Reset the filter inside the dialog
                    setDialogState(() {
                      selectedStatus = 'All';
                    });
                    // Apply the reset filter
                    _filterFriendsByStatus('All');
                  },
                ),
                TextButton(
                  child: const Text('Apply'),
                  onPressed: () {
                    // Close the dialog and apply the selected filter
                    Navigator.of(context).pop();
                    _filterFriendsByStatus(selectedStatus);
                  },
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      // This ensures that the UI updates happen after the dialog is closed.
      setState(() {});
    });
  }

  // Changes the user's status and updates Firestore
  void _changeUserStatus(String status) {
    setState(() {
      userStatus = status;
    });
    _updateUserStatus(status); // Synchronize status with the cloud
  }

  void _updateUserStatus(String newStatus) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(currentUserId).update({
      'status': newStatus,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status updated to $newStatus')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update status')),
      );
    });
  }

  // Dialog to change the current user's status
  void _showStatusChangeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.circle, color: getStatusColor('Online')),
                title: const Text('Online'),
                onTap: () {
                  _changeUserStatus('Online');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.circle, color: getStatusColor('Busy')),
                title: const Text('Busy'),
                onTap: () {
                  _changeUserStatus('Busy');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.circle, color: getStatusColor('Offline')),
                title: const Text('Invisible'),
                onTap: () {
                  _changeUserStatus('Offline');
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Fetches the last message exchanged between the current user and a friend
  Future<String> _getLastMessage(String currentUserId, String friendUid, String friendFullName) async {
    print('Debug: Starting _getLastMessage');
    print('Debug: Current User ID: $currentUserId');
    print('Debug: Friend User ID: $friendUid');
    print('Debug: Friend Full Name: $friendFullName');

    try {
      // Perform the queries
      final querySnapshotSender = await FirebaseFirestore.instance
          .collection('messages')
          .where('senderUid', isEqualTo: currentUserId)
          .where('receiverUid', isEqualTo: friendUid)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      final querySnapshotReceiver = await FirebaseFirestore.instance
          .collection('messages')
          .where('senderUid', isEqualTo: friendUid)
          .where('receiverUid', isEqualTo: currentUserId)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      // Log the results of the queries
      print('Debug: Sender querySnapshot data: ${querySnapshotSender.docs}');
      print('Debug: Receiver querySnapshot data: ${querySnapshotReceiver.docs}');
      print('Debug: Sender messages count: ${querySnapshotSender.docs.length}');
      print('Debug: Receiver messages count: ${querySnapshotReceiver.docs.length}');

      // Determine which message is the latest
      DocumentSnapshot? latestMessageSnapshot;
      if (querySnapshotSender.docs.isNotEmpty && querySnapshotReceiver.docs.isNotEmpty) {
        final senderTimestamp = querySnapshotSender.docs.first.get('timestamp') as Timestamp;
        final receiverTimestamp = querySnapshotReceiver.docs.first.get('timestamp') as Timestamp;
        latestMessageSnapshot = senderTimestamp.compareTo(receiverTimestamp) > 0 ? querySnapshotSender.docs.first : querySnapshotReceiver.docs.first;
      } else if (querySnapshotSender.docs.isNotEmpty) {
        latestMessageSnapshot = querySnapshotSender.docs.first;
      } else if (querySnapshotReceiver.docs.isNotEmpty) {
        latestMessageSnapshot = querySnapshotReceiver.docs.first;
      }

      // If no latest message, return 'No messages'
      if (latestMessageSnapshot == null) {
        print('Debug: No messages found');
        return 'No messages';
      }

      final messageData = latestMessageSnapshot.data() as Map<String, dynamic>;
      final messageContent = messageData['content'] ?? 'No message content';
      final messageSenderUid = messageData['senderUid'] ?? 'No sender UID';
      final messagePrefix = messageSenderUid == currentUserId ? 'Me: ' : '$friendFullName: ';
      final lastMessage = '$messagePrefix$messageContent';
      print('Debug: Last message: $lastMessage');
      return lastMessage;
    } catch (e) {
      print('An error occurred while fetching the last message: $e');
      return 'Error fetching messages';
    }
  }

  // Builds the floating action buttons for search and settings
  Widget _buildFloatingActionButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FloatingActionButton(
          onPressed: _showSearchDialog,
          mini: true,
          child: const Icon(Icons.search),
        ),
        const SizedBox(height: 10), // Spacing between the buttons
        FloatingActionButton(
          onPressed: _showFilterDialog,
          mini: true,
          child: const Icon(Icons.filter_list),
        ),
        const SizedBox(height: 10), // Spacing between the buttons
        FloatingActionButton(
          onPressed: () {
            _showSettings();
          },
          mini: true,
          child: const Icon(Icons.settings),
        ),
      ],
    );
  }

  // Returns a color based on the user's status
  Color getStatusColor(String status) {
    switch (status) {
      case 'Online':
        return Colors.greenAccent;
      case 'Busy':
        return Colors.red;
      case 'Offline':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  // Builds the entire UI for the FriendListPage
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.account_circle, size: 45),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NewUserProfilePage(userId: FirebaseAuth.instance.currentUser!.uid),
              ),
            );
          },
        ),
        title: const Text('Friend List'),
        actions: <Widget>[
          Center(child: Text(_weatherDescription)),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddFriendPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.circle, size: 15, color: getStatusColor(userStatus)),
            onPressed: _showStatusChangeDialog,
          ),
        ],
      ),
      body:
      _buildFriendListWithLastMessage(),
      floatingActionButton: _buildFloatingActionButtons(),
    );
  }
}
