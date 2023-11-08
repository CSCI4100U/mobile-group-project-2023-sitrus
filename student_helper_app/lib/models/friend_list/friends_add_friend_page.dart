import 'package:flutter/material.dart';

class AddFriendPage extends StatefulWidget {
  @override
  _AddFriendPageState createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];

  // This is the mock function to simulate the search process
  void _search() {
    // TODO:Replace this with the actual search logic
    setState(() {
      searchResults = [
        {
          'icon': Icons.person,
          'name': 'John Doe',
          'studentNumber': '123456',
          'isFriend': false,
        },
        {
          'icon': Icons.person,
          'name': 'Jane Smith',
          'studentNumber': '654321',
          'isFriend': true, // This user is already a friend
        },
        // Add more mock results as needed for testing
      ];
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Friend'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by name or student number',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _search,
                ),
              ),
              onSubmitted: (value) => _search(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: searchResults.isNotEmpty
                  ? ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  var result = searchResults[index];
                  return ListTile(
                    leading: Icon(result['icon']),
                    title: Text(result['name']),
                    subtitle: Text('Student Number: ${result['studentNumber']}'),
                    trailing: ElevatedButton(
                      child: const Text('Add'),
                      onPressed: result['isFriend'] ? null : () {
                        // TODO:Implement add friend logic
                      },
                      style: ElevatedButton.styleFrom(
                        primary: result['isFriend'] ? Colors.grey : null, // If already friends, button is grey
                      ),
                    ),
                  );
                },
              )
                  : const Center(child: Text('No result.')),
            ),
          ],
        ),
      ),
    );
  }
}
