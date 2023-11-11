import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'appuser.dart';

// This page allows users to search for other users by their student number and manage friend requests.
class AddFriendPage extends StatefulWidget {
  @override
  _AddFriendPageState createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  // Text editing controller for the search field.
  final TextEditingController _searchController = TextEditingController();
  // The UID of the currently logged-in user.
  final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  // List of users that result from a search query.
  List<AppUser> searchResults = [];
  // Plugin instance for local notifications.
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Initializes the page's state.
  @override
  void initState() {
    super.initState();
    // Additional initialization if required.
  }

  // Searches for users based on the input student number.
  void _search() async {
    final queryText = _searchController.text;
    if (queryText.isNotEmpty) {
      // Fetch users where the 'studentNumber' field matches the query text.
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('studentNumber', isEqualTo: queryText)
          .get();

      // Process each user document to determine friendship and request status.
      List<AppUser> users = await Future.wait(querySnapshot.docs.map((doc) async {
        var user = AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        user.isFriend = await _isAlreadyFriend(user.uid);
        user.isRequested = await _isAlreadyRequested(user.uid);
        return user;
      }).toList());

      // Update the state to reflect the new search results.
      setState(() {
        searchResults = users;
      });
    }
  }

  // Checks if a user is already a friend.
  Future<bool> _isAlreadyFriend(String friendUid) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final friendDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('friends')
        .doc(friendUid)
        .get();
    return friendDoc.exists;
  }

  // Accepts a friend request.
  void _acceptFriendRequest(String requestId, String fromUserUid) async {

    // Update the request status to 'accepted' and add users to each other's friends collection.
    await FirebaseFirestore.instance.collection('friendRequests').doc(requestId).update({
      'status': 'accepted',
    });

    // Add the friend UID to the current user's friends list
    await FirebaseFirestore.instance.collection('users').doc(currentUserUid).collection('friends').doc(fromUserUid).set({
      'friendUid': fromUserUid,
      'addedOn': FieldValue.serverTimestamp(),
    });

    // Also update the friend's list for the other user, if necessary
    await FirebaseFirestore.instance.collection('users').doc(fromUserUid).collection('friends').doc(currentUserUid).set({
      'friendUid': currentUserUid,
      'addedOn': FieldValue.serverTimestamp(),
    });
  }

  // Rejects a friend request.
  void _rejectFriendRequest(String requestId) async {
    // Update the request status to 'rejected'.
    await FirebaseFirestore.instance.collection('friendRequests').doc(requestId).update({
      'status': 'rejected',
    });

    // Provide feedback to the user that the request has been rejected
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Rejected friend request'), backgroundColor: Colors.lime));
  }

  // Sends a friend request.
  void _sendFriendRequest(String currentUserUid, String friendUid) async {
    // Create a new friend request document in Firestore with status 'pending'.
    await FirebaseFirestore.instance.collection('friendRequests').add({
      'fromUid': currentUserUid,
      'toUid': friendUid,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Update the UI to reflect the sent request
    setState(() {
      searchResults.firstWhere((user) => user.uid == friendUid).isRequested = true;
    });
  }

  // Checks if a friend request has already been sent to a user.
  Future<bool> _isAlreadyRequested(String friendUid) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final requests = await FirebaseFirestore.instance
        .collection('friendRequests')
        .where('fromUid', isEqualTo: currentUserId)
        .where('toUid', isEqualTo: friendUid)
        .where('status', isEqualTo: 'pending')
        .get();
    return requests.docs.isNotEmpty;
  }

  // Stream to listen for incoming friend requests.
  Stream<QuerySnapshot> _friendRequestsStream() {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    // Listen to friend requests addressed to the current user with status 'pending'.
    return FirebaseFirestore.instance
        .collection('friendRequests')
        .where('toUid', isEqualTo: currentUserId)
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }

  // Builds a list of incoming friend requests.
  Widget _buildFriendRequests() {
    return StreamBuilder<QuerySnapshot>(
      stream: _friendRequestsStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No friend requests'));
        }

        // Map the documents to widgets
        List<Widget> friendRequestWidgets = [];
        for (var document in snapshot.data!.docs) {
          Map<String, dynamic> request = document.data() as Map<String, dynamic>;

          // Use a FutureBuilder to fetch and display the sender's name
          Widget tile = FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(request['fromUid']).get(),
            builder: (context, senderSnapshot) {
              if (senderSnapshot.connectionState == ConnectionState.waiting) {
                return ListTile(
                  leading: Icon(Icons.person_add),
                  title: Text('Loading sender info...'),
                );
              }
              if (senderSnapshot.hasError) {
                return ListTile(
                  leading: Icon(Icons.person_add),
                  title: Text('Error loading sender info'),
                );
              }
              if (!senderSnapshot.hasData) {
                return ListTile(
                  leading: Icon(Icons.person_add),
                  title: Text('Sender info not found'),
                );
              }
              var senderData = senderSnapshot.data!.data() as Map<String, dynamic>;
              var senderName = senderData['firstName'] ?? 'Unknown';

              return ListTile(
                leading: Icon(Icons.person_add),
                title: Text('Friend Request from: $senderName'),
                subtitle: Text('Received at: ${request['timestamp']?.toDate().toString() ?? 'Unknown time'}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      child: Text('Accept'),
                      onPressed: () => _acceptFriendRequest(document.id, request['fromUid']),
                    ),
                    TextButton(
                      child: Text('Reject'),
                      onPressed: () => _rejectFriendRequest(document.id),
                    ),
                  ],
                ),
              );
            },
          );

          friendRequestWidgets.add(tile);
        }

        return ListView(
          children: friendRequestWidgets,
        );
      },
    );
  }

  // Builds the main widget for the Add Friend page.
  @override
  Widget build(BuildContext context) {
    // The UI includes a search box, a list of search results, and a list of friend requests.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Friend'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search box
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by student number',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _search,
                ),
              ),
              onSubmitted: (value) => _search(),
            ),
            const SizedBox(height: 20),
            // Results from search
            Expanded(
              flex: 2, // Adjust the flex factor to control how much space this part should take
              child: searchResults.isNotEmpty
                  ? ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  var result = searchResults[index];
                  return ListTile(
                    leading: Icon(Icons.person),
                    title: Text('${result.firstName} ${result.middleName ?? ""} ${result.lastName}'),
                    subtitle: Text(result.studentNumber),
                    trailing: ElevatedButton(
                      child: const Text('Add'),
                      onPressed: (result.isFriend || result.isRequested) ? null : () {
                        _sendFriendRequest(currentUserUid, result.uid);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: (result.isFriend || result.isRequested) ? Colors.grey : Colors.blue,
                      ),
                    ),
                  );
                },
              )
                  : const Center(child: Text('No results')),
            ),
            const SizedBox(height: 20),
            Expanded(
              flex: 1, // Adjust the flex factor to control how much space this part should take
              child: _buildFriendRequests(), // This will display the friend requests
            ),
          ],
        ),
      ),
    );
  }
}