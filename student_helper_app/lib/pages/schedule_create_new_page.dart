import 'package:flutter/material.dart';
import 'schedule_display_generated_page.dart';
import '../models/schedule_course_model.dart';
import '../models/schedule_input_course_widget.dart';

class CreateNewSchedulePage extends StatefulWidget {
  const CreateNewSchedulePage({super.key});

  @override
  State<StatefulWidget> createState() => _CreateNewSchedulePageState();
}

class _CreateNewSchedulePageState extends State<CreateNewSchedulePage> {

  @override
  Widget build(BuildContext context) {
    //todo (for final): change this so that a CourseWidget is added when a button is pressed
    // instead of having a fixed amount (currently 7 - allows you to test all the functionality so far)
    List<InputCourseWidget> courseWidgets = [
      InputCourseWidget(),
      InputCourseWidget(),
      InputCourseWidget(),
      InputCourseWidget(),
      InputCourseWidget(),
      InputCourseWidget(),
      InputCourseWidget(),
    ];

    List<Course> courses = [];

    //todo (for final): change Colors list so that it's based on the number of courses entered
    // loop through courseWidgets.length and generate a random (no overlap) list
    // of Colors of equal length
    List<Color> colors = [Colors.redAccent, Colors.blue, Colors.green, Colors.yellow, Colors.purpleAccent, Colors.orange, Colors.cyan];

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Make New Schedules"),
          //todo (for final): add a better button? for when the user finishes inputting course info
          actions: [
            IconButton(
              onPressed: () {
                for (int i = 0; i < courseWidgets.length; i++) {
                  courses.add(courseWidgets[i].getCourse(colors[i]));
                  // courses.add(courseWidgets[i].getCourse());
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DisplayGeneratedSchedulesPage(coursesFromInput: courses)),
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
