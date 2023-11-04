import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool showStatus = false;
  String username = "Name"; // Replace with the user's name

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Your Profile'), actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Profile',
            onPressed: () {},
          ),
        ]),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(10.0),
                width: 400.0,
                color: Colors.indigo,
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 80,
                    ),
                    Text(
                      username,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ],
                )),
            Expanded(
              child: ListView(
                children: <Widget>[
                  SwitchListTile(
                    title: Text('Online Status'),
                    subtitle: Text('Toggle visibility to your friends'),
                    value: showStatus,
                    onChanged: (value) {
                      setState(() {
                        showStatus = value;
                      });
                    },
                  ),
                  //todo: probability use some other widget that's not Text()
                  Text(
                    'Program: Computer Science', // Make changable
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Year: 3', // Make changable
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'About Me:', // Make changable
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
