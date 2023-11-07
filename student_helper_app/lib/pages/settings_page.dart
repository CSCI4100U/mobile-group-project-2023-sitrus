//can view & edit your profile
//change various settings (checkboxes / sliders) like notifications, theme, logout (login if not logged in), and more

//some notes... potential notifications: friend request received and accepted, accommodations renewal reminder

import 'package:flutter/material.dart';

import 'package:student_helper_project/pages/login_page.dart';

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
          Container(
            padding: EdgeInsets.all(10.0),
            child: OutlinedButton.icon(
                icon: Icon(
                  Icons.login,
                  size: 40,
                ),
                style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.deepOrange,
                    minimumSize: Size(200, 70),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0)),
                    textStyle: TextStyle(
                      fontSize: 36,
                    )),
                onPressed: () 
                {
                  _goto_login_page(context);
                },
                label: Text("Login")),
          )
        ],
      ),
    );
  }
}
