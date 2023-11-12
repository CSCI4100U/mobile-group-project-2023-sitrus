

import 'package:flutter/material.dart';
import 'schedule_display_generated_page.dart';
import '../models/course_model.dart';
import '../models/schedule_formsWidget.dart';

/*
class CreateNewSchedulePage extends StatefulWidget {
  const CreateNewSchedulePage({super.key});

  @override
  State<StatefulWidget> createState() => _CreateNewSchedulePageState();
}

class _CreateNewSchedulePageState extends State<CreateNewSchedulePage> {

  @override
  Widget build(BuildContext context) {

    List<ScheduleFormsWidget> courseWidgets = [
      ScheduleFormsWidget(),
      ScheduleFormsWidget(),
      ScheduleFormsWidget(),
    ];
    List<Course> courses = [];

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Make New Schedules"),
          //TEMPORARY BUTTON TO RELOAD PAGE VIA SETSTATE, WILL NEED TO CREATE A FUNCTION OR SOMETHING TO RELOAD SPECIFIC WIDGETS
          actions: [
            IconButton(
              onPressed: () {
                for (int i = 0; i < courseWidgets.length; i++) {
                  // print("${courseWidgets[i].getCourse().className} start time: ${courseWidgets[i].getCourse().times![0].startTime!.convertToInt()}");
                  courses.add(courseWidgets[i].getCourse());
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DisplayGeneratedSchedulesPage(courses: courses)),
                );
              },
              icon: Icon(Icons.navigate_next),
            )
          ],
        ),
        body: ListView.separated(
            padding: EdgeInsets.all(10.0),
            itemCount: courseWidgets.length, // temp
            separatorBuilder: (context, index) => Divider(height: 2),
            itemBuilder: (context, index) {
              return courseWidgets[index].build(context);
            })
    );
  }
}

 */