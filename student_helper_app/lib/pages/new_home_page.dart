import 'package:flutter/material.dart';
import 'package:student_helper_project/models/friend_list/friend_login_page.dart';
import 'package:student_helper_project/pages/accommodations_home_page.dart';
import 'package:student_helper_project/pages/home_page.dart';
import 'package:student_helper_project/pages/settings_page.dart';

import '../models/friend_list/friends_chat_page.dart';
import '../models/friend_list/friends_list_home_page.dart';

class NewHomePage extends StatefulWidget {
  NewHomePage({super.key});



  @override
  State<NewHomePage> createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {

  int _selectedIndex = 1;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List _pages = [
    SettingsPage(),
    HomePage(),
    SASHomePage()
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
      ),
      body: _pages[_selectedIndex],
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Column(
          children: [
              const DrawerHeader(child: Icon(
                  Icons.backpack,
                  size: 60
              ),
              ),
            const ListTile(
              leading: Icon(
                  Icons.person,
                  size: 40,
                  ),
              title: Text("P R O F I L E",
              style: TextStyle(fontSize: 20),),
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
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            )

          ],
        )
      ),

      bottomNavigationBar: BottomNavigationBar(
        onTap: _navigateBottomBar,
        currentIndex: _selectedIndex,
        backgroundColor: Theme.of(context).colorScheme.primary,
        selectedItemColor: Theme.of(context).colorScheme.background,
        items:  [
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
