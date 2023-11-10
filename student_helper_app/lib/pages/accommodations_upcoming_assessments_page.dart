//view upcoming assessments in a list. user can click on assessment to bring up a pop up (a window) or new page
// to view their accommodations for that assessment (e.g. double time, a scribe, a different test room, ...)
import 'package:flutter/material.dart';
import 'models/sas_model/Accommodation.dart';
class UpcomingPage extends StatefulWidget {
  const UpcomingPage({super.key});

  @override
  UpcomingPageState createState() => UpcomingPageState();
}

class UpcomingPageState extends State<UpcomingPage> {
  final List<Accommodation> events = [
    //These are just here for now to prove that this works 
    //The plan is for the user to be able to tell what accommodations they'll have acess to
    Accommodation(name: 'Test 1', desc: 'Test'),
    Accommodation(name: 'Quiz 1', desc: 'Quiz'),
    Accommodation(name: 'Presentation 1', desc: 'Presentation'),
  ];
  List<Accommodation> filteredEvents = [];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upcoming Assessments'),
        actions: [
          //add button
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddEventDialog(context);
            },
          ),
          IconButton(
            //search button!
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: EventSearch(events),
              );
            },
          ),
        ],
      ),
      body: EventList(accommodations: filteredEvents.isNotEmpty ? filteredEvents : events),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEventDialog(context);
        },
        tooltip: 'Add Assessment',
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddEventDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add event'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Assessment'),
                  onChanged: (value) {
                    
                  },
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(labelText: 'Assessment Type'),
                  onChanged: (value) {
                    // Handle changes in the text field
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  events.add(Accommodation(name: 'name', desc: 'desc'));
                });
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class EventList extends StatelessWidget {
  final List<Accommodation> accommodations;

  EventList({required this.accommodations});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: accommodations.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(accommodations[index].name as String),
          subtitle: Text(accommodations[index].desc as String),
          onTap: () {
            //tba 
          },
        );
      },
    );
  }
}
// ...


class EventSearch extends SearchDelegate<String> {
  final List<Accommodation> events;

  EventSearch(this.events);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? events
        : events
        .where((event) =>
    (event.name as String).toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    return EventList(accommodations: suggestionList);
  }
}
