import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'package:student_helper_project/models/sas_model/Accommodation.dart';


TextEditingController _searchController = TextEditingController();



class UpcomingPage extends StatefulWidget {
  const UpcomingPage({Key? key}) : super(key: key);

  @override
  _UpcomingPageState createState() => _UpcomingPageState();
}

class _UpcomingPageState extends State<UpcomingPage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
   // initializeNotifications();
  }
/*

  void initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<void> onSelectNotification(String? payload) async {
    // Handle notification tap
    print('Notification tapped!');
  }

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'csci-4100u-final-pg-friendlist',
      'Upcoming Assessments',
      'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }
*/

  final List<Accommodation> amdtns = [
    Accommodation(
        name: 'Test 1',
        desc: 'Student receives double time on assessment',
        assessments: ['Test', 'Quiz'],
        eventDate: DateTime.utc(2023, 11, 29)),
    Accommodation(
        name: 'Quiz 2',
        desc: 'Student is entitled to the use of a scribe',
        assessments: ['Test', 'Quiz', 'Written Work'],
        eventDate: DateTime.utc(2023, 4, 7)),
  ];

  List<Accommodation> filteredAccommodations = [];
  void _refreshList() {
    setState(() {
      filteredAccommodations = [];
    });
  }
  void _filterAccommodations(String query) {
    List<Accommodation> filteredList = amdtns
        .where((accommodation) =>
    (accommodation.name!.toLowerCase().contains(query.toLowerCase()) ||
        accommodation.desc!.toLowerCase().contains(query.toLowerCase())) &&
        !accommodation.isEventPast()) // Check if the event is not past
        .toList();

    setState(() {
      filteredAccommodations = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upcoming Assessments'),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              // Add your sorting logic here
            },
          ),
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              _showExplanationPopup(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _refreshList(); // Reset the list when clearing the search
                  },
                ),
              ),
              onChanged: (value) {
                _filterAccommodations(value);
              },
              onEditingComplete: () {
                _searchController.clear();
                _refreshList(); // Reset the list when clearing the search
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredAccommodations.isNotEmpty
                  ? filteredAccommodations.length
                  : amdtns.length,
              itemBuilder: (context, index) {
                bool? withinTwoWeekNotice =
                filteredAccommodations.isNotEmpty
                    ? filteredAccommodations[index].isWithinTwoWeekNotice()
                    : amdtns[index].isWithinTwoWeekNotice();

                return ListTile(
                  title: Text(
                    filteredAccommodations.isNotEmpty
                        ? filteredAccommodations[index].name as String
                        : amdtns[index].name as String,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Description: ${filteredAccommodations.isNotEmpty ? filteredAccommodations[index].desc : amdtns[index].desc}'),
                      Text(
                          'Date: ${filteredAccommodations.isNotEmpty ? filteredAccommodations[index].eventDate?.toLocal() : amdtns[index].eventDate?.toLocal()}'),
                      Text(
                        'Within Two-Week Notice: ${withinTwoWeekNotice as bool ? "Yes" : "No"}',
                        style: TextStyle(
                          color: withinTwoWeekNotice ? Colors.red : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Add your onTap logic here
                  },
                );
              },
            ),
          ),
        ],
      ),
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
                  Accommodation newAccommodation = Accommodation(
                    name: eventName,
                    desc: Acmdtn ?? eventType,
                    assessments: [''],
                    eventDate: eventDate,
                  );
                  amdtns.add(newAccommodation);

                  // Schedule a notification for the event date
                  scheduleNotification(newAccommodation);

                  // Close the dialog
                  Navigator.of(context).pop();
                });
              },
              child: Text('Add'),
            ),

          ],
        );
      },

    );

  }

  void scheduleNotification(Accommodation accommodation) async {
    tz.TZDateTime scheduledDate = tz.TZDateTime.from(
      accommodation.eventDate!,
      tz.local,
    );

    // Calculate the date for the two-week reminder
    tz.TZDateTime twoWeeksBefore = scheduledDate.subtract(Duration(days: 14));

    // Schedule a notification for the event date
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Upcoming Event',
      'You have an upcoming event: ${accommodation.name}',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'csci-4100u-final-pg-friendlist',
          'Upcoming Assessments',
          'Check if registered in SAS',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
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
        bool? withinTwoWeekNotice = accommodations[index].isWithinTwoWeekNotice();

        return ListTile(
          title: Text(accommodations[index].name as String),
          subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          Text('Description: ${accommodations[index].desc}'),
          Text('Date: ${accommodations[index].eventDate?.toLocal()}'),
          Text(
            'Within Two-Week Notice: ${withinTwoWeekNotice as bool ? "Yes" : "No"}',
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
//------------------------------------------------------------------------------------

void _showExplanationPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Page Explanation'),
        content: Text(
          'This page allows you to schedule upcoming assessments and see what you are entitled to. '
              'Use the add button to create a new event.'
              'You will get a two week notice before each event.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      );
    },
  );
}//---------------------------------------------------------
