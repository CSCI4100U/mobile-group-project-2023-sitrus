//can view & edit your profile
//change various settings (checkboxes / sliders) like notifications, theme, logout (login if not logged in), and more

//some notes... potential notifications: friend request received and accepted, accommodations renewal reminder

import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_helper_project/pages/login_page.dart';

import 'app_state.dart';
import 'authentication.dart';
import 'guest_book.dart';
import 'widgets.dart';

void _goto_login_page(context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
  );
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: Text('Friend Request Notifications'),
            subtitle:
                Text('When receiving requests and upon accepted requests'),
            value: notificationsEnabled,
            onChanged: (value) {
              setState(() {
                notificationsEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('SAS Notifications'),
            subtitle: Text('Reminders for renewal and upcoming assessments'),
            value: notificationsEnabled,
            onChanged: (value) {
              setState(() {
                notificationsEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('Enable Dark Mode'),
            value: darkModeEnabled,
            onChanged: (value) {
              setState(() {
                darkModeEnabled = value;
              });
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: Consumer<ApplicationState>(
                  builder: (context, appState, _) => AuthFunc(
                      loggedIn: appState.loggedIn,
                      signOut: () {
                        FirebaseAuth.instance.signOut();
                      }),
                ),
              ),
            ],
          ),



        ],
      ),
    );
  }
}
