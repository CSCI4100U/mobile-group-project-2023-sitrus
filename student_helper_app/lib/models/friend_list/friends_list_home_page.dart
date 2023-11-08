import 'package:flutter/material.dart';
import 'friends_add_friend_page.dart';
import 'friends_chat_page.dart';

// for test only
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Friend List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FriendListPage(),
    );
  }
}

class FriendListPage extends StatefulWidget {
  const FriendListPage({super.key});

  @override
  _FriendListPageState createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage> {
  List<Map<String, dynamic>> friends = [
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

  List<Map<String, dynamic>> displayedFriends = [];

  @override
  void initState() {
    super.initState();
    displayedFriends = friends;
  }

  void _searchFriend(String searchQuery) {
    List<Map<String, dynamic>> results;
    if (searchQuery.isEmpty) {
      results = friends;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Search fail - no input'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      results = friends
          .where((friend) =>
          friend['name'].toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Search successful'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.blue,
        ),
      );
    }

    setState(() {
      displayedFriends = results;
    });
  }

  void _showSearchDialog() {
    TextEditingController searchController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Search Friends'),
          content: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'Enter a friend\'s name',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Reset'),
              onPressed: () {
                setState(() {
                  displayedFriends = friends;
                });
                searchController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Search'),
              onPressed: () {
                _searchFriend(searchController.text.trim());
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _filterFriendsByStatus(String status) {
    List<Map<String, dynamic>> results;
    if (status == 'All') {
      results = friends;
    } else {
      results = friends.where((friend) {
        return friend['status'] == status;
      }).toList();
    }

    setState(() {
      displayedFriends = results;
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Friends'),
          content: DropdownButtonFormField<String>(
            value: 'All',
            items: ['All', 'Online', 'Busy', 'Offline']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              _filterFriendsByStatus(newValue ?? 'All');
              Navigator.of(context).pop(); // Close the dialog after selection
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Reset'),
              onPressed: () {
                setState(() {
                  displayedFriends = friends; // Reset to the original list
                });
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _changeUserStatus(String status) {
    setState(() {
      userStatus = status;
    });
  }

  void _showStatusChangeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.circle, color: getStatusColor('Online')),
                title: const Text('Online'),
                onTap: () {
                  _changeUserStatus('Online');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.circle, color: getStatusColor('Busy')),
                title: const Text('Busy'),
                onTap: () {
                  _changeUserStatus('Busy');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.circle, color: getStatusColor('Offline')),
                title: const Text('Invisible'),
                onTap: () {
                  _changeUserStatus('Offline');
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }


  Color getStatusColor(String status) {
    switch (status) {
      case 'Online':
        return Colors.greenAccent;
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
          icon: const Icon(Icons.account_circle, size: 45),
          onPressed: () {
            // Navigate to user profile page
          },
        ),
        title: const Text('Friend List'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddFriendPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.circle, size: 15, color: getStatusColor(userStatus)),
            onPressed: _showStatusChangeDialog,
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: displayedFriends.length,
            itemBuilder: (context, index) {
              var friend = displayedFriends[index];
              return ListTile(
                leading: const Icon(Icons.account_circle, size: 40),
                title: Text('${friend['name']} - ${friend['status']}'),
                subtitle: Text(
                  '${friend['isLastMessageFromUser'] ? 'Me' : friend['name']}: ${friend['lastMessage']}',
                ),
                trailing: Icon(Icons.circle, size: 15, color: getStatusColor(friend['status'])),
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
          Positioned(
            right: 10,
            bottom: 10,
            child: Column(
              children: <Widget>[
                FloatingActionButton(
                  onPressed: _showSearchDialog,
                  mini: true,
                  child: const Icon(Icons.search),
                ),
                const SizedBox(height: 10), // Spacing between the buttons
                FloatingActionButton(
                  onPressed: _showFilterDialog,
                  mini: true,
                  child: const Icon(Icons.filter_list), // Set mini to true for smaller FABs
                ),
                const SizedBox(height: 10), // Spacing between the buttons
                // Use FloatingActionButton for the main action
                FloatingActionButton(
                  onPressed: () {
                    // TODO: Add settings functionality
                  },
                  mini: true,
                  child: const Icon(Icons.settings), // Set mini to true for smaller FABs
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

