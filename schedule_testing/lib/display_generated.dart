import 'package:flutter/material.dart';

import 'schedule_model.dart';
import 'course_model.dart';
import 'schedule_combinations.dart';

import 'rectangle_model.dart';

//display_generated.dart
class DisplayGeneratedSchedulesPage extends StatefulWidget {
  List<Course> coursesFromInput;

  //todo: get numOfCoursesInSchedule from user input
  int numOfCoursesInSchedule = 5; //this will be taken from user input like numFromInput; however, doing hard coded 5 for demo

  DisplayGeneratedSchedulesPage({super.key, required this.coursesFromInput});

  ScheduleCombinations? scheduleCombinations;

  @override
  _DisplayGeneratedSchedulesPageState createState() => _DisplayGeneratedSchedulesPageState();

}

class _DisplayGeneratedSchedulesPageState extends State<DisplayGeneratedSchedulesPage> {

  @override
  void initState() {
    super.initState();
    widget.scheduleCombinations = ScheduleCombinations(coursesFromInput: widget.coursesFromInput);

    //generate all possible combinations of the courses
    widget.scheduleCombinations!.getAllCourseCombinations(widget.coursesFromInput, widget.numOfCoursesInSchedule, []);

    //generate all possible schedules with one section
    for (List<Course> schedule in widget.scheduleCombinations!.schedules) {
      widget.scheduleCombinations!.getAllOneSectionCombinations(schedule);
    }
    //validate schedule sections
    widget.scheduleCombinations!.schedulesOneSection = Schedule.validateSchedulesSections(widget.scheduleCombinations!.schedulesOneSection);

    //generate all possible schedules with one section + one tut
    for (List<Course> schedule in widget.scheduleCombinations!.schedulesOneSection) {
      widget.scheduleCombinations!.getAllOneSectionOneTutorialCombinations(schedule);
    }
    // validate schedule tuts
    widget.scheduleCombinations!.schedulesOneSectionOneTut = Schedule.validateSchedulesTuts(widget.scheduleCombinations!.schedulesOneSectionOneTut);

    //generate all possible schedules with one section + one tut + one lab
    for (List<Course> schedule in widget.scheduleCombinations!.schedulesOneSectionOneTut) {
      widget.scheduleCombinations!.getAllOneSectionOneTutorialOneLabCombinations(schedule);
    }
    //validate scheulde labs
    widget.scheduleCombinations!.schedulesOneSectionOneTutOneLab = Schedule.validateSchedulesLabs(widget.scheduleCombinations!.schedulesOneSectionOneTutOneLab);
  }

  //a List<ClassRectangle> would be list of courses (a single schedule) but
  // represented by the rectangles needed to draw the schedule
  //List<List<ClassRectangle>> is a list of schedules (can be thought of as a list of a list of courses), with each
  // schedule represented by the rectangles that are needed to draw the schedule
  List<List<ClassRectangle>> schedulesAsRectanglesList = [];

  static const double timeFontSize = 14.0;
  static const double dayFontSize = 16.0;

  @override
  Widget build(BuildContext context) {

    initState();
    // getAllCombinations(coursesFromInput, numOfCoursesInSchedule!, []);

    //check all the schedules generated and save the ones that don't have time conflicts
    // List<Schedule>? validatedSchedules = Schedule.validateScheduleSections(schedules!);

    schedulesAsRectanglesList = ClassRectangle.convertSchedulesListToRectangles(widget.scheduleCombinations!.schedulesOneSectionOneTutOneLab);

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
                      for (var day in ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'])
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
