//home / main page of the app
//mostly listview of list tiles? leading to different pages (schedule maker, accommodations, map,
// link to 'OntarioTechMobile' app?, link to 'Canvas Student' App?)
//have a bottom navigation bar with home page, friends list, and profile/settings
//or maybe only have list tiles because we don't have that many options for the home page

import 'package:flutter/material.dart';
import 'schedule_home_page.dart';
import 'accommodations_home_page.dart';
import '../models/friend_list/friends_list_home_page.dart';
import 'settings_page.dart';
import 'map_page.dart';
import 'profile_page.dart';
import '../models/friend_list/friend_list_main.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';

/*
void _goto_schedule_home_page(context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ScheduleMakerHomePage()),
  );
}

 */

// Initialize Firebase
Future<void> initializeFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void _goto_SAS_home_page(context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SASHomePage()),
  );
}

void _goto_map_page(context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MapPage()),
  );
}

// Initialize Firebase and go to the friend list page
Future<void> _goto_friends_list_page(context) async {
  await initializeFirebase(); // Initialize Firebase
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MyApp()), // Go to the friend list page
  );
}

void _goto_settings_page(context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SettingsPage()),
  );
}

void _goto_profile_page(context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ProfilePage()),
  );
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Sitrus Student Aid"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Settings',
              onPressed: () {_goto_settings_page(context);},
            ),
            IconButton(
              icon: const Icon(Icons.account_circle),
              tooltip: 'Profile',
              onPressed: () {_goto_profile_page(context);},
            ),
          ]),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: <Widget>[
          OutlinedButton.icon(
              icon: Icon(
                Icons.calendar_month,
                size: 60,
              ),
              style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.indigo,
                  minimumSize: Size(200, 150),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0)),
                  textStyle: TextStyle(
                    fontSize: 36,
                  )),
              onPressed: () {
                _goto_settings_page(context);
              },
              label: Text("Schedule Maker")),
          SizedBox(
            height: 10,
          ),
          OutlinedButton.icon(
              icon: Icon(
                Icons.accessibility_new,
                size: 60,
              ),
              style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepOrange,
                  minimumSize: Size(200, 150),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0)),
                  textStyle: TextStyle(
                    fontSize: 36,
                  )),
              onPressed: () {
                _goto_SAS_home_page(context);
              },
              label: Text("SAS Help")),
          SizedBox(
            height: 10,
          ),
          OutlinedButton.icon(
              icon: Icon(
                Icons.map,
                size: 60,
              ),
              style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.indigo,
                  minimumSize: Size(200, 150),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0)),
                  textStyle: TextStyle(
                    fontSize: 36,
                  )),
              onPressed: () {
                _goto_map_page(context);
              },
              label: Text("Campus Map")),
          SizedBox(
            height: 10,
          ),
          OutlinedButton.icon(
              icon: Icon(
                Icons.person,
                size: 60,
              ),
              style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepOrange,
                  minimumSize: Size(200, 150),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0)),
                  textStyle: TextStyle(
                    fontSize: 36,
                  )),
              onPressed: () {
                _goto_friends_list_page(context);
              },
              label: Text("Friends List")),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.indigo,
                      minimumSize: Size(100, 150),
                      maximumSize: Size(180, 150),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0)),
                      textStyle: TextStyle(
                        fontSize: 24,
                      )),
                  onPressed: () {},
                  child: Text("OntarioTechMobile App")),
              SizedBox(width: 10,),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.indigo,
                      minimumSize: Size(100, 150),
                      maximumSize: Size(180, 150),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0)),
                      textStyle: TextStyle(
                        fontSize: 24,
                      )),
                  onPressed: () {},
                  child: Text("Canvas Student App")),
            ],
          )
        ],
      ),
    );
  }
}
