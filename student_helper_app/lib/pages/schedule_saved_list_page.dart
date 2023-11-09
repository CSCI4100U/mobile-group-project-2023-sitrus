import 'package:flutter/material.dart';
import '../models/schedule_model.dart';

class ScheduleSavedListPage extends StatefulWidget {
  const ScheduleSavedListPage({super.key});

  @override
  State<StatefulWidget> createState() => _ScheduleSavedListPageState();
}

class _ScheduleSavedListPageState extends State<ScheduleSavedListPage> {
  //get list of schedules from database...
  List<Schedule>? schedules;
  //not sure how to handle cloud storage yet, but probably want to
  // check local and cloud data and update local? if there are changes
  //or make it manual instead, so the user has to click a button - "upload schedules to cloud" and "download schedules to cloud"
  //if auto, cloud should only update when new schedules are added
  //local updates on login? give option to overwrite one of the saves

  // var scheduleList = ...
  final scheduleList = [
    "schedule 1",
    "schedule 2",
    "schedule 3",
    "schedule 4"
  ]; //temp example with strings for simplicity

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Save Schedules"),
        ),
        body: ListView.separated(
            //update this with the actual friends list from database
            padding: EdgeInsets.all(10),
            itemCount: scheduleList.length,
            separatorBuilder: (context, index) => Divider(height: 2),
            itemBuilder: (context, index) {
              final friend = scheduleList[index];
              return Container(
                color: Colors.lightBlueAccent,
                height: 300.0,
                child: Text(friend),
              );
            }));
  }
}
