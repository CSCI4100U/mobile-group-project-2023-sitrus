

// main.dart

import 'package:flutter/material.dart';
import 'package:student_helper_project/models/sas_model/Accommodation.dart';
//import 'package:student_helper_project/models/sas_model/Assessments.dart';



class UpcomingPage extends StatefulWidget {
  const UpcomingPage({super.key});

  @override
  UpcomingPageState createState() => UpcomingPageState();
}

class UpcomingPageState extends State<UpcomingPage> {
  final List<Accommodation> amdtns = [
    //These are just here for now to prove that this works
    //The plan is for the user to be able to tell what accommodations they'll have acess to
    Accommodation(name: 'Test 1', desc: 'Student recieves double time on assessment', assessments: ['Test', 'Quiz'],
        eventDate: DateTime.utc(2023,11,29)),
    Accommodation(name: 'Quiz 2', desc: 'Student is entitled to the use of a scribe',
        assessments: ['Test', 'Quiz', 'Written Work'], eventDate: DateTime.utc(2023, 4, 7)),

  ];

  List<Accommodation> filteredAccommodations = [];

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
                delegate: EventSearch(amdtns),
              );
            },
          ),
        ],
      ),
      body: EventList(accommodations: filteredAccommodations.isNotEmpty ? filteredAccommodations : amdtns),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEventDialog(context);
        },
        tooltip: 'Add Event',
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddEventDialog(BuildContext context) {
    String eventName = '';
    String eventType = '';
    String? Acmdtn;
    DateTime eventDate = DateTime.now(); // Set a default date

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Event'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Assessment'),
                  onChanged: (value) {
                    setState(() {
                      eventName = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(labelText: 'Type'),
                  onChanged: (value) {
                    setState(() {
                      eventType = value;
                      if (amdtns.any((e) => e.assessments.contains(value))) {
                        var temp = (amdtns.where((e) =>
                            e.assessments.contains(value)));
                        Acmdtn = temp.first.desc;
                        print(Acmdtn);
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Add a date picker for event date
                ElevatedButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != eventDate) {
                      setState(() {
                        eventDate = pickedDate;
                      });
                    }
                  },
                  child: Text('Select Event Date'),
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
                  print("Add");
                  amdtns.add(Accommodation(name: eventName,
                      desc: Acmdtn ?? eventType,
                      assessments: [''],
                      eventDate: eventDate));
                });
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }}
class EventList extends StatelessWidget {
  final List<Accommodation> accommodations;

  EventList({required this.accommodations});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: accommodations.length,
      itemBuilder: (context, index) {
        bool withinTwoWeekNotice = accommodations[index].isWithinTwoWeekNotice();

        return ListTile(
          title: Text(accommodations[index].name as String),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Description: ${accommodations[index].desc}'),
              Text('Date: ${accommodations[index].eventDate.toLocal()}'),
              Text(
                'Within Two-Week Notice: ${withinTwoWeekNotice ? "Yes" : "No"}',
                style: TextStyle(
                  color: withinTwoWeekNotice ? Colors.red : Colors.black,
                  fontWeight: FontWeight.bold,
                ),),
            ],
          ),
          onTap: () {},
        );
      },
    );
  }
}

class EventSearch extends SearchDelegate<String> {
  final List<Accommodation> accommodations;

  EventSearch(this.accommodations);

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
        ? accommodations
        : accommodations
        .where((event) =>
        (event.name as String).toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    return EventList(accommodations: suggestionList);
  }
}
