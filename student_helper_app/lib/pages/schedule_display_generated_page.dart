import 'package:flutter/material.dart';
import '../models/schedule_course_model.dart';
//display_generated.dart
class DisplayGeneratedSchedulesPage extends StatelessWidget {
  DisplayGeneratedSchedulesPage({super.key, required this.courses});

  List<Course> courses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Schedules"),
      ),
      body: Container(
          margin: const EdgeInsets.only(right: 10.0),
          child: ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return Container(
                  child: Text("${courses[index].className} start time: ${courses[index].times![0].startTime!.convertToInt()} end time: ${courses[index].times![0].endTime!.convertToInt()}"),
                );
              })),
      // ),
    );
  }
}
