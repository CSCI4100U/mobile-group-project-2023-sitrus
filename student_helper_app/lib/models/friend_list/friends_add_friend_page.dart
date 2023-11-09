import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'appuser.dart';

class AddFriendPage extends StatefulWidget {
  @override
  _AddFriendPageState createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  final TextEditingController _searchController = TextEditingController();
  currentUserId() {
    return FirebaseAuth.instance.currentUser!.uid;
  }
  resultId() {
    return FirebaseFirestore.instance.collection('users').doc().id;
  }
  List<AppUser> searchResults = []; // Adjusted to use a User model instead of a map

  // This is the mock function to simulate the search process
  // void _search() {
  //   // Replace this with the actual search logic
  //   setState(() {
  //     searchResults = [
  //       {
  //         'icon': Icons.person,
  //         'name': 'John Doe',
  //         'studentNumber': '123456',
  //         'isFriend': false,
  //       },
  //       {
  //         'icon': Icons.person,
  //         'name': 'Jane Smith',
  //         'studentNumber': '654321',
  //         'isFriend': true, // This user is already a friend
  //       },
  //       // Add more mock results as needed for testing
  //     ];
  //   });
  // }
  void _search() async {
    final queryText = _searchController.text;
    if (queryText.isNotEmpty) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('studentNumber', isEqualTo: queryText)
          .get();

      final List<AppUser> users = (querySnapshot.docs
          .map((doc) => AppUser.fromMap(
            {...doc.data() as Map<String, dynamic>},
            doc.id, // Pass the document ID as the second argument
          ))
          .where((user) => user.id != currentUserId()) // Exclude the current user
              .toList()).cast<AppUser>();

      setState(() {
        searchResults = users;
      });
    }
  }

  void _sendFriendRequest(String currentUserId, String friendId) async {
    // Add a friend request to the `friendRequests` collection
    await FirebaseFirestore.instance.collection('friendRequests').add({
      'from': currentUserId,
      'to': friendId,
      'status': 'pending', // Or any default status you want to use
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Optionally, update the UI to reflect the sent request

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Friend'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
            Expanded(
              child: searchResults.isNotEmpty
                  ? ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      var result = searchResults[index];
                      return ListTile(
                        leading: Icon(result.icon as IconData?), // You can use initials or a profile picture here
                        title: Text('${result.firstName} ${result.middleName} ${result.lastName}'),
                        subtitle: Text(result.studentNumber),
                        trailing: ElevatedButton(
                          child: const Text('Add'),
                          onPressed: () {
                             _sendFriendRequest(currentUserId(), resultId()); // Replace currentUserId with the actual current user ID
                          },
                      // Disable the button if already friends or if a request has been sent
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue, // Use your theme color here
                      ),
                    ),
                  );
                },
              )
                  : const Center(child: Text('No result.')),
            ),
          ],
        ),
      ),
    );
  }
}
