import 'package:flutter/material.dart';
// import 'package:schedule_testing/course_info_widget.dart';

import 'course_info_widget.dart';

//THIS FILE WOULD BE THE GENERATE NEW SCHEDULE PAGE

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF243f6e)),
      home: CreateNewSchedulePage(),
    );
  }
}

class CreateNewSchedulePage extends StatefulWidget {

  @override
  _CreateNewSchedulePageState createState() => _CreateNewSchedulePageState();
}

class _CreateNewSchedulePageState extends State<CreateNewSchedulePage> {

  List<CourseInfoContainer> courseInfoContainerList = [CourseInfoContainer(name: 'Course 1')];

  void addCourseContainer() {
    courseInfoContainerList.add(CourseInfoContainer(name: 'Course ${courseInfoContainerList.length + 1}'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Maker (testing)'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: EdgeInsets.all(10.0),
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: courseInfoContainerList.length,
            itemBuilder: (context, index) {
              return courseInfoContainerList[index];
            },
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 4.0),
            child: OutlinedButton.icon(
              icon: const Icon(Icons.add, size: 36.0,),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.blue[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                textStyle: const TextStyle(fontSize: 36.0,),
              ),
              onPressed: () {
                setState(() {
                  addCourseContainer();
                });
              },
              label: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:  EdgeInsets.only(right: 40.0, top: 30.0, bottom: 30.0),
                    child: Text(
                      "Add Course",
                      style: TextStyle(
                        fontSize: 32.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
