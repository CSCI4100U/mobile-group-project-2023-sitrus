import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../firebase_options.dart';
import 'friend_login_page.dart';
import 'friends_list_home_page.dart';

Future<void> main() async {
  // Ensure that Firebase is initialized before the app starts
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Create a local notifications plugin instance
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Set up the initialization settings for Android
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  // IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(); // Uncomment if iOS initialization is needed

  // Combine Android and iOS settings into a single InitializationSettings object
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    // iOS: initializationSettingsIOS, // Uncomment if iOS initialization is needed
  );

  // Initialize the local notifications plugin with the settings
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Run the app
  runApp(const FriendList());
}

class FriendList extends StatelessWidget {
  const FriendList({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the MaterialApp with a title and theme
    return MaterialApp(
      title: 'Friend List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Handle authentication state changes
      home: StreamBuilder<User?>(
        // Listen to the stream of authentication state changes
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // If the connection to the stream is active, check the user data
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data; // Get the user data from the snapshot
            if (user == null) {
              return LoginPage(); // If there's no user, return the login page
            }
            return const FriendListPage(); // If there's a user, return the friend list page
          }
          // While waiting for the connection, show a loading indicator
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
