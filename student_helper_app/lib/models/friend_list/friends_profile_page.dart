// Import necessary Flutter and Firebase packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Import the 'AppUser' class from a separate file
import 'appuser.dart';

// Create a 'UserProfilePage' class that extends 'StatefulWidget'
class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});
  // Override the createState() method to create a stateful instance
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

// Create the state class for the 'UserProfilePage'
class _UserProfilePageState extends State<UserProfilePage> {
  currentUserId() {
    return FirebaseAuth.instance.currentUser!.uid;
  }
  currentUser() {
    return FirebaseAuth.instance.currentUser!;
  }
  // Declare variables for the user data, loading state, and a text controller
  AppUser? _user;
  bool _isLoading = true;
  TextEditingController? _controller;

  // Override the 'initState()' method to perform initialization tasks
  @override
  void initState() {
    super.initState();
    // Initialize the text controller
    _controller = TextEditingController();
    // Fetch user data asynchronously when the widget is initialized
    _fetchUserData();
  }

  // Define a method to fetch user data from Firestore
  Future<void> _fetchUserData() async {
    // Fetch a document from Firestore based on the 'userId'
    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId())
        .get();
    if (userData.exists && userData.data() != null) {
      // If the document exists and contains data, update the UI
      setState(() {
        _user = AppUser.fromMap(
            userData.data() as Map<String, dynamic>, userData.id);
        _isLoading = false;
      });
    } else {
      // Handle the case where the user document doesn't exist or data is null
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Define a method to display an edit dialog for a specific field
  void _editField(String field, String initialValue, Function(String) onSave) {
    // Initialize the text field with the provided initial value
    _controller!.text = initialValue;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $field'),
          content: TextField(
            controller: _controller,
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                // Call the provided 'onSave' function with the edited value
                onSave(_controller!.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Define a method to save the updated profile data to Firestore
  void _saveProfile(String field, String newValue) {
    if (_user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId()) // Update the current user's document
          .update({field: newValue})
          .then((_) {
        // Update local user object and UI (not implemented here)
      })
          .catchError((error) {
        // Handle errors (not implemented here)
      });
    }
  }

  // Define a method to handle user logout
  void _logout() async {
    await FirebaseAuth.instance.signOut();
    // Navigate to the login page after logout
    Navigator.of(context).pushReplacementNamed('/login');
  }

  // Override the 'dispose()' method to release resources
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // Override the 'build()' method to define the widget's UI
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Display a loading indicator while user data is being fetched
      return Scaffold(
        appBar: AppBar(title: const Text('Loading profile...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_user == null) {
      // Display an error message if user data couldn't be loaded
      return Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: const Text('Profile not found'),
        ),
        body: const Center(child: Text('User data could not be loaded.')),
      );
    }

    // Display the user's profile information and options for editing
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text("${_user!.firstName}'s Profile"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: _user!.icon != null
                ? NetworkImage(_user!.icon!)
                : null,
            child: _user!.icon == null
                ? Text(
              _user!.getInitials(),
              style: const TextStyle(fontSize: 40),
            )
                : null,
          ),
          ListTile(
            title: Text(_user!.studentNumber),
            subtitle: const Text('Student Number'),
            onTap: () => _editField(
                'Student Number', _user!.studentNumber, (newValue) => _saveProfile('studentNumber', newValue)),
          ),
          // Include ListTiles for other fields similar to the one above
          ListTile(
            title: Text(_user!.firstName),
            subtitle: const Text('First Name'),
            onTap: () => _editField(
                'First Name', _user!.firstName, (newValue) => _saveProfile('firstName', newValue)),
          ),
          // ... Other profile fields go here ...
          ListTile(
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}
