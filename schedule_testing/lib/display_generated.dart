import 'package:flutter/material.dart';

import 'schedule_model.dart';
import 'course_model.dart';
import 'rectangle_model.dart';

//display_generated.dart
class DisplayGeneratedSchedulesPage extends StatelessWidget {
  DisplayGeneratedSchedulesPage({super.key, required this.coursesFromInput});

  List<Course> coursesFromInput;

  //todo: get numOfCoursesInSchedule from user input
  int? numOfCoursesInSchedule = 5;  //this will be taken from user input like
  // coursesFromInput; however, doing hard coded 5 for demo

  List<List<Course>>? schedules = [];

  void getAllCombinations(List<Course> courses, int numOfCoursesInSchedule,
      List<Course> currentCombination) {
    if (numOfCoursesInSchedule == 0) {
      schedules!.add(List.from(currentCombination));
      return;
    }

    for (int i = 0; i <= courses.length - numOfCoursesInSchedule; i++) {
      currentCombination.add(courses[i]);
      getAllCombinations(courses.sublist(i + 1), numOfCoursesInSchedule - 1,
          currentCombination);
      currentCombination.removeLast();
    }
  }

  //this is a list of courses (a single schedule) but
  // represented by the rectangles needed to draw the schedule
  List<CourseRectangle> scheduleAsRectangles = [];

  //this is the list of schedules (can be thought of as a list of a list of courses), with each
  // schedule represented by the rectangles that are needed to draw the schedule
  List<List<CourseRectangle>> schedulesAsRectanglesList = [];

  static const double timeFontSize = 14.0;
  static const double dayFontSize = 16.0;

  @override
  Widget build(BuildContext context) {
    //generate all the possible combinations of nunOfCourseInSchedule-course schedules from
    // the courses given from input
    getAllCombinations(coursesFromInput, numOfCoursesInSchedule!, []);

    //check all the schedules generated and save the ones that don't have time conflicts
    List<Schedule>? validatedSchedules = Schedule.validateSchedules(schedules!);

    schedulesAsRectanglesList =
        CourseRectangle.convertSchedulesListToRectangles(validatedSchedules);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Schedules"),
        ),
        //builds a listview of a visual display of the schedules
        body: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(
              width: 20.0,
              height: 20.0,
            ),
            itemCount: schedulesAsRectanglesList.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 40.0,),
                      for (var day in ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'])
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 9.0), // Adjust the padding as needed
                          child: Text(day, style: const TextStyle(fontSize: dayFontSize)),
                        ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(15, (index) {
                          final hour = index + 8;
                          return Text(
                            "${hour <= 12 ? hour : hour - 12}${hour < 12 ? 'am' : 'pm'}",
                            style: const TextStyle(fontSize: timeFontSize),);
                        }),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 10.0),
                        child: CustomPaint(
                          painter: RectanglePainter(
                            schedulesAsRectanglesList[index],  //this passes a Schedule (as rectangles) aka List<Course> (as rectangles)
                          ),
                          child: Container(
                            height: 280,
                            width: 315,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }));
  }
}
