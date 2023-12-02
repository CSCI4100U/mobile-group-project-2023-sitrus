import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:student_helper_project/pages/home_page.dart';
import '../../pages/new_home_page.dart';
import 'friend_registration_page.dart';
import 'friends_list_home_page.dart';

// LoginPage allows users to sign in to the application.
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // GlobalKey for form validation.
  final _formKey = GlobalKey<FormState>();
  // Text editing controllers for email and password fields.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // Remember me flag.
  bool _rememberMe = false;

  // Local notifications plugin instance.
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Initialization of state. Checks "Remember Me" preference and initializes notifications.
  @override
  void initState() {
    super.initState();
    _checkRememberMe();
    _initializeNotifications();
  }

  // Initializes the local notifications.
  void _initializeNotifications() async {
    // Android-specific initialization settings.
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    // Initialization settings for both platforms.
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Listens to friend requests and shows a notification if any are pending.
  void _listenToFriendRequests() {
    // Logs are used to debug and ensure the listener is functioning correctly.
    // When a friend request is detected, a notification is shown.
    if (kDebugMode) {
      print("Listening to friend requests");
    } // Log that the method has started

    FirebaseFirestore.instance
        .collection('friendRequests')
        .where('toUid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .listen((snapshot) {
      print("Received snapshot with ${snapshot.docs.length} document(s)"); // Log the number of documents received

      if (snapshot.docs.isNotEmpty) {
        print("Found ${snapshot.docs.length} pending friend request(s)"); // Log when there are pending friend requests
        _showNotification(snapshot.docs.length);
      } else {
        print("No pending friend requests found"); // Log when there are no pending friend requests
      }
    }, onError: (error) {
      print("Error listening to friend requests: $error"); // Log errors
    });
  }

  // Shows a local notification to the user.
  Future<void> _showNotification(int requestsCount) async {
    // Notification details for Android.
    // Shows a notification with the number of friend requests.
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'friend_request_channel_id',
      'Friend Requests',
      channelDescription: 'Notification channel for friend requests',
      importance: Importance.max,
      priority: Priority.high,
      icon: 'app_icon', // Replace 'app_icon' with your app icon
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'Friend Request',
      'You have $requestsCount new friend request(s)',
      platformChannelSpecifics,
    );
  }

  // Toggles the "Remember Me" checkbox.
  void _toggleRememberMe(bool? value) {
    setState(() {
      _rememberMe = value ?? false;
    });
  }

  // Handles the login process.
  void _login() async {
    // Uses form key to validate form and perform login if validation passes.
    // On login success, navigates to FriendListPage and listens for friend requests.
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        // If the sign in is successful, navigate to the FriendListPage
        if (userCredential.user != null) {
          _onLoginSuccess();
          _listenToFriendRequests();
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Actions to take on successful login.
  void _onLoginSuccess() async {
    // Sets "Remember Me" preference if enabled and navigates to FriendListPage.
    if (_rememberMe) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('remember_me', _rememberMe);
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => FriendListPage()));
  }

  // Checks if "Remember Me" was selected in a previous session.
  void _checkRememberMe() async {
    // Retrieves the "Remember Me" preference and navigates to FriendListPage if true.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberMe = prefs.getBool('remember_me') ?? false;
    if (rememberMe) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => FriendListPage()));
    }
  }

  // Builds the login page interface.
  @override
  Widget build(BuildContext context) {
    // Scaffold provides the structure for the login form.
    // The form includes fields for email and password, a "Remember Me" checkbox, and buttons to login or register.
    return Scaffold(
      backgroundColor: Colors.indigo[100],
      // Other UI components such as AppBar, TextFormField, and ElevatedButton are used to create the form and handle user input.
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate to the HomePage for now
            // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => FriendListPage()));
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewHomePage()),
            );
          },
        ),
        title: const Text('Login'),
      ),
      body: ListView(

        //CHANGES TO LOGIN PAGE: BY NIRUJAN
        //ADDED ICON AT TOP OF PAGE, ADDED APP NAME, SPACED OUT LOGIN PAGE ELEMENTS
        //COMMENTED OUT REMEMBER ME WIDGET, MOVED REGISTER BUTTON DOWN
        // ADDED TEXT ASKING IF YOU DONT HAVE AN ACCOUNT, ADDED STYLING AND PADDING

        children: [
          const Padding(
            padding: EdgeInsets.only(top: 40, bottom: 30),
            child: Icon(
                Icons.backpack,
                size: 90,),
          ),
          Container(
              alignment: Alignment.center,
              child: const Text("S I T R U S",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),)),

          Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? 'Enter your email' : null,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) => value!.isEmpty ? 'Enter your password' : null,
                ),
                SizedBox(height: 20),
                /*CheckboxListTile(
                  value: _rememberMe,
                  onChanged: (bool? value) {
                    setState(() {
                      _rememberMe = value!;
                    });
                  },
                  title: Text('Remember me'),
                  controlAffinity: ListTileControlAffinity.leading,
                ),*/
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [


                    Expanded(
                      child:
                        ElevatedButton(
                          //icon: Icon(Icons.arrow_forward_ios),

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo[400],
                            foregroundColor: Colors.white,
                            elevation: 14,
                            minimumSize: Size(30, 40)
                          ),
                          onPressed: _login,
                          //label: const
                          child: Text('Login',
                          style: TextStyle(fontSize: 30),),
                        ),

                    ),

                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Text("Don't Have An Account?"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigo[400],
                                  foregroundColor: Colors.white,
                                  elevation: 14,
                                  minimumSize: Size(30, 40)
                              ),
                              onPressed: () {
                                // Navigate to the RegistrationPage
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegistrationPage()));
                              },
                              child: Text('Register Here',
                                      style: TextStyle(fontSize: 30),)),

                          ),
                            ]
                        ),
                //SizedBox(width: 20),
              ],
            ),
          ),
        ),]
      ),
    );
  }
}
