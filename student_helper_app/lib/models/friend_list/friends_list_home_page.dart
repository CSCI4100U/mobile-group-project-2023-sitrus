import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../firebase_options.dart';
import 'appuser.dart';
import 'friends_add_friend_page.dart';
import 'friends_chat_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'friend_login_page.dart';
import 'friends_profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



// for test only
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform, );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Friend List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user == null) {
              return LoginPage();
            }
            return const FriendListPage(); // Assume you have a HomePage widget
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}

class FriendListPage extends StatefulWidget {
  const FriendListPage({super.key});

  @override
  _FriendListPageState createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage> {

  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  String userStatus = 'Online';
  final searchController = TextEditingController();
  bool isSearching = false;
  List<AppUser> searchResults = [];

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

  Widget _buildFriendListWithLastMessage() {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
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
          itemCount: friendsList.length,
          itemBuilder: (context, index) {
            AppUser friend = friendsList[index];
            String friendFullName = "${friend.firstName} ${friend.middleName ?? ''} ${friend.lastName}".trim();
            return FutureBuilder<String>(
              future: _getLastMessage(currentUserId, friend.uid, friendFullName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListTile(
                    leading: const Icon(Icons.account_circle, size: 40), // TODO: Replace with friend's profile picture
                    title: Text('${friendFullName} - ${friend.status}'),
                    subtitle: const Text('Loading...'),
                    trailing: Icon(Icons.circle, size: 15, color: getStatusColor(friend.status)),
                  );
                }
                if (snapshot.hasError) {
                  return ListTile(
                    leading: const Icon(Icons.account_circle, size: 40),
                    title: Text('${friendFullName} - ${friend.status}'),
                    subtitle: Text('Error: ${snapshot.error}'),
                  );
                }
                String lastMessage = snapshot.data ?? 'No messages';
                return ListTile(
                  leading: const Icon(Icons.account_circle, size: 40),
                  title: Text('${friendFullName} - ${friend.status}'),
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



late Future<AppUser> _currentUserFuture;

  @override
  void initState() {
    super.initState();
    _currentUserFuture = _fetchCurrentUser();
    // Initial state setup if necessary
  }

  void _searchFriend(String searchQuery) async {
    if (searchQuery.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Search query cannot be empty'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('friends')
        .where('firstName', isEqualTo: searchQuery)
        .get();

    final List<AppUser> users = querySnapshot.docs
        .map((doc) => AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .where((user) => user.firstName.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    setState(() {
      searchResults = users;
    });
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Search Friends'),
          content: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: "Enter a friend's name",
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

  void _filterFriendsByStatus(String status) async {
    if (status == 'All') {
      setState(() {
        isSearching = false; // Display all friends if no filter is applied
      });
      return;
    }

    // Display a loading indicator while filtering
    setState(() {
      isSearching = true; // Signal that we're in search/filter mode
    });

    // Filter the friends list by status
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('friends')
        .where('status', isEqualTo: status)
        .get()
        .then((querySnapshot) {
      final List<AppUser> filteredFriends = querySnapshot.docs
          .map((doc) => AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      setState(() {
        searchResults = filteredFriends; // Update the searchResults with the filtered list
      });
    });
  }

  void _showFilterDialog() {
    String selectedStatus = 'All'; // This will be the current filter selection

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                  setState(() {
                    selectedStatus = newValue!;
                    isSearching = false; // Reset searching when filtering
                  });
                  _filterFriendsByStatus(newValue!);
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
                    setState(() {
                      selectedStatus = 'All';
                      isSearching = false; // Reset searching when resetting filter
                    });
                    _filterFriendsByStatus('All');
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

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
            // TODO: Add settings functionality
          },
          mini: true,
          child: const Icon(Icons.settings),
        ),
      ],
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.account_circle, size: 45),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UserProfilePage(userId: FirebaseAuth.instance.currentUser!.uid),
              ),
            );
          },
        ),
        title: const Text('Friend List'),
        actions: <Widget>[
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

