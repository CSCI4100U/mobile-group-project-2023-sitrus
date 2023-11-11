// Import necessary Flutter and Firebase packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import the 'AppUser' class from a separate file
import 'friend_login_page.dart';
import 'appuser.dart';

/// UserProfilePage allows viewing and editing the user profile.
class UserProfilePage extends StatefulWidget {
  final String userId;

  const UserProfilePage({super.key, required this.userId});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  AppUser? _user; // User data object
  bool _isLoading = true; // Loading state indicator
  TextEditingController? _controller; // Controller for text fields in edit dialogs
  currentUserId() {return FirebaseAuth.instance.currentUser!.uid;}
  currentUser() {return FirebaseAuth.instance.currentUser!;}

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(); // Initialize the text controller
    _fetchUserData(); // Fetch user data when the widget is initialized
  }

  // Define a method to fetch user data from Firestore
  Future<void> _fetchUserData() async {
    // Fetch a document from Firestore based on the 'userId'
    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)  // Use widget.userId
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

  // Save updated profile data to Firestore
  void _saveProfile(String field, String newValue) {
    if (_user != null) {
      // Update Firestore document with new field value
      // Show success or error message based on operation result
      FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid) // Use _user!.id instead of currentUserId()
          .update({field: newValue})
          .then((_) {
        setState(() {
          // Update the local user object
          if (field == 'firstName') {
            _user!.firstName = newValue;
          } else if (field == 'studentNumber') {
            _user!.studentNumber = newValue;
          }
          // Add else if branches for other fields as necessary
        });
        // Optionally, show a snackbar to confirm the update
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$field updated successfully.'), backgroundColor: Colors.green),
        );
      }).catchError((error) {
        // Handle errors, possibly show a snackbar with the error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update $field.'), backgroundColor: Colors.red),
        );
      });
    }
  }

  // Handle user logout, clear SharedPreferences and navigate to login screen
  Future<void> _logout() async {
    // Clear the "Remember Me" flag from SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('remember_me');

    // Update the user's status to 'Offline' in Firestore
    final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(currentUserUid).update({
      'status': 'Offline',
    });

    // Sign out from Firebase Auth
    await FirebaseAuth.instance.signOut();

    // Navigate to the login screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
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

    // Display user profile information and provide options for editing
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
          ListTile(
            title: Text(_user!.lastName),
            subtitle: const Text('Last Name'),
            onTap: () => _editField(
                'Last Name', _user!.lastName, (newValue) => _saveProfile('lastName', newValue)),
          ),
          ListTile(
            title: Text(_user!.email),
            subtitle: const Text('Email'),
          ),
          ListTile(
            title: Text(_user!.phoneNumber ?? 'Not provided'),
            subtitle: const Text('Phone Number'),
            onTap: () => _editField(
                'Phone Number', _user!.phoneNumber ?? '', (newValue) => _saveProfile('phoneNumber', newValue)),
          ),
          ListTile(
            title: Text(_user!.birthday != null
                ? '${_user!.birthday!.month}/${_user!.birthday!.day}/${_user!.birthday!.year}'
                : 'Not provided'),
            subtitle: const Text('Birthday'),
            onTap: () => _editField(
                'Birthday', _user!.birthday != null
                ? '${_user!.birthday!.month}/${_user!.birthday!.day}/${_user!.birthday!.year}'
                : '', (newValue) => _saveProfile('birthday', newValue)),
          ),
          ListTile(
            title: Text(_user!.grade ?? 'Not provided'),
            subtitle: const Text('Grade'),
            onTap: () => _editField(
                'Grade', _user!.grade ?? '', (newValue) => _saveProfile('grade', newValue)),
          ),
          ListTile(
            title: Text(_user!.major ?? 'Not provided'),
            subtitle: const Text('Major'),
            onTap: () => _editField(
                'Major', _user!.major ?? '', (newValue) => _saveProfile('major', newValue)),
          ),
          ListTile(
            title: Text(_user!.description ?? 'Not provided'),
            subtitle: const Text('Description'),
            onTap: () => _editField(
                'Description', _user!.description ?? '', (newValue) => _saveProfile('description', newValue)),
          ),
          ListTile(
            title: const Text('Logout', style: TextStyle(color: Colors.red), textAlign: TextAlign.center),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}
