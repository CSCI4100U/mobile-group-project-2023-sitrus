import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:student_helper_project/pages/friend_list/friend_login_page.dart';
import 'package:student_helper_project/pages/accommodations_home_page.dart';
import 'package:student_helper_project/pages/home_page.dart';
import 'package:student_helper_project/pages/schedule_home_page.dart';
import 'package:student_helper_project/pages/settings_page.dart';
import 'package:http/http.dart' as http;
import 'friend_list/friends_add_friend_page.dart';
import 'friend_list/friends_chat_page.dart';
import 'friend_list/friends_list_home_page.dart';
import 'info.dart';
import 'friend_list/friends_profile_page.dart';

class NewHomePage extends StatefulWidget {
  NewHomePage({super.key});



  @override
  State<NewHomePage> createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {
  currentUserId() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  int _selectedIndex = 1;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List _pages = [
    ScheduleMakerHomePage(),
    const FriendListPage(),
    SASHomePage()
  ];

  final List _pageNames = [
    "Schedule",
    "Chat",
    "Accommodations"
  ];

  String _apiKey = '30c17ef9cc1cd4397ee2239f09434073'; // Replace with your actual API key from OpenWeatherMap
  String location = 'Oshawa'; // Example location

  String _weatherDescription = 'Loading weather...';

  @override
  void initState() {
    super.initState();
    // Fetches the current user and stores it in a Future for later use
    _fetchWeather();
  }
  Future<Map<String, dynamic>> fetchWeather(String apiKey, String location) async {
    String url = 'http://api.weatherstack.com/current?access_key=$apiKey&query=$location';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      if (responseJson['error'] != null) {
        throw Exception('Weather API error: ${responseJson['error']['info']}');
      }
      return responseJson;
    } else {
      throw Exception('Failed to load weather data with status code: ${response.statusCode}');
    }
  }

  void _fetchWeather() async {
    try {
      // Make sure to use https if you're on a paid plan for Weatherstack
      final weatherData = await fetchWeather(_apiKey, location);
      setState(() {
        _weatherDescription = '${weatherData['current']['temperature']}°C, ${weatherData['current']['weather_descriptions'][0]}';
      });
    } catch (e) {
      setState(() {
        _weatherDescription = 'Weather unavailable';
      });
      if (kDebugMode) {
        print('Error fetching weather: $e');
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Colors.white,
        title: Text(_pageNames[_selectedIndex])


          /*Text(
            "Sitrus Student Aid",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold
            )
        )*/,

        actions: _selectedIndex == 1 ? [IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddFriendPage()),
            );
          },
        ),

          ] : [Center(child: Text(_weatherDescription))]
      ),
      body: _pages[_selectedIndex],
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.secondary,

        child: Column(

          children: [
              const DrawerHeader(child: Icon(
                  Icons.backpack,
                  size: 60
              ),
              ),
            ListTile(
              leading: const Icon(
                  Icons.person,
                  size: 40,
                  ),
              title: const Text("P R O F I L E",
              style: TextStyle(fontSize: 20),),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfilePage(userId: currentUserId(),)), // Integration Preparation
                );
              },
            ),
            ListTile(
              leading:  const Icon(
                Icons.settings,
                size: 40,
              ),
              title:  const Text("S E T T I N G S",
                          style: TextStyle(
                              fontSize: 20)
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            ListTile(
              leading:  const Icon(
                Icons.info,
                size: 40,
              ),
              title:  const Text("I N F O",
                  style: TextStyle(
                      fontSize: 20)
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InfoPage()),
                );
              },
            ),
            ListTile(
              leading:  const Icon(
                Icons.question_mark,
                size: 40,
              ),
              title:  const Text("H E L P",
                  style: TextStyle(
                      fontSize: 20)
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InfoPage()),
                );
              },
            )

          ],
        ),

      ),

      bottomNavigationBar: BottomNavigationBar(
        onTap: _navigateBottomBar,
        currentIndex: _selectedIndex,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        selectedItemColor: Theme.of(context).colorScheme.background,
        items:  const [
          BottomNavigationBarItem(
              icon: Icon(Icons.table_chart, size: 40),
              label: "Schedule",),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble, size: 40),
              label: "Chat"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 40),
              label: "Accommodations"),

        ],
      ),
    );
  }
}
