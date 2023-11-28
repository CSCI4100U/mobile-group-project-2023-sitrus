//home / main page of the app
//mostly listview of list tiles? leading to different pages (schedule maker, accommodations, map,
// link to 'OntarioTechMobile' app?, link to 'Canvas Student' App?)
//have a bottom navigation bar with home page, friends list, and profile/settings
//or maybe only have list tiles because we don't have that many options for the home page

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'schedule_home_page.dart';
import 'accommodations_home_page.dart';
import '../models/friend_list/friends_list_home_page.dart';
import 'settings_page.dart';
import 'map_page.dart';
import 'profile_page.dart';
import '../models/friend_list/friend_list_main.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';

// Initialize Firebase
Future<void> initializeFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void _goto_schedule_home_page(context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ScheduleMakerHomePage()),
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
    MaterialPageRoute(builder: (context) => FriendList()), // Go to the friend list page
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


  Future<void> _launchURL(String url) async {

    final Uri uri = Uri(scheme: "https", host: url);
    if(!await launchUrl(
      uri,
      mode: LaunchMode.inAppWebView,
    )) {
      throw "Can not launch url";
    }
  }

  int selectedIndex = 0;

  List<NavPage> pages = [
    NavPage(name: "Add to Cart", icon: Icons.add_shopping_cart),
    NavPage(name: "Be Sad", icon: Icons.javascript),
    NavPage(name: "Join the Navy", icon: Icons.radar),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.background,
          title: const Text(
              "Sitrus Student Aid",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold
              )
          ),
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
              autofocus: true,
              icon: Icon(
                Icons.calendar_month,
                size: 60,
              ),
              style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.background,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  minimumSize: Size(200, 150),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  textStyle: TextStyle(
                    fontSize: 36,
                  )),
              onPressed: () {
                _goto_schedule_home_page(context);
              },
              label: Text("Schedule Maker")),
          const SizedBox(
            height: 10,
          ),

          OutlinedButton.icon(
              icon: const Icon(
                Icons.accessibility_new,
                size: 60,
              ),
              style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.background,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  minimumSize: Size(200, 150),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  textStyle: const TextStyle(
                    fontSize: 36,
                  )),
              onPressed: () {
                _goto_SAS_home_page(context);
              },
              label: const Text("SAS Help")),
          const SizedBox(
            height: 10,
          ),
          OutlinedButton.icon(
              icon: const Icon(
                Icons.map,
                size: 60,
              ),
              style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.background,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  minimumSize: Size(200, 150),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  textStyle: const TextStyle(
                    fontSize: 36,
                  )),
              onPressed: () {
                _goto_map_page(context);
              },
              label: const Text("Campus Map")),

          const SizedBox(
            height: 10,
          ),
          OutlinedButton.icon(
              icon: const Icon(
                Icons.person,
                size: 60,
              ),
              style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.background,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  minimumSize: Size(200, 150),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  textStyle: const TextStyle(
                    fontSize: 36,
                  )),
              onPressed: () {
                _goto_friends_list_page(context);
              },
              label: const Text("Friends List")),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.background,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      minimumSize: const Size(100, 150),
                      maximumSize: const Size(180, 150),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      textStyle: TextStyle(
                        fontSize: 24,
                      )),
                  onPressed: () {
                    _launchURL("my.ontariotechu.ca");
                  },
                  child: Text("OntarioTechMobile App")),
              SizedBox(width: 10,),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.background,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      minimumSize: Size(100, 150),
                      maximumSize: Size(180, 150),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      textStyle: TextStyle(
                        fontSize: 24,
                      )),
                  onPressed: () {
                    _launchURL("learn.ontariotechu.ca");
                  },
                  child: Text("Canvas Student App")),
            ],
          )
        ],
      ),

    );
  }


}

class NavPage{
  String? name;
  IconData? icon;

  NavPage({this.name, this.icon});
}