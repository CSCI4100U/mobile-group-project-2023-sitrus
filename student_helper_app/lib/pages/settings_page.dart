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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_helper_project/models/ThemeProvider.dart';

void _goto_login_page(context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
  );
}
//test github comment
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  bool isDarkMode = false;

  //is Dark mode determines if we're in light mode or dark mode
  @override
  /*void initState() {
    super.initState();
    loadTheme();
  }*/

  /*Future<void> loadTheme() async {
    bool? loadedDarkMode = await ThemeProvider.loadThemeFromPreferences();
    if (loadedDarkMode != null) {
      setState(() {
        isDarkMode = loadedDarkMode;
      });
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: ListView(
          children: <Widget>[
            SwitchListTile(
              title: const Text('Friend Request Notifications (In progress)'),
              subtitle:
              const Text('When receiving requests and upon accepted requests'),
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('SAS Notifications (In progress)'),
              subtitle: const Text(
                  'Reminders for renewal and upcoming assessments'),
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Enable Dark Mode (In progress)'),
              value: isDarkMode,
              onChanged: (value) {
                /*ThemeProvider.saveThemeToPreferences(value);*/

              },
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: Consumer<ApplicationState>(
                    builder: (context, appState, _) =>
                        AuthFunc(
                            loggedIn: appState.loggedIn,
                            signOut: () {
                              FirebaseAuth.instance.signOut();
                            }),
                  ),
                ),
              ],
            ),


          ],
        )
    );
  }


}
