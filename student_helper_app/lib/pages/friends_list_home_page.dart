//main home page for friends list. displays all friends in a (list view?) - (list tile?) with profile picture,
// name, and status (more or less). can click the list tile (friend) to open their profile
//*have small map initially on 1/3 of the screen or so - displays campus map and location of friends with location
// sharing on. *save this for later/not high priority
//small button (in appbar?) to add friends - editing and deleting should be done in friend's profile

// import 'package:flutter/material.dart';
//
// class FriendListPage extends StatefulWidget {
//   const FriendListPage({super.key});
//
//   @override
//   State<StatefulWidget> createState() => _FriendListPageState();
// }
//
// class _FriendListPageState extends State<FriendListPage> {
//
//   //get list of friends from cloud storage?
//   // var friends_list = ...
//   final tempFriendList = ["friend 1", "friend 2", "friend 3", "friend 4"];  //temp example
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//           title: const Text("Friends List"),
//         ),
//         body: Column(
//           children: <Widget>[
//             SizedBox(height: 10,),
//             //temp placement for map if we want to have the map idea
//             Container(
//               padding: EdgeInsets.all(10.0),
//               width: 360,
//               height: 250,
//               color: Colors.red,
//             ),
//             SizedBox(height: 10,),
//             Expanded(
//                 child: ListView.separated(
//                   //update this with the actual friends list from database
//                     padding: EdgeInsets.all(10),
//                     itemCount: tempFriendList.length,
//                     separatorBuilder: (context, index) => Divider(height: 2),
//                     itemBuilder: (context, index) {
//                       final friend = tempFriendList[index];
//                       return ListTile(
//                         title: Text(friend),
//                         tileColor: index % 2 == 0 ? Colors.indigoAccent : Colors.blue,
//                       );
//                     }
//                     )
//             )
//           ],
//         ));
//   }
// }
import 'package:flutter/material.dart';

import 'friends_add_friend_page.dart';
import 'friends_chat_page.dart';

// for test only
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Friend List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FriendListPage(),
    );
  }
}

class FriendListPage extends StatelessWidget {
  final List<Map<String, dynamic>> friends = [
    {
      'name': 'Alice',
      'status': 'Online',
      'lastMessage': 'Hey there! How are you?',
      'isLastMessageFromUser': false,
    },
    {
      'name': 'Bob',
      'status': 'Offline',
      'lastMessage': 'See you tomorrow!',
      'isLastMessageFromUser': true,
    },
    {
      'name': 'Charlie',
      'status': 'Busy',
      'lastMessage': 'Can\'t talk now, sorry!',
      'isLastMessageFromUser': false,
    },
  ];

  String userStatus = 'Online';

  Color getStatusColor(String status) {
    switch (status) {
      case 'Online':
        return Colors.green;
      case 'Busy':
        return Colors.red;
      case 'Offline':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.account_circle, size: 45),
          onPressed: () {
            // Navigate to user profile page
          },
        ),
        title: Text('Friend List'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddFriendPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.circle, color: getStatusColor(userStatus)),
            onPressed: () {
              // Change user status
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                var friend = friends[index];
                return ListTile(
                  leading: Icon(Icons.account_circle, size: 40),
                  title: Text('${friend['name']} - ${friend['status']}'),
                  subtitle: Text(
                    '${friend['isLastMessageFromUser'] ? 'Me' : friend['name']}: ${friend['lastMessage']}',
                  ),
                  trailing: Icon(Icons.circle, color: getStatusColor(friend['status'])),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(friendName: friend['name'],friendStatus: friend['status'],),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.search, size: 30),
                  onPressed: () {
                    // Add search functionality
                  },
                ),
                IconButton(
                  icon: Icon(Icons.filter_list, size: 30),
                  onPressed: () {
                    // Add filter functionality
                  },
                ),
                IconButton(
                  icon: Icon(Icons.settings, size: 30),
                  onPressed: () {
                    // Add settings functionality
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
